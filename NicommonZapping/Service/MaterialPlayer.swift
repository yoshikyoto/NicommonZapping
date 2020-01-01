import Foundation
import AVKit

/// 再生回りをいい感じにやってくれるさ
public class MaterialPlayer {
    let storage: MaterialStorage
    let downloader: NicoCommonsMaterialDownloader
    var player: AVPlayer?
    
    public init (
        storage: MaterialStorage = MaterialStorage(),
        downloader: NicoCommonsMaterialDownloader = NicoCommonsMaterialDownloader()
    ) {
        self.storage = storage
        self.downloader = downloader
    }
    
    public func play(globalId: String) {
        
    }
}
