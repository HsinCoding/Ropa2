//
//  UpdateViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/5.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit

class UpdateForClothesViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var clothesImageView: UIImageView!
    
    @IBOutlet weak var brandTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    
    @IBOutlet weak var itemPickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
