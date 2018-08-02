//
//  UserInfoManagerDelegate.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/2.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import Foundation
protocol UserInfoManagerDelegate: class {
    func manager(_ manager: UserInfoManager, didfetch UserInfo: [UserInfo])
    
    func manager(_ manager: UserInfoManager, didFaithWith error: Error)
}
