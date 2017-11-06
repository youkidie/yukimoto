//
//  YukimotoConfig.swift
//  yukimoto
//
//  Created by 雪本大樹 on 2017/11/06.
//  Copyright © 2017年 雪本大樹. All rights reserved.
//

import Foundation

class YukimotoConfig {
    #if DEBUG
    static let YUKIMOTO_API_URI_BASE = "http://v150-95-140-235.a085.g.tyo1.static.cnode.io/api/v1"
    #else
    static let YUKIMOTO_API_URI_BASE = "http://v150-95-140-235.a085.g.tyo1.static.cnode.io:8080/api/v1"
    #endif
    
    static func GetApiUriBase() -> String {
        let envValue = ProcessInfo().environment["YUKIMOTO_API_URI_BASE"];
        if envValue != nil {
            return envValue!
        } else {
            return YUKIMOTO_API_URI_BASE
        }
    }
}
