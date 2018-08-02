//
//  OutfitWallManager.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/1.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class OutfitWallManager {
    var ref: DatabaseReference?
    weak var delegate: OutfitWallManagerDelegate?
    
    func getOutfitWall(){
        
        var outfitWall:[Outfit] = []
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        
        ref = Database.database().reference().child("outfit")
        let query = ref?.queryOrdered(byChild: "isPublic").queryEqual(toValue: "true")
        query?.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            print("第零個")
            for key in dictionary.keys {
                guard let valueDictionary = dictionary["\(key)"] as? [String:Any] else { return }
                print("第一個")
                guard let date = valueDictionary["date"] as? String else { return }
                print("第二個")
                guard let owner = valueDictionary["owner"] as? String else { return }
                print("第三個")
                guard let imgUrl = valueDictionary["imgUrl"] as? String else { return }
                 print("第四個")
                guard let note = valueDictionary["note"] as? String else { return }
                 print("第五個")
                guard let season = valueDictionary["season"] as? String else { return }
                print("第六個")
                guard let style = valueDictionary["style"] as? String else { return }
                print("第七個")
                let outfit = Outfit.init(id: "id", img: imgUrl, style: style, season: season, note: note, isPublic: "true", date: date, owner: owner)
                outfitWall.append(outfit)
                self.delegate?.manager(self, didfetch: outfitWall)
            }
        })
    }
}
