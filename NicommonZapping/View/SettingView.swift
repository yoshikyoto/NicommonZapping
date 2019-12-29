import SwiftUI

struct SettingView: View {
    @EnvironmentObject var data: SettingData
    
    var body: some View {
        VStack {
            Text("メールアドレス").frame(maxWidth: .infinity, alignment: .leading)
            TextField("text@example.com", text: $data.email)
            
            Text("パスワード").frame(maxWidth: .infinity, alignment: .leading)
            TextField("password", text: $data.password)
            
            Spacer()
        }
        .padding()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

