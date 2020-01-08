import Foundation

/// コモンズのオーディオの情報
struct Audio {
    let id: Int
    let globalId: String
    let title: String
    let url: URL
    let star: Star
}

enum Star {
    case stared, notStared, pending
}
