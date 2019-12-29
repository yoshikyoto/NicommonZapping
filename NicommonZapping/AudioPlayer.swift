import Foundation
import AVFoundation

class AudioPlayer {
    
    public init() {
    }
    
    public func play(data: Data) {
        do {
            let player = try AVAudioPlayer(data: data)
            player.prepareToPlay()
            player.play()
        } catch {
            print("audio play error")
        }
    }
}
