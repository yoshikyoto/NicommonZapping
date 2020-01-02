//
//  TimeView.swift
//  NicommonZapping
//
//  Created by 坂本　祥之　 on 2020/01/02.
//  Copyright © 2020 yoshikyoto. All rights reserved.
//

import SwiftUI

/// 秒を与えると m:ss 表示にしてくれる
struct TimeView: View {
    var seconds: Int;
    var body: some View {
        Text(String(format: "%d:%02d", seconds / 60, seconds % 60))
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView(seconds: 10000)
    }
}
