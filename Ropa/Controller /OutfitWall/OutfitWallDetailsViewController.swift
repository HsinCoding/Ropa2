//
//  OutfitWallDetailsViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/2.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit

class OutfitWallDetailsViewController: UIViewController {

    
    @IBOutlet weak var outfitWallImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    
    
    
    var date = ""
    var userName = ""
    var imgUrl = ""
    var style = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

      dateLabel.text = date
      styleLabel.text = style
      userNameLabel.text = userName
        
        
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
