//
//  AudioRow.swift
//  NicommonZapping
//
//  Created by 坂本　祥之　 on 2019/12/29.
//  Copyright © 2019 yoshikyoto. All rights reserved.
//

import SwiftUI

struct Audio {
    let id: String
    let title: String
}

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
        AudioRow(audio: Audio(id: "nc123", title:"サンプル"))
    }
}
