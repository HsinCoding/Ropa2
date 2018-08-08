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
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            
            for key in dictionary.keys {
                guard let valueDictionary = dictionary["\(key)"] as? [String: Any] else { return }
                guard let date = valueDictionary["date"] as? String else { return }
                guard let imgUrl = valueDictionary["imgUrl"] as? String else { return }
                guard let isPublic = valueDictionary["isPublic"] as? String else { return }
//               guard let isPublic = valueDictionary["isPublic"] as? Bool else { return }
                guard let note = valueDictionary["note"] as? String else { return }
                guard let season = valueDictionary["season"] as? String else { return }
                guard let style = valueDictionary["style"] as? String else { return}
                let outfit = Outfit.init(id: "id", img: imgUrl, style: style, season: season, note: note, isPublic: isPublic, date: date, owner: uid)
                
                outfits.append(outfit)
                self.delegate?.manager(self, didfetch: outfits)
            }
        })
    }
}
