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

class ClothesListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ClotheseManagerDelegate {
    
    
    @IBOutlet weak var clothesCollectionView: UICollectionView!
    
    var fileUploadDic: [String:Any]?
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
      print("gggg", clothing.count)
        return clothing.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ClothesListViewCell
        
        let clothes = clothing[indexPath.row]
        cell.brandLabel.text = clothes.brand
        
        return cell
    }
    

   
    let clothesManager = ClothesManager()

    override func viewDidLoad() {
        super.viewDidLoad()

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
