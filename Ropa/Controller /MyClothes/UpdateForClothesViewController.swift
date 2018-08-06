//
//  UpdateViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/5.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UpdateForClothesViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
   

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var clothesImageView: UIImageView!
    
    @IBOutlet weak var brandTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var shopLocateTextField: UITextField!
    
    @IBOutlet weak var itemPickerView: UIPickerView!
    
    var ref: DatabaseReference?
    var imgUrl = ""
    var date = ""
    var brand = ""
    var price = ""
    var type = ""
    var clothesId = ""
    var shopLocate = ""
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
    
    
    @IBAction func selectImgButton(_ sender: UIButton) {
        
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
    
    
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        itemPickerView.selectedRow(inComponent: 0)
        type = typeArray[itemPickerView.selectedRow(inComponent: 0)]
        
        ref = Database.database().reference()
        if brandTextField.text == "" || priceTextField.text == "" || shopLocateTextField.text == "" {
            //error handing 跳出警告視窗
            print("請填寫內容")
        }
        else {
            guard let image = self.clothesImageView?.image else { print("image issiue");return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { print("uploadData issiue");return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            var colorStringItems = ""
         
            //顏色偵測區
            
            if let colors = TDImageColors(image: image , count: 64, threshold: 0.25).colors as? [UIColor]{
                print("顏色測試")
                
                var colorArray = [Array<String>]()
                
                
                for i in colors {
                    var colorStringItem = ""
                    let rgba = i.rgba
                    let redColor = "\(rgba.red),"
                    let greenColor = "\(rgba.green),"
                    let blueColor = "\(rgba.blue),"
                    let alphaColor = "\(rgba.alpha)/"
                    colorStringItem = redColor + greenColor + blueColor + alphaColor
                    colorStringItems += colorStringItem
                }
            }
            
            //存圖片到資料庫
            let storageRef = Storage.storage().reference().child("clothesImage")
            
            
            storageRef.child(uid).child(clothesId).putData(uploadData, metadata: nil) { (data, error) in
                if error != nil {
                    print("Error about put data:\(error?.localizedDescription)")
                    return
                }
                
                storageRef.child(uid).child(clothesId).downloadURL(completion: { (url, error) in
                    guard let imageUrl = url else { return }
                    print("imguel",imageUrl)
                    
                    let dateString = self.dateCreatDetail()
                    
                    let dic = ["imgUrl":"\(imageUrl)","price": "\(self.priceTextField.text!)","brand":"\(self.brandTextField.text!)","type": "\(self.type)","color":"\(colorStringItems)","owner":"\(uid)","date":"\(dateString)","shopLocate":"\(self.shopLocateTextField.text!)"] as [String:Any]
                    
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
                        
                    })
                    
                })
            }
            
            
        }
        
        
        
        
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        dateLabel.text = date
        brandTextField.text = brand
        priceTextField.text = price
        shopLocateTextField.text = shopLocate
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
