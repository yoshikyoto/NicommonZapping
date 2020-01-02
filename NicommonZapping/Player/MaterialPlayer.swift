import Foundation
import AVKit

/// 再生回りをいい感じにやってくれるクラス
public class MaterialPlayer {
    let storage: MaterialStorage
    let downloader: NicoCommonsMaterialDownloader
    let state: AudioData
    var player: AVPlayer?
    
    /// シングルトン
    public static let shared = MaterialPlayer()
    
    private init (
        storage: MaterialStorage = MaterialStorage(),
        downloader: NicoCommonsMaterialDownloader = NicoCommonsMaterialDownloader(),
        state: AudioData = AudioData.shared
    ) {
        self.storage = storage
        self.downloader = downloader
        self.state = state
        // 秒以下は表示しないので更新は1秒ごとでよい
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.updateStateItemDuration()
            self.updateStateCurrentTime()
        })
    }
    
    /// stateのitemDurationを更新する
    private func updateStateItemDuration() {
        guard let durationSeconds = self.player?.currentItem?.duration.seconds else {
            state.playerItemDurationSeconds = 0
            return
        }
        state.playerItemDurationSeconds = Int(durationSeconds)
    }
    
    /// stateの現在のポジションを更新する
    private func updateStateCurrentTime() {
        guard let seconds = self.player?.currentTime().seconds else {
            state.playerCurrentTimeSeconds = 0
            return
        }
        state.playerCurrentTimeSeconds = Int(seconds)
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
    
    /// ファイルの存在を確認せず与えられたidを再生しようとする
    private func justPlay(globalId: String) {
        // ここに来る時点でファイルは存在しているなければならない
        let url = self.storage.getUrl(globalId: globalId)!
        self.player = AVPlayer(url: url)
        self.player!.play()
        
    }
}
