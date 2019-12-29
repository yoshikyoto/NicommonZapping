import SwiftUI
import Combine

final class AudioData: ObservableObject {
    @Published var audios: [Audio] = []
    @Published var playingIndex: Int = 0
}
