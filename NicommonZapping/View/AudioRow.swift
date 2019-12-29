import SwiftUI

struct AudioRow: View {
    let audio: Audio
    
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .imageScale(.medium)
                .foregroundColor(.yellow)
            Text(audio.title)
            Spacer()
            Text(audio.id)
        }
    }
}

struct AudioRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AudioRow(audio: Audio(id: "nc123", title:"サンプル"))
            AudioRow(audio: Audio(id: "nc121", title:"サンプル2"))
        }.previewLayout(.fixed(width: 300, height: 70))
    }
}
