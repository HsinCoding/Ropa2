//
//  SigninViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/9.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SigninViewController: UIViewController {
    
    var userDate = ""
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userDatePicker: UIDatePicker!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    
    
    @IBAction func userDatePickerAction(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        self.userDate = dateFormatter.string(from: self.userDatePicker.date)
    }
    
    
    @IBAction func signInButton(_ sender: Any) {
        
        //檢查
        if emailTextField.text == "" {
            let failAlert = UIAlertController(title: "請輸入電子郵件", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            failAlert.addAction(okAction)
        
            self.present(failAlert, animated: true, completion: nil)
        
        } else if passwordTextField.text == "" {
            let failAlert = UIAlertController(title: "請輸入密碼", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            failAlert.addAction(okAction)
           
            self.present(failAlert, animated: true, completion: nil)
        
        } else if passwordCheckTextField.text == "" {
            let failAlert = UIAlertController(title: "請再次輸入密碼", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            failAlert.addAction(okAction)
            
            self.present(failAlert, animated: true, completion: nil)
       
        } else if userNameTextField.text == "" {
            let failAlert = UIAlertController(title: "請輸入使用者暱稱", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            failAlert.addAction(okAction)
           
            self.present(failAlert, animated: true, completion: nil)
        
        } else if passwordTextField.text != passwordCheckTextField.text {
            let failAlert = UIAlertController(title: "輸入密碼不相符", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            failAlert.addAction(okAction)
            
            self.present(failAlert, animated: true, completion: nil)
        }
        else {
            //儲存資料庫
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if user != nil {
                    
                    //成功視窗
                    let sucessAlert = UIAlertController(title: "註冊成功", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "請重新登入", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                                            self.performSegue(withIdentifier: "goToLogin", sender: nil)
//                        self.dismiss(animated: true, completion: nil)
                    })
                    sucessAlert.addAction(okAction)
                    self.present(sucessAlert, animated: true, completion: nil)
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    
                    //寫入使用者資料
                    let dic = ["email":"\(self.emailTextField.text!)","password":"\(self.passwordTextField.text!)","userName":"\(self.userNameTextField.text!)","userBirthday":"\(self.userDate)","myFavorite":"陣列"] as [String:Any]
                    
                    Database.database().reference().child("userInfo").child(uid).setValue(dic, withCompletionBlock: { (error, ref) in
                        if let error = error {
                            print("Failed to set the userInfo value", error)
                            return
                        }
                        print("Successfully to the userInfo value")
                    })
                    
                    //                guard let nav = self.storyboard?.instantiateViewController(withIdentifier: "NAVAGATION") as? UINavigationController else { return }
                    //                self.present(nav, animated: true, completion: nil)
                    
                   
                }
                else {
                    //error handing
                    if let error = error?.localizedDescription {
                        print(error)
                        
                        //如何處理登入error
                        
                        let failAlert = UIAlertController(title: "電郵格式有誤", message: "", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "請重新確認", style: .cancel, handler: nil)
                        
                        failAlert.addAction(okAction)
                        self.present(failAlert, animated: true, completion: nil)
                    }
                }
            }
            
        }
    }
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
    
        self.performSegue(withIdentifier: "backToFirstView", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
