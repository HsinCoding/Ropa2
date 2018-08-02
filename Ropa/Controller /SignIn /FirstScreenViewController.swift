//
//  TheFirstViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/9.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let mstring = "abc,eeee,fff"

        let a = ClothesManager.share
        
        let array = mstring.components(separatedBy: ",")
        
        print(array)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
