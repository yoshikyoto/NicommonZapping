import Foundation

class AlertManager {
    static let shared = AlertManager()
    public init() {
    }
    
    public func showAlert(message: String) {
        AudioData.shared.alertMessage = message
        AudioData.shared.isShowingAlert = true
    }
}
