//
//  OutfitManagerDelegate.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/27.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import Foundation
protocol MyOutfitManagerDelegate: class {
    func manager(_ manager: MyOutfitManager, didfetch Outfits:[Outfit])
    
    func manager(_ manager: MyOutfitManager, didFaithWith error: Error)
}


