import Foundation
import AVKit

public class NicoCommonsMaterialDownloader {
    let setting: SettingData
    var player: AVPlayer?
    
    public init(setting: SettingData = SettingData.shared) {
        self.setting = setting
        self.player = nil
    }
    
    public func agree(id: Int, onSuccess: @escaping () -> Void) {
        self.accessToDownloadPage(id: id, onSuccess: onSuccess)
    }
    
    public func accessToDownloadPage(
        id: Int,
        onSuccess: @escaping () -> Void
    ) {
        // agreement のページを開く
        let url = URL(string: "https://commons.nicovideo.jp/material/agreement")!
        
        // agreement のページに POST リクエストを送る。bodyに数字のidをつけて渡してあげる
        let bodyString = "id=\(id)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                print("ダウンロードページを開こうとしてエラー")
                return
            }
            self.clickDownloadButton(id: id, onSuccess: onSuccess)
        }
        task.resume()
    }
    
    private func clickDownloadButton(id: Int, onSuccess: @escaping () -> Void) {
        // ここでは id ではなくて globalId （ncつきのやつ）
        // id しか渡されてないので globalId にここで変換している
        let globalId = "nc\(id)"
        
        // ここにアクセスするとダウンロードページにリダイレクトされる
        // リダイレクトまでちゃんと処理されて素材がダウンロードされる
        let url = URL(string: "https://commons.nicovideo.jp/material/download/" + globalId)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                print("コモンズからダウンロードしようとした時にネットワークエラー")
                return
            }
            guard let data = data else {
                print("コモンズからダウンロードしようとした時にエラー")
                return
            }
            
            // レスポンスから添付ファイル名を取り出す
            // mp3 とか、拡張子をつけた状態で保存しないと正しく再生できないため
            guard let contentDisposition = httpResponse.allHeaderFields["Content-Disposition"] as? String else {
                print("コモンズからダウンロードしようとしたけど添付ファイルがついていなかった")
                return
            }
            guard let filename = self.getFilename(contentDisposition: contentDisposition) else {
                print("コモンズからダウンロードしたファイル名の抽出に失敗")
                return
            }
            
            // 保存する
            let storage = MaterialStorage()
            let audioUrl = storage.save(data: data, globalId: globalId, filename: filename)
            onSuccess()
        }
        task.resume()
    }
    
    private func getFilename(contentDisposition: String) -> String? {
        let pattern = "filename=\"[^\"]+\""
        let regex = try! NSRegularExpression(pattern: pattern)
        guard let matched = regex.firstMatch(
            in: contentDisposition,
            range: NSRange(location: 0, length: contentDisposition.count)
        ) else {
            // 正規表現の処理中にエラーが起きた場合
            print("contentDisposition からファイル名を抽出する正規表現でエラー")
            return nil
        }
        
        // filename=" の 10 文字を除く
        let from = contentDisposition.index(
            contentDisposition.startIndex,
            offsetBy: matched.range.location + 10
        )
        // " を取り除く
        let to = contentDisposition.index(
            from,
            offsetBy: matched.range.length - 10 - 1 - 1
        )
        // この result は String.subsequence 型である
        let result = contentDisposition[from...to]
        return result.description
    }
}
