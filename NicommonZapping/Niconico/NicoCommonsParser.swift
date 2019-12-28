import Foundation
import Kanna

/// コモンズの検索結果をパースするクラス
public class NicoCommonsParser {
    public init() {
    }
    
    /// コモンズの検索結果をパースする
    public func parse(data: Data) {
        print("start parsing")
        do {
            let doc = try HTML(html: data, encoding: .utf8)
            print("parsed")
            // .cmd_thumb_L がサムネイルの部分
            // .cmd_thumb_R が右側の部分
            // 右側の部分のaタグ部分を全部探す
            let aTags = doc.css("td div.cmn_thumb_frm div.cmn_thumb_R p a")
            for a in aTags {
                print(a.innerHTML)
            }
        } catch {
            print(error)
        }
    }
}
