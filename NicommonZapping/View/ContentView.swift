//
//  ContentView.swift
//  NicommonZapping
//
//  Created by 坂本　祥之　 on 2019/12/25.
//  Copyright © 2019 yoshikyoto. All rights reserved.
//

import SwiftUI
import MapKit

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
	
