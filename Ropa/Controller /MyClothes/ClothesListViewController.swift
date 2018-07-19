//
//  ClothesListViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/12.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ClothesListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ClotheseManagerDelegate {
    
    
    @IBOutlet weak var clothesCollectionView: UICollectionView!
    
    var fireUploadDic: [String:Any]?
    var clothing: [Clothes] = []
    var ref: DatabaseReference?

    
    func manager(_ manager: ClothesManager, didfetch Clothing: [Clothes]) {
        clothing = Clothing
        self.clothesCollectionView.reloadData()
    }
    
    func manager(_ manager: ClothesManager, didFaithWith error: Error) {
        //skip
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clothing.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ClothesListViewCell
        
        let clothes = clothing[indexPath.row]
        cell.brandLabel.text = clothes.brand
        
         //圖片呈現部分
        
        let storage = Storage.storage()
        var reference: StorageReference!
        
        reference = storage.reference(forURL: "gs://ropa-5d499.appspot.com")
        reference.downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            cell.imageView.image = image
        }
        
        return cell
    }
    

//    //從這邊開始
//    func downloadImage() -> UIImage {
//        let storage = Storage.storage()
//        var reference: StorageReference!
//        storage.c
//        return image
//
//    }
//
//
   
    let clothesManager = ClothesManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //圖片呈現部分
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("clothes")
        let query = databaseRef.queryOrdered(byChild: "owner").queryEqual(toValue: "\(uid)")
        databaseRef.observe(.value) { (snapshot) in
            if let uploadDataDic = snapshot.value as? [String: Any] {
                self.fireUploadDic = uploadDataDic
                self.clothesCollectionView.reloadData()
            }
        }
        //圖片呈現部分
    
        if Auth.auth().currentUser?.uid != nil {
            clothesManager.delegate = self
            clothesManager.getClothes()
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
