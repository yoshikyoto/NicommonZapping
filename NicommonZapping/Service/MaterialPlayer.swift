import Foundation
import AVKit

/// 再生回りをいい感じにやってくれるクラス
public class MaterialPlayer {
    let storage: MaterialStorage
    let downloader: NicoCommonsMaterialDownloader
    var player: AVPlayer?
    
    /// シングルトン
    public static let shared = MaterialPlayer()
    
    private init (
        storage: MaterialStorage = MaterialStorage(),
        downloader: NicoCommonsMaterialDownloader = NicoCommonsMaterialDownloader()
    ) {
        self.storage = storage
        self.downloader = downloader
        try! AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
    }
    
    public func play(id: Int) {
        let globalId = "nc\(id)"
        if !self.storage.exists(globalId: globalId) {
            // ファイルが存在しない場合
            // ダウンロードしたうえで再生
            print("ファイルがキャッシュされていないのでダウンロードして再生します")
            self.downloader.download(id: id, onSuccess: { () in
                self.justPlay(globalId: globalId)
            })
            return
        }
        // ファイルが有る場合は再生
        self.justPlay(globalId: globalId)
    }
    
    private func justPlay(globalId: String) {
        // TODO すでに存在している場合はstopする
        
        // ここに来る時点でファイルは存在しているなければならない
        let url = self.storage.getUrl(globalId: globalId)!
        self.player = AVPlayer(url: url)
        self.player!.play()
    }
}
