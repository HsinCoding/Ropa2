//
//  ClothesManager.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/6/25.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class ClothesManager {
    var ref: DatabaseReference?
    weak var delegate: ClothesManagerDelegate?
    
    static let share = ClothesManager()//tank
    
//    var myUser : User?

    func getClothes() {
        var clothing: [Clothes] = []
      
        
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        
        // 找使用者單品
        ref = Database.database().reference().child("clothes")
        let query = ref?.queryOrdered(byChild: "owner").queryEqual(toValue: "\(uid)")
        
        query?.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            for key in dictionary.keys {
                guard let valueDictionary = dictionary["\(key)"] as? [String: Any] else { return }
                guard let brand = valueDictionary["brand"] as? String else { return }
                guard let date = valueDictionary["date"] as? String else { return }
                guard let color = valueDictionary["color"] as? String else { return }
                guard let type = valueDictionary["type"] as? String else { return }
                guard let imgUrl = valueDictionary["imgUrl"] as? String else { return }
                guard let price = valueDictionary["price"] as? String else { return }
                guard let shopLocate = valueDictionary["shopLocate"] as? String else { return }
                
                let clothes = Clothes.init(id: "id", img:imgUrl, price: price, brand: brand, type: "\(type)", color: color, owner: "\(uid)", date: date, shopLocate: shopLocate)
                clothing.append(clothes)
                
                self.delegate?.manager(self, didfetch: clothing)

            }
        }
    )}
}
        
        
