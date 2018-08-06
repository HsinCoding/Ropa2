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
        var userInfo: [UserInfo] = []
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
         print("第A個")
        ref = Database.database().reference().child("userInfo").child(uid)
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
             print("第零個")
            for key in dictionary.keys {
                print("第B個")
                guard let valueDictionary = dictionary["\(key)"] as? [String:Any] else { return }
                print("第一個")
                guard let email = valueDictionary["email"] as? String else { return }
                 print("第二個")
                guard let myFavorite = valueDictionary["myFavorite"] as? String else { return }
                 print("第三個")
                guard let userName = valueDictionary["userName"] as? String else { return }
                 print("第四個")
                let userSingle = UserInfo.init(userName: userName, email: email, userBirthday: "Birthday", myfavorite: [myFavorite], img: "imgUrl")
                print("第五個",userSingle)
                userInfo.append(userSingle)
                
                self.delegate?.manager(self, didfetch: userInfo)
                
            }

        })
    }  
}
