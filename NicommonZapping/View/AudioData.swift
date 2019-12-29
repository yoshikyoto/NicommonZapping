import SwiftUI
import Combine

final class AudioData: ObservableObject {
    @Published var audios: [Audio] = []
}
