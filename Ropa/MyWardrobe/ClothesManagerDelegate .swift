//
//  ClothesManagerDelegate .swift
//  Ropa
//
//  Created by Chen Hsin on 2018/6/25.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import Foundation
protocol ClotheseManagerDelegate: class {
    func manager(_ manager: ClothesManager, didfetch Clothing:[Clothes])
    
     func manager(_ manager: ClothesManager, didFaithWith error: Error)
}
