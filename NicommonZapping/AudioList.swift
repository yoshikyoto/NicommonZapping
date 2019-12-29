//
//  AudioList.swift
//  NicommonZapping
//
//  Created by 坂本　祥之　 on 2019/12/29.
//  Copyright © 2019 yoshikyoto. All rights reserved.
//

import SwiftUI

struct AudioList: View {
    let audios = [
        Audio(id: "nc123", title:"サンプル"),
        Audio(id: "nc121", title:"サンプル2"),
    ]
    
    var body: some View {
        List(audios, id: \.id) { audio in
            AudioRow(audio: audio)
        }
    }
}

struct AudioList_Previews: PreviewProvider {
    static var previews: some View {
        AudioList()
    }
}
