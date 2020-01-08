import Foundation

class RegexProcessor {
    public init() {
        
    }
    
    public func getUserIdFromSession(userSession: String) -> String? {
        return self.getFirstGroup(
            target: userSession,
            pattern: "user_session_([0-9]+)_"
        )
    }
    
    /// in の中から withPattern の group（カッコでくくられた部分）を返す
    /// 最初に見つかった部分を返す
    public func getFirstGroup(target: String, pattern: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            guard let matched = regex.firstMatch(in: target, range: NSRange(location: 0, length: target.count)) else {
                print("正規表現にマッチしない")
                return nil
            }
            
            let from = target.index(target.startIndex, offsetBy: matched.range(at: 1).location)
            let to = target.index(from, offsetBy: matched.range(at: 1).length - 1)
            return target[from...to].description
        } catch {
            print("正規表現エラー")
            return nil
        }
    }
}
