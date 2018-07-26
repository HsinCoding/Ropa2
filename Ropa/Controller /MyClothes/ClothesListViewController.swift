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
    let uid = Auth.auth().currentUser?.uid 
    let clothesManager = ClothesManager()

    func manager(_ manager: ClothesManager, didfetch Clothing: [Clothes]) {
        clothing = Clothing
        self.clothesCollectionView.reloadData()
    }
    
    func manager(_ manager: ClothesManager, didFaithWith error: Error) {
        //skip
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("有幾個:",clothing.count)
        return clothing.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ClothesListViewCell
        
        let clothes = clothing[indexPath.row]
        cell.brandLabel.text = clothes.brand
        
         //圖片呈現部分
        
//第三種方法(始)
        let imgUrlString = clothes.img
        if let imgUrl = URL(string: imgUrlString) {
            URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
                if error != nil {
                     print("Download Image Task Fail: \(error!.localizedDescription)")
                } else if let imageData = data {
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: imageData)
                    }
                }
            }.resume()
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "ClothesDetailsViewController") as! ClothesDetailsViewController
        detailsViewController.brand = clothing[indexPath.row].brand
        detailsViewController.price = clothing[indexPath.row].price
        detailsViewController.date = clothing[indexPath.row].date
        detailsViewController.type = clothing[indexPath.row].type
        
        
        
        
        
        
        
        // 補上圖片
//        detailsViewController.image = clothing[indexPath.row].img
        print("kk",clothing[indexPath.row].price)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //圖片呈現部分
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("clothes")
        let query = databaseRef.queryOrdered(byChild: "owner").queryEqual(toValue: "\(uid)")
        
        query.observeSingleEvent(of: .value) { (snapshot) in
            if let uploadDataDic = snapshot.value as? [String:Any] {
                self.fireUploadDic = uploadDataDic
                self.clothesCollectionView.reloadData()
            }
        }
        
        if Auth.auth().currentUser?.uid != nil {
            clothesManager.delegate = self
            clothesManager.getClothes()
        }
    }

    
    
    @IBAction func AddButton(_ sender: Any) {
        
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let addNewClothesViewController = mainStory.instantiateViewController(withIdentifier: "AddNewClothesViewController")
        self.navigationController?.pushViewController(addNewClothesViewController, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
