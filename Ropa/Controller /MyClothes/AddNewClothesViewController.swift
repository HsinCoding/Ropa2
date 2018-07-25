//
//  AddNewClothesViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/6/22.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Firebase
import TDImageColors_betzerra


class AddNewClothesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var clothesImageView: UIImageView!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shopLocateTextField: UITextField!

    
    @IBOutlet weak var itemPickerView: UIPickerView!
    let typeArray = ["上著","下著","外套","連身","鞋","包"]
    
    var ref: DatabaseReference?
    var type: String = ""
    
    //pickerView 設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray.count
    }
    
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeArray[row]
    }
    
    
    // 照片上傳按鈕，可開啟相機及相簿
    @IBAction func selectImageButton(_ sender: Any) {
      
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
            if UIImagePickerController.isSourceTypeAvailable( .photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
            if UIImagePickerController.isSourceTypeAvailable( .camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        clothesImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    
    //儲存按鈕
    @IBAction func saveButton(_ sender: Any) {
        
        itemPickerView.selectedRow(inComponent: 0) // didSelectRow 相同意思
        type = typeArray[itemPickerView.selectedRow(inComponent: 0)]
        print(type)
        
        
        ref = Database.database().reference()
        if brandTextField.text == "" || priceTextField.text == "" || shopLocateTextField.text == "" {
            //error handing 跳出警告視窗
            print("請填寫內容")
        }
        else {
            
            guard let image = self.clothesImageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let clothesId = NSUUID().uuidString
            
            //顏色偵測區
            
            if let colors = TDImageColors(image: self.clothesImageView.image , count: 64, threshold: 0.25) as? [UIColor]{
                print("顏色測試")
                var colorStringItems = ""
                var colorArray = [Array<String>]()
                
                
                for i in colors {
                    var colorStringItem = ""
                    let rgba = i.rgba
                    let redColor = "\(rgba.red),"
                    let greenColor = "\(rgba.green),"
                    let blueColor = "\(rgba.blue),"
                    let alphaColor = "\(rgba.red)/"
                    colorStringItem = redColor + greenColor + blueColor + alphaColor
                    colorStringItems += colorStringItem
                    
                }
                print("顏色在這",colorStringItems)
            }
            
            
            //存圖片到資料庫
            let storageRef = Storage.storage().reference().child("image")
            
            
            storageRef.child(uid).child(clothesId).putData(uploadData, metadata: nil) { (data, error) in
                if error != nil {
                    print("Error about put data:\(error?.localizedDescription)")
                    return
                }
                
                storageRef.child(uid).child(clothesId).downloadURL(completion: { (url, error) in
                    guard let imageUrl = url else { return }
                    print("imguel",imageUrl)
                    
                    let dateString = self.dateCreatDetail()
                    
                    let dic = ["imgUrl":"\(imageUrl)","price": "\(self.priceTextField.text!)","brand":"\(self.brandTextField.text!)","type": "\(self.type)","color":"UIcolorString","owner":"\(uid)","date":"\(dateString)","shopLocate":"\(self.shopLocateTextField.text!)"] as [String:Any]
                    
                    //存入服飾資料於Firebase
                    Database.database().reference().child("clothes").child("\(clothesId)").setValue(dic, withCompletionBlock: { (error, ref) in
                        if let error = error {
                            print("Failed to set the clothes value", error)
                            return
                        }
                        print("Successfully to the clothes value ")
                        
                        //轉換頁面
                        let mainStoryboard =  UIStoryboard(name: "Main", bundle: nil)
                        let clothesListViewController = mainStoryboard.instantiateViewController(withIdentifier: "ClothesListViewController")
                        self.navigationController?.pushViewController(clothesListViewController, animated: true)
                        
                        //                        self.performSegue(withIdentifier: "goToClothesList", sender: nil)
                    })
                    
                })
            }
        }
    }
    

    //取消按鈕
    @IBAction func cancelButton(_ sender: Any) {
        
        clothesImageView.image = nil
        brandTextField.text = ""
        priceTextField.text = ""
        shopLocateTextField.text = ""
        
    }
    
    
    
    


    
    //自動生成時間
    func dateCreat() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    func dateCreatDetail() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd/HH/mm"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = dateCreat()
    }
    
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0, 0, 0, 0)
    }
}

extension String {
    func toCGFloat() -> CGFloat? {
        if let float = Float(self) {
            return CGFloat(float)
        } else {
            return nil
        }
    }
}








