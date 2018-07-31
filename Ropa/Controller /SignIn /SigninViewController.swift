//
//  SigninViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/9.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import FirebaseAuth

class SigninViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signInButton(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if user != nil {
                
                //成功視窗
                let sucessAlert = UIAlertController(title: "註冊成功", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "請重新登入", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                    
                    //增加寫入user的資料
                    
                    
                    
                    
                    
                    
                    
                    
                })
    
                sucessAlert.addAction(okAction)
                
                guard let nav = self.storyboard?.instantiateViewController(withIdentifier: "NAVAGATION") as? UINavigationController else { return }
                self.present(sucessAlert, animated: true, completion: nil)
                self.present(nav, animated: true, completion: nil)
            
            }
            else {
                //error handing
                if let error = error?.localizedDescription {
                    print(error)
                    
                let failAlert = UIAlertController(title: "帳號已存在", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "重新登入", style: .cancel, handler: nil)
                    
                    failAlert.addAction(okAction)
                    self.present(failAlert, animated: true, completion: nil)
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
