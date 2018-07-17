//
//  ClothesListCollectionViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/10.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

private let reuseIdentifier = "Cell"

class ClothesListCollectionViewController: UICollectionViewController,ClotheseManagerDelegate{
    
    
    var fileUploadDic: [String:Any]?
    
    var clothing: [Clothes] = []
    var ref: DatabaseReference?
    
    
    
    func manager(_ manager: ClothesManager, didfetch Clothing: [Clothes]) {
        clothing = Clothing
        self.collectionView?.reloadData()
    }
    
    func manager(_ manager: ClothesManager, didFaithWith error: Error) {
        // skip
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let filename = NSUUID().uuidString
//
//        let databaseRef = Database.database().reference().child("clothes").child(uid).child("\(filename)")
//        databaseRef.observe(.value) { (snapshot) in
//            if let uploadDataDic = snapshot.value as? [String:Any] {
//                print("success")
//                self.fileUploadDic = uploadDataDic
//                self.collectionView?.reloadData()
//            }
//            else {
//                print("Fail")
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataDic = fileUploadDic {
            print("yesssss",dataDic.count)
            return dataDic.count
            print("jjjj",dataDic.count)
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ClothesCollectionViewCell
      
        let clothes = clothing[indexPath.row]
        cell.brandLabel.text = clothes.brand
        cell.colorLabel.text = clothes.color
        cell.dateLabel.text = clothes.date
        cell.priceLabel.text = String(clothes.price)
        
        
        return cell
    }
    
    
   
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let clothesDetailsViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ClothesDetailsViewController") as! ClothesDetailsViewController
        let cloth = clothing[indexPath.row]
        print("ggggg",cloth.brand)
        clothesDetailsViewController.brandLabel.text = cloth.brand
        clothesDetailsViewController.dateLabel.text = cloth.date
        clothesDetailsViewController.prieceLabel.text = String(cloth.price)
        clothesDetailsViewController.colorLabel.text = cloth.color
        
        
        performSegue(withIdentifier: "gotocolthesdetail ", sender: nil)
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
