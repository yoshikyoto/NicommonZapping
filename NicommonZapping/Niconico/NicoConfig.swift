import Foundation

public class NicoConfig {
    let userAgent = "NicoCommonsZapping twitter: @yoshiki_utakata"
    
    static let shared = NicoConfig()
    
    private init() {
    }
    
    public func setUp() {
        URLSessionConfiguration.default.httpAdditionalHeaders = [
            "User-Agent": self.userAgent
        ]
    }
}
