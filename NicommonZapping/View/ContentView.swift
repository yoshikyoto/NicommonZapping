import SwiftUI
import MapKit

/// unused
struct ContentView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Music Title")
                    .font(.title)

                HStack(alignment: .top) {
                    Text("Musid ID")
                        .font(.subheadline)
                    Spacer()
                    Text("hogehoge")
                        .font(.subheadline)
                }
            }
            .padding()
            Spacer()
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
	
