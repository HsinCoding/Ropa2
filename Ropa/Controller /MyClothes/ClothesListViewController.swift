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
                }else if let imageData = data {
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: imageData)
                    }
                }
            }.resume()
        }
        
        
//第三種方法(末)
        
//第二種方法(始)
//        ref = Database.database().reference().child("clothes")
//        let query = ref?.queryOrdered(byChild: "owner").queryEqual(toValue: "\(uid)")
//
//        query?.observeSingleEvent(of: .value) { (snapshot) in
//            print(snapshot)
//
//            guard let dictionary = snapshot.value as? [String: Any] else {print("lala"); return }
//            for key in dictionary.keys {
//                guard let valueDictionary = dictionary["\(key)"] as? [String: Any] else {print("lala1"); return }
//                print("我", valueDictionary)
//                guard let imgUrlString = dictionary["imgUrl"] as? String else {print("lala2"); return }
//                print("在",imgUrlString)
//                    if let imgUrl = URL(string: imgUrlString) {
//                        URLSession.shared.dataTask(with: imgUrl, completionHandler: { (data, response, error) in
//                            if error != nil {
//                                print("Download Image Task Fail: \(error!.localizedDescription)")
//                            }else if let imageData = data {
//                                DispatchQueue.main.async {
//                                    cell.imageView.image = UIImage(data: imageData)
//                                }
//                            }
//                        }).resume()
//                    }
//                }
//        }
//第二種方法(末)
        
        
//第一種方法(始)
//        let storage = Storage.storage()
//        var reference: StorageReference!
//
//        reference = storage.reference(forURL: "gs://ropa-5d499.appspot.com")
//        print("first")
//        reference.downloadURL { (url, error) in
//             print("second")
//            let data = NSData(contentsOf: url!)
//             print("third")
//            let image = UIImage(data: data! as Data)
//            cell.imageView.image = image
//        }
//第一種方法(末)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "ClothesDetailsViewController") as! ClothesDetailsViewController
        detailsViewController.brandLabel.text = clothing[indexPath.row].brand
        print("kk",clothing[indexPath.row].brand)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
   
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToClothesDetails" {
//            if let indexPath = self.clothesCollectionView.indexPathsForSelectedItems {
//                let object = clothing[indexPath.]
//            }
//        }
//    }
//    
    
    
    
    
    
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
