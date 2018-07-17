//
//  User.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/15.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import Foundation
class User {
 
    let uid : String
    var myfavorite : Array<String>
    var myClothes : Array<Clothes> //自己的衣服
    var myOutfit : Array<Outfit> = []
    
    
    init(uid: String,myfavorite : Array<String>, myClothes: Array<Clothes>, myOutfit:  Array<Outfit>) {
        self.uid = uid
        self.myfavorite = myfavorite
        self.myClothes = myClothes
        self.myOutfit = myOutfit
//        self.myfavorite = myfavorite.components(separatedBy: ",")
//        self.myOutfit = myOutfit.components(separatedBy: ",")
    }
    
}
