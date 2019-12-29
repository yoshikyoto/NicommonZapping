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
            Text(audio.globalId)
        }
    }
}

/*
struct AudioRow_Previews: PreviewProvider {
    static var previews: some View {
        AudioRow(audio: Audio(
            id: 123,
            globalId: "nc123",
            title: "Audio Title",
            url: URL()
        ))
    }
}
*/
