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
    
    var publicSetting: Bool = false
    var seasonString: String = ""
    var style = ""
    @IBOutlet weak var outfitImageView: UIImageView!
 
    
    
    @IBOutlet weak var noteTextView: UITextView!
   
    @IBOutlet weak var stylePickerView: UIPickerView!
    
    
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
            publicSetting = true
        }
        else {
            publicSetting = false
        }
    }
    
    
    @IBAction func seasonSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            seasonString = "春"
        } else if sender.selectedSegmentIndex == 1 {
            seasonString = "夏"
        } else if sender.selectedSegmentIndex == 2 {
            seasonString = "秋"
        } else if sender.selectedSegmentIndex == 3 {
            seasonString = "冬"
        }
    }
    
    
    
    
    
    //儲存設定
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
        stylePickerView.selectedRow(inComponent: 0) // didSelectRow 相同意思
        style = styleArray[stylePickerView.selectedRow(inComponent: 0)]
        
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
            
            //取圖片網址
            storageRef.child(uid).child(outfitId).downloadURL(completion: { (url, error) in
                guard let outfitImageUrl = url else { return }
                print("imgurl",outfitImageUrl)
                
                 let dateString = self.dateCreatDetail()
             
                 let dic = [
                    "imgUrl":"\(outfitImageUrl)",
                    "season":"\(self.seasonString)",
                    "style":"\(self.style)",
                    "owner":"\(uid)",
                    "note":"\(self.noteTextView.text!)",
                    "date":"\(dateString)",
                    "isPublic":"\(self.publicSetting)"
                    ] as [String:Any]
                
                //存入服飾資料於Firebase
                Database.database().reference().child("outfit").child("\(outfitId)").setValue(dic, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        print("Failed to set the outfit value", error)
                        return
                    }
                    print("Successfully to the outfit value ")
                    
                    
                    //轉換頁面
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let OutfitListViewController = mainStoryboard.instantiateViewController(withIdentifier: "OutfitListViewController")
                    self.navigationController?.pushViewController(OutfitListViewController, animated: true)
                    
                })
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

