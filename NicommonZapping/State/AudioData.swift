import SwiftUI
import Combine

final class AudioData: ObservableObject {
    @Published var audios: [Audio] = []
    @Published var nowPlayngGlobalId: String = ""
    
    /// シングルトン
    public static let shared = AudioData()
    private init() {
    }
}
