import Foundation
/*
public class StarClient {
    let urlSession: URLSession
    let jsonDecoder: JSONDecoder
    let urlString: String = "https://nicommon-zapping.herokuapp.com"
    
    public init(
        urlSession: URLSession = URLSession.shared,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.dateDecodingStrategy = .iso8601
    }
    
    public func get(
        onSuccess: @escaping (String) -> Void,
        onFail: @escaping (String) -> Void
    ) {
        let urlComponents = URLComponents(
            string: self.urlString +
        )!

        // リクエストを生成
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.httpBody = formData.data(using: .utf8)!
        
        let task = self.urlSession.dataTask(with: request) { (data, urlResponse, error) in
            guard let data = data else {
                // レスポンスが返ってこなかった
                onFail()
                return
            }
            guard let userSession = self.xmlParser.getUserSession(data: data) else {
                // レスポンスは返ってきたが何かおかしい
                // ログイン的なかったなど
                onFail()
                return
            }
            // セッションが取れた場合
            onSuccess(userSession)
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
*/
