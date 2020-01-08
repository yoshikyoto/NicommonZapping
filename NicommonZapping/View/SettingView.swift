import SwiftUI

struct SettingView: View {
    @EnvironmentObject var data: SettingData
    
    var body: some View {
        VStack {
            Text("メールアドレス").frame(maxWidth: .infinity, alignment: .leading)
            TextField("text@example.com", text: $data.email)
            
            Text("パスワード").frame(maxWidth: .infinity, alignment: .leading)
            SecureField("password", text: $data.password)
            
            Text("niconicoユーザーID: \(self.data.userId)")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("セッション情報").frame(maxWidth: .infinity, alignment: .leading)
            Text(self.data.userSession).frame(maxWidth: .infinity, alignment: .leading)
            
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

