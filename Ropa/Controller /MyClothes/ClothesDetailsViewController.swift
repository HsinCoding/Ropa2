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
    var color = ""
    
    
    func showColor() {
        var colorArray = [Array<String>]()
        var splitedcolorStringArray = color.components(separatedBy: "/")
        for i in splitedcolorStringArray {
            let splitedcolorStringArrayDetail = i.components(separatedBy: ",")
            colorArray.append(splitedcolorStringArrayDetail)
        }
        
        for (index,i) in colorArray.enumerated() {
            
            guard index < 5 else { break }
            let red = i[0]
            let green = i[1]
            let blue = i[2]
            let alpha = i[3]
            if let colorView = self.view.viewWithTag(200+index) {
                colorView.backgroundColor = UIColor(red: red.toCGFloat()!, green: green.toCGFloat()!, blue: blue.toCGFloat()!, alpha: alpha.toCGFloat()!)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brandLabel.text = brand
        prieceLabel.text = price
        dateLabel.text = date
        typeLabel.text = type
        showColor()
        
        
        
    }
    
    
    
}
