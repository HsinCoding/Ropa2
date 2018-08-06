//
//  ClothesDetails.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/6/28.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class ClothesDetailsViewController: UIViewController {
    
    @IBOutlet weak var clothesViewImage: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var prieceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var shopLocateLabel: UILabel!
    
    var brand = ""
    var price = ""
    var date = ""
    var type = ""
    var color = ""
    var imgUrl = ""
    var clothesId = ""
    var shopLocate = ""
    
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
    
    func uploadImage(){
        let imageUrlString = imgUrl
        if let imgUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
                if error != nil {
                    print("Download Image Task Fail: \(error?.localizedDescription)")
                }
                else if let imageData = data {
                    DispatchQueue.main.async {
                        self.clothesViewImage.image = UIImage(data: imageData)
                    }
                }
            }.resume()
        }
    }
    
    
    @IBAction func updateButton(_ sender: UIBarButtonItem) {
        //轉換頁面
        let mainStoryboard =  UIStoryboard(name: "Main", bundle: nil)
        let updateForClothesViewController = mainStoryboard.instantiateViewController(withIdentifier: "UpdateForClothesViewController") as! UpdateForClothesViewController
        
        updateForClothesViewController.brand = self.brand
        updateForClothesViewController.imgUrl = self.imgUrl
        updateForClothesViewController.price = self.price
        updateForClothesViewController.type = self.type
        updateForClothesViewController.date = self.date
        updateForClothesViewController.shopLocate =  self.shopLocate
        updateForClothesViewController.clothesId = self.clothesId
        self.navigationController?.pushViewController(updateForClothesViewController, animated: true)
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brandLabel.text = brand
        prieceLabel.text = price
        dateLabel.text = date
        typeLabel.text = type
        shopLocateLabel.text = shopLocate
        showColor()
        uploadImage()
    
        
        
    }
    
    
    
}
