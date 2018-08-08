//
//  UpdateUserInfoViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/7.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UpdateUserInfoViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    
    var userName = ""
    var userEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.text = userEmail
        userNameTextField.text = userName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPassword(_ sender: UIButton) {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        Auth.auth().sendPasswordReset(withEmail: userEmail) { (error) in
            print(error)
        }
        let failAlert = UIAlertController(title: "密碼重置", message: "郵件已送出", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "請至信箱確認並進行密碼重置", style: .cancel, handler: nil)
        failAlert.addAction(okAction)
        
        self.present(failAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        if userNameTextField.text == "" {
            print("請確認暱稱")
            //error handing
        }
        else {
            guard let user = Auth.auth().currentUser else { return }
            let uid = user.uid
            let email = user.email
            
            //寫入使用者資料
            let dic = ["email":"\(email!)","userName":"\(userNameTextField.text!)","userBirthday":"userBirthday","myFavorite":"陣列","userImage":"imageUrl"] as [String:Any]
            
            Database.database().reference().child("userInfo").child(uid).setValue(dic, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print("Failed to set the userInfo value", error)
                    return
                }
                print("重新設定完成")
            })
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    @IBAction func deleteButton(_ sender: UIBarButtonItem) {
        let ref = Database.database().reference()
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        user.delete { error in
            if let error = error {
                // An error happened.
            } else {

                let mainStoryboard =  UIStoryboard(name: "Main", bundle: nil)
                let firstScreenViewController = mainStoryboard.instantiateViewController(withIdentifier: "FirstScreenViewController") as! FirstScreenViewController
                self.present(firstScreenViewController, animated: true, completion: nil)

                //刪除使用者資料
                ref.child("userInfo").child(uid).removeValue()


                //刪除使用者Clothes紀錄
                let queryForClothes = ref.child("clothes").queryOrdered(byChild: "owner").queryEqual(toValue: "\(uid)")
                queryForClothes.observe(.value) { (snapshot) in
                    guard let dictionary = snapshot.value as? [String:Any] else { return }
                    if snapshot != nil {
                        for key in dictionary.keys{
                            
                            ref.child("clothes").child(key).removeValue()
                            print("刪除Clothes成功")
                        }
                        
                    }
                    else {
                        print("沒有資料刪除")
                    }
                }


                //刪除使用者outfit紀錄

                let queryForOutfit = ref.child("outfit").queryOrdered(byChild: "owner").queryEqual(toValue: "\(uid)")
                queryForOutfit.observe(.value) { (snapshot) in
                    guard let dictionary = snapshot.value as? [String:Any] else { return }
                    if snapshot != nil {
                        for key in dictionary.keys{
                            
                            ref.child("outfit").child(key).removeValue()
                            print("刪除outfit成功")
                        }
                    }
                    else {
                        print("沒有outfit資料刪除")
                    }
                }
                
                
                
                

                let failAlert = UIAlertController(title: "已經成功刪除帳號", message: "ropa@gmail.com", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "有任何問題歡迎來信聯絡", style: .cancel, handler: nil)
                failAlert.addAction(okAction)

                self.present(failAlert, animated: true, completion: nil)

            }
        }
        
 
        
    }
    
    

}
