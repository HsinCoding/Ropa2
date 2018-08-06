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
    
    func getUserInfo() {
       
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        Database.database().reference().child("userInfo").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionay = snapshot.value as? [String:Any] else { return }
            for key in dictionay.values {
                
            }
                
        }
    }
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}
