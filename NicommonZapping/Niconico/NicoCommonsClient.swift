import Foundation

public class NicoCommonsClient {
    let urlSession: URLSession
    let parser: NicoCommonsParser
    
    public init(
        urlSession: URLSession = URLSession.shared,
        parser: NicoCommonsParser = NicoCommonsParser()
    ) {
        self.urlSession = urlSession
        self.parser = parser
    }
    
    public func searchAudio() {
        print("searchAudio")
        /// これはエラーにならないはずなので ! してしまう
        var urlComponents = URLComponents(string: "https://commons.nicovideo.jp/search/material/audio")!
        let queryItems = [
            URLQueryItem(name: Sort.name, value: Sort.createdAt),
            URLQueryItem(name: Order.name, value: Order.desc),
        ]
        urlComponents.queryItems = queryItems
        
        /// エラーにならないはずなので ! してしまう
        let request = URLRequest(url: urlComponents.url!)
        print("request!")
        print(request)
        let task = self.urlSession.dataTask(with: request) { (data, urlResponse, error) in
            print("task result")
            guard let data = data else {
                print("Request Error")
                return
            }
            print("success")
            print(data)
            self.parser.parse(data: data)
        }
        task.resume()
    }
}

struct Sort {
    /// sort をクエリで指定するときの key
    static let name = "s"
    
    /// 登録順
    static let createdAt = "c"
}

struct Order {
    /// order をクエリで指定する時の key
    static let name = "o"
    
    /// 昇順
    static let asc = "a"
    /// 降順
    static let desc = "d"
}
