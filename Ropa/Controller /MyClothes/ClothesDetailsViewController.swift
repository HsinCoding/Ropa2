//
//  ClothesDetails.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/6/28.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import Foundation
import UIKit

class ClothesDetailsViewController: UIViewController {
    
    @IBOutlet weak var clothesViewImage: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var prieceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    
    var image = UIImage()
    var brand = ""
    var price = ""
    var date = ""
    var type = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brandLabel.text = brand
        prieceLabel.text = price
        dateLabel.text = date
        typeLabel.text = type
        
        
        
        
    }
    
    
    
}
