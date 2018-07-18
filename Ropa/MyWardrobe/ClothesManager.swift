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
    var ref1: DatabaseReference?
    weak var delegate: ClotheseManagerDelegate?
    
    static let share = ClothesManager()//tank
    
    var myUser : User?

    
    
    func getClothes() {
        var clothing: [Clothes] = []
        ref = Database.database().reference()
        
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        
        var userOK = false
        var clothes = false
        
        // 找使用者文章
        ref1 = Database.database().reference().child("clothes")
        let query = ref1?.queryOrdered(byChild: "owner").queryEqual(toValue: "\(uid)")
        
        query?.observeSingleEvent(of: .value, with: { (snapshot) in
           print(snapshot)
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            for key in dictionary.keys {
                guard let valueDictionary = dictionary["\(key)"] as? [String: Any] else { return }
                guard let brand = valueDictionary["brand"] as? String else { return }
                guard let date = valueDictionary["date"] as? String else { return }
                guard let type = valueDictionary["type"] as? String else { return }
                guard let price = valueDictionary["price"] as? String else { return }
                guard let shopLocate = valueDictionary["shopLocate"] as? String else { return }
                
                
                let clothes = Clothes.init(id: "id", img: "img", price: price, brand: brand, type: "type", color: "color", owner: "\(uid)", date: date, shopLocate: shopLocate)
                clothing.append(clothes)
                
                self.delegate?.manager(self, didfetch: clothing)

            }
            
        }
    )}
}
        
        
