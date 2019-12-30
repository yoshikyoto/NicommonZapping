import Foundation

public class NicoXmlParser {
    public init () {
    }
    
    public func getUserSession(data: Data) -> String? {
        guard let str = String(data: data, encoding: .utf8) else {
            // 与えられたデータがおかしい場合
            return nil
        }
        
        let pattern = "<session_key>([^</>]+)</session_key>"
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            // 正規表現がおかしい場合とか
            // 普通はここには来ない
            return nil
        }
        guard let matched = regex.firstMatch(in: str, range: NSRange(location: 0, length: str.count)) else {
            // 正規表現の処理中にエラーが起きた場合
            return nil
        }
        
        // <session_key> の 13 文字を除く
        let from = str.index(str.startIndex, offsetBy: matched.range.location + 13)
        // </session_key> の 14 文字と、なぜか1文字長くなるので15文字引く
        let to = str.index(from, offsetBy: matched.range.length - 13 - 14 - 1)
        // この result は String.subsequence 型である
        let result = str[from...to]
        return result.description
    }
}
