import SwiftUI
import Combine

/// オーディオに関する状態を管理するクラス
public final class AudioData: ObservableObject {
    @Published var audios: [Audio] = []
    /// 今何秒地点を再生しているか
    @Published var playerCurrentTimeSeconds: Int = 0
    /// 再生中の音楽の長さ
    @Published var playerItemDurationSeconds: Int = 0
    /// お気に入り情報 keyはid
    @Published var stars: [Int: Star] = [:]
    /// ポップアップアラートで表示する文言など
    @Published var isShowingAlert: Bool = false
    @Published var alertMessage: String = ""
    /// 再生中の曲
    @Published var playingGlobalId: String = ""
    /// ダウンロード中の曲
    @Published var downloadingIds: Set<Int> = []
    
    /// シングルトン
    public static let shared = AudioData()
    private init() {
    }
}


enum Star {
    case stared, pending
}
