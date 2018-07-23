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
    @IBOutlet weak var colorLabel: UILabel!
    
    var image = UIImage()
    var clothes: Clothes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
}
