//
//  LoginViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/9.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
            
                guard let nav = self.storyboard?.instantiateViewController(withIdentifier: "NAVAGATION") as? UINavigationController else { return }
                self.present(nav, animated: true, completion: nil)
                
                
                print("恭喜登入")
            } else {
                let error = error?.localizedDescription
                    print(error)
                
                //設定警告控制器
                let failAlert = UIAlertController(title: "登入失敗", message: "請確認您輸入資料是否正確", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "重新確認", style: .cancel, handler: nil)
                failAlert.addAction(okAction)
                
                self.present(failAlert, animated: true, completion: nil)
                
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
