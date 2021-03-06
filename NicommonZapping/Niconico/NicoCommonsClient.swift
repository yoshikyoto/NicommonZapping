import Foundation

public class NicoCommonsClient {
    let urlSession: URLSession
    let queryBuilder: QueryBuilder
    let jsonDecoder: JSONDecoder
    let xmlParser: NicoXmlParser
    
    static let shared = NicoCommonsClient()
    
    public init(
        urlSession: URLSession = URLSession.shared,
        queryBuilder: QueryBuilder = QueryBuilder(),
        jsonDecoder: JSONDecoder = JSONDecoder(),
        xmlParser: NicoXmlParser = NicoXmlParser()
    ) {
        self.urlSession = urlSession
        self.queryBuilder = queryBuilder
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.dateDecodingStrategy = .iso8601
        self.xmlParser = xmlParser
    }
    
    public func login(
        mail: String,
        password: String,
        onSuccess: @escaping (String) -> Void,
        onFail: @escaping (String) -> Void
    ) {
        let urlComponents = URLComponents(
            string: "https://secure.nicovideo.jp/secure/login"
        )!
        let formData = "mail=\(mail)&password=\(password)&site=nicobox"

        // リクエストを生成
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.httpBody = formData.data(using: .utf8)!
        
        let task = self.urlSession.dataTask(with: request) { (data, urlResponse, error) in
            guard let data = data else {
                // レスポンスが返ってこなかった
                onFail("ニコニコのサーバーからレスポンスがありませんでした")
                return
            }
            guard let userSession = self.xmlParser.getUserSession(data: data) else {
                // レスポンスは返ってきたが何かおかしい
                // ログイン的なかったなど
                onFail("ニコニコへのログインに失敗しました")
                return
            }
            // セッションが取れた場合
            onSuccess(userSession)
        }
        task.resume()
    }
    
    /// idを渡すとその素材のダウンロードURLを返す
    public func getDownloadUrl(material: NicoCommonsMaterial) -> URLComponents {
        return URLComponents(
            string: "https://deliver.commons.nicovideo.jp/download/\(material.globalId)"
        )!
    }
    
    public func searchAudio(
        onSuccess: @escaping (NicoCommonsSearchData) -> Void
    ) {
        // これはエラーにならないはずなので ! してしまう
        var urlComponents = URLComponents(string: "https://public-api.commons.nicovideo.jp/v1/materials/search/tags")!
        let queryItems = self.queryBuilder.build(
            sort: Sort.START_TIME_DESC,
            materialType: MaterialType.AUDIO,
            permissionScopes: [PermissionScope.ALL],
            commercialUses: [CommercialUse.OK]
        )
        urlComponents.queryItems = queryItems
        // TODO user-agent をつける
        // エラーにならないはずなので ! してしまう
        let request = URLRequest(url: urlComponents.url!)
        let task = self.urlSession.dataTask(with: request) { (data, urlResponse, error) in
            // TODO ステータスコード見たほうが良い気がする
            guard let data = data else {
                // TODO エラー時の処理
                print("Request Error")
                return
            }
            // レスポンスのパース
            do {
                let response = try self.jsonDecoder.decode(NicoCommonsSearchResponse.self, from: data)
                // データが取得できた場合
                onSuccess(response.data)
            } catch {
                // レスポンスのパースに失敗した場合
                // TODO エラー処理
                return
            }
        }
        task.resume()
    }
}

/// コモンズの検索APIのレスポンス
struct NicoCommonsSearchResponse: Codable {
    let data: NicoCommonsSearchData
}

public struct NicoCommonsSearchData: Codable {
    let materials: [NicoCommonsMaterial]
}

public struct NicoCommonsMaterial: Codable {
    /// id は数字のみのID
    let id: Int
    /// globalId は ncXXXX 形式のID
    let globalId: String
    let title: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case globalId = "global_id"
        case title = "title"
    }
}

/// コモンズの検索APIのクエリを生成する
public class QueryBuilder {
    public init() {
    }
    
    /// クエリを生成する
    /// materialType は実際は複数選択できるが、ここでは一つしか受け付けないとする
    public func build(
        sort: String,
        limit: Int = 30,
        offset: Int = 0,
        materialType: Int,
        permissionScopes: [Int],
        commercialUses: [Int]
    ) -> [URLQueryItem] {
        var queryItems = [
            URLQueryItem(name: "_sort", value: sort),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset)),
        ]
        // API的には複数選択できるが、ここでは一つしか選択できない仕様とする
        queryItems.append(URLQueryItem(
            name: "filters[materialType][0]",
            value: String(materialType)
        ))
        
        // これらはインタフェースは複数とれるようになっているが、
        // 複数選択できる必要が出てきてから実装する
        queryItems.append(URLQueryItem(
            name: "filters[permissionScope][0]",
            value: String(permissionScopes[0])
        ))
        queryItems.append(URLQueryItem(
            name: "filters[commercialUse][0]",
            value: String(commercialUses[0])
        ))
        return queryItems
    }
}

/// 作品種類
struct MaterialType {
    /// 音声
    static let AUDIO = 2
}

/// 利用許可範囲
struct PermissionScope {
    /// インターネット全体
    static let ALL = 1
}

/// 営利利用
struct CommercialUse {
    /// 営利利用可
    static let OK = 0
}

struct Sort {
    static let START_TIME_DESC = "-startTime"
}
