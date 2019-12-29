//
//  AudioRow.swift
//  NicommonZapping
//
//  Created by 坂本　祥之　 on 2019/12/29.
//  Copyright © 2019 yoshikyoto. All rights reserved.
//

import SwiftUI

struct AudioRow: View {
    let audio: Audio
    
    var body: some View {
        HStack {
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
