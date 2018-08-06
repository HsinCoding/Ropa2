//
//  UpdateViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/5.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit

class UpdateForClothesViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
   

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var clothesImageView: UIImageView!
    
    @IBOutlet weak var brandTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var itemPickerView: UIPickerView!
    
    
    var imgUrl = ""
    var brand = ""
    var price = ""
    var type = ""
    let typeArray = ["上著","下著","外套","連身","鞋","包"]
    var typeIndex: Int = 0
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeArray[row]
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        brandTextField.text = brand
        priceTextField.text = price
        uploadImage()
        
        for (index,value) in typeArray.enumerated() {
            if type == value {
              typeIndex = index
            }
        }
  
        itemPickerView.selectRow(typeIndex, inComponent: 0, animated: true)
       
        
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                        self.clothesImageView.image = UIImage(data: imageData)
                    }
                }
                }.resume()
        }
    }
    
}
