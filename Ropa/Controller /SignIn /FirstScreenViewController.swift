//
//  TheFirstViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/9.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.gray.cgColor
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
