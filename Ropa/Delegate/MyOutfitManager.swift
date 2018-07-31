//
//  MyOutfitManager.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/27.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class MyOutfitManager {
    var ref: DatabaseReference?
    weak var delegate: MyOutfitManagerDelegate?
    
//    static let share = MyOutfitManager()
    
    func getMyOutfit() {
        var outfits: [Outfit] = []
        
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        
        //找使用者搭配
        ref = Database.database().reference().child("outfit")
        let query = ref?.queryOrdered(byChild: "owner").queryEqual(toValue: "\(uid)")
       
        query?.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            print("第一個沒問題")
            for key in dictionary.keys {
                guard let valueDictionary = dictionary["\(key)"] as? [String: Any] else { return }
                 print("第二個沒問題")
                guard let date = valueDictionary["date"] as? String else { return }
                 print("第三個沒問題")
                guard let imgUrl = valueDictionary["imgUrl"] as? String else { return }
                 print("第四個沒問題")
                guard let isPublic = valueDictionary["isPublic"] as? String else { return }
                 print("第五個沒問題")
                guard let note = valueDictionary["note"] as? String else { return }
                 print("第六個沒問題")
                guard let season = valueDictionary["season"] as? String else { return }
                 print("第七個沒問題")
                guard let style = valueDictionary["style"] as? String else { return}
                print("第八個沒問題")
                let outfit = Outfit.init(id: "id", img: imgUrl, style: style, season: season, note: note, isPublic: isPublic, date: date, owner: uid)
                
                outfits.append(outfit)
                self.delegate?.manager(self, didfetch: outfits)
            }
        })
    }
}
