
//
//  NicoCommonsApi.swift
//  NicommonZapping
//
//  Created by 坂本　祥之　 on 2019/12/25.
//  Copyright © 2019 yoshikyoto. All rights reserved.
//

import Foundation

public class NicoCommonsClient {
    let urlSession: URLSession
    
    public init(
        urlSession: URLSession = URLSession.shared
    ) {
        self.urlSession = urlSession
    }
    
    public func searchAudio() {
        var urlComponents = URLComponents(string: 'http://commons.nicovideo.jp/search/material/audio')
        let queryItems = [
            URLQueryItem(name: Sort.name, value: Sort.createdAt),
            URLQueryItem(name: Order.name, value: Order.desc),
        ]
    }
}

struct Sort {
    /// sort をクエリで指定するときの key
    static let name = 's'
    /// 登録順
    static let createdAt = 'c'
}

struct Order {
    static let name = 'o'
    static let asc = 'a'
    static let desc = 'd'
}
