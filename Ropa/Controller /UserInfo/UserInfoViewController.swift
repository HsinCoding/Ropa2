//
//  UserInfoViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/6.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var clothesAmountLabel: UILabel!
    @IBOutlet weak var outfitAmountLabel: UILabel!
    var ref: DatabaseReference?
    
    let userInfoManager = UserInfoManager()
    var userNameString = ""
    var clothing: [Clothes] = []
    var userNameForUpdate = ""
   
    func getClothesAmount() {
        
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
       
        // 找使用者單品
        ref = Database.database().reference().child("clothes")
        let query = ref?.queryOrdered(byChild: "owner").queryEqual(toValue: "\(uid)")
        
        query?.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            if snapshot.childrenCount == 0 {
                self.clothesAmountLabel.text = "0"
            }
            else {
                self.clothesAmountLabel.text = String(snapshot.childrenCount)
            }
        }
    )}
    
    func getOutfitAmount() {
        
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        
        //找使用者搭配
        ref = Database.database().reference().child("outfit")
        let query = ref?.queryOrdered(byChild: "owner").queryEqual(toValue: "\(uid)")
        
        query?.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            if snapshot.childrenCount == 0 {
                self.outfitAmountLabel.text = "0"
            }
            else {
                 self.outfitAmountLabel.text = String(snapshot.childrenCount)
            }
          
        })
    }
    
    
    
    
    
    func getUserInfo() {
        
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        print("第A個")
        ref = Database.database().reference().child("userInfo").child(uid)
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let email = dictionary["email"] as? String else { return }
            guard let myFavorite = dictionary["myFavorite"] as? String else { return }
            guard let userName = dictionary["userName"] as? String else { return }
            self.userNameForUpdate = userName
            self.userNameLabel.text = userName
            self.userEmailLabel.text = email
            self.clothesAmountLabel.text = String(self.clothing.count)
        
        })
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
        getClothesAmount()
        getOutfitAmount()
       
    }
    
    
    @IBAction func toUpdateButton(_ sender: UIBarButtonItem) {
        
        guard let user = Auth.auth().currentUser else { return }
        let userEmail = user.email
        
        //轉換頁面
        let mainStoryboard =  UIStoryboard(name: "Main", bundle: nil)
        let updateUserInfoViewController = mainStoryboard.instantiateViewController(withIdentifier: "UpdateUserInfoViewController") as! UpdateUserInfoViewController
        
        updateUserInfoViewController.userEmail = userEmail!
        updateUserInfoViewController.userName = userNameForUpdate
    self.navigationController?.pushViewController(updateUserInfoViewController, animated: true)
        
        
    }
    
    
    
    
    
    //登出
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let mainStoryboard =  UIStoryboard(name: "Main", bundle: nil)
                let firstScreenViewController = mainStoryboard.instantiateViewController(withIdentifier: "FirstScreenViewController") as! FirstScreenViewController
                self.present(firstScreenViewController, animated: true, completion: nil)
                
            } catch let error as NSError {
                print("錯誤於此：",error.localizedDescription)
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
