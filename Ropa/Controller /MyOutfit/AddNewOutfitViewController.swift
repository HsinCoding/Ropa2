//
//  AddNewOutfitViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/24.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase



class AddNewOutfitViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var privacySetting = ""

    @IBOutlet weak var outfitImageView: UIImageView!
    
    
    
    @IBAction func seasonSegmentedControl(_ sender: UISegmentedControl) {
    }
    
    @IBOutlet weak var noteTextView: UITextView!
    var ref: DatabaseReference?
   
    
    // 上傳照片按鈕設定
    @IBAction func selectImageButton(_ sender: UIButton) {
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
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        outfitImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //pickerView 設定

    let styleArray = ["中性","街頭","甜美","浪漫","簡約","韓風","日系","歐美"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return styleArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return styleArray[row]
    }
    
    
    //公開與否設定
    @IBAction func privacySegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            privacySetting = "public"
        }
        else {
            privacySetting = "privacy"
        }
    }
    
    
    //儲存設定
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        ref = Database.database().reference()
        
        //if let 確認是否填寫資料
        guard let image = self.outfitImageView.image else{ return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let outfitId = NSUUID().uuidString
        
        //存圖片到資料庫
        let storageRef = Storage.storage().reference().child("outfitImage")
        
        
        storageRef.child(uid).child(outfitId).putData(uploadData, metadata: nil) { (data, error) in
            if error != nil {
                print("Error about put data:\(error?.localizedDescription)")
                return
            }
            
            storageRef.child(uid).child(outfitId).downloadURL(completion: { (url, error) in
                guard let outfitImageUrl = url else { return }
                print("imgurl",outfitImageUrl)
                
                let dateString = self.dateCreatDetail()
            
                
            })
        }
    }
    
        //清空設定
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
        outfitImageView.image = nil
        noteTextView.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func dateCreatDetail() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd/HH/mm"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }

}

