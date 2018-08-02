//
//  OutfitWallManagerDelegate.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/1.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import Foundation
protocol OutfitWallManagerDelegate: class {
    func manager(_ manager: OutfitWallManager, didfetch OutfitWall: [Outfit])
    
    func manager(_ manager: OutfitWallManager, didFaithWith error: Error)
}
