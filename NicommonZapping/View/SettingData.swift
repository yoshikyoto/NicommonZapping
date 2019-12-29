import Foundation

/// 設定を保存する
final class SettingData: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    /// シングルトン
    static let shared = SettingData()
    
    /// シングルトンなので外部での初期化禁止
    private init() {}
}
