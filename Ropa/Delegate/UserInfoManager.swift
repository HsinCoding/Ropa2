//
//  File.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/2.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserInfoManager {
    var ref: DatabaseReference?
    weak var delegate: UserInfoManagerDelegate?
    
    func getUserInfo() {
        var userInfo = ""
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        
        ref = Database.database().reference().child("userInfo").child(uid)
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            for key in dictionary.keys {
                guard let valueDictionary = dictionary["\(key)"] as? [String:Any] else { return }
                guard let email = valueDictionary["email"] as? String else { return }
                guard let myFavorite = valueDictionary["myFavorite"] as? String else { return }
                guard let userName = valueDictionary["userName"] as? String else { return }
                let userInfo = UserInfo.init(userName: userName, email: email, userBirthday: "birthday", myfavorite: [myFavorite])
               
                self.delegate?.manager(self, didfetch: userInfo)
                
            }
          
            
           
        })
     
    }
    
    
    
}
