//
//  Outfit.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/17.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import Foundation

struct Outfit: Codable {
    let id: String
    let img: String
    let style: String
    let season: String
    let note: String
    let isPublic: String
    let date: String
    let owner: String
//    let like: Int
}
