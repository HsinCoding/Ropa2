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


class ClothesListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ClothesManagerDelegate {
    
    
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
        
        // 顏色處理
        let colorArrayFromfirebase = clothes.color
        let splitedcolorStringArray = colorArrayFromfirebase.components(separatedBy: "/")
        
        var colorStringItems = ""
        var colorArray = [Array<String>]()
        
        for i in splitedcolorStringArray {
            let splitedcolorStringArrayDetail = i.components(separatedBy: ",")
            colorArray.append(splitedcolorStringArrayDetail)
        }
        
        //存入各個view
        let first = colorArray[0]
        let redWithFirst = first[0]
        let greenWithFirst = first[1]
        let blueWithFirst = first[2]
        let alphaWithFirst = first[3]
        cell.firstView.backgroundColor = UIColor(red: redWithFirst.toCGFloat()!, green: greenWithFirst.toCGFloat()!, blue: blueWithFirst.toCGFloat()!, alpha: alphaWithFirst.toCGFloat()!)

        let second = colorArray[1]
        let redWithSecond = second[0]
        let greenWithSecond = second[1]
        let blueWithSecond = second[2]
        let alphaWithSecond = second[3]
        cell.secondView.backgroundColor = UIColor(red: redWithSecond.toCGFloat()!, green: greenWithSecond.toCGFloat()!, blue: blueWithSecond.toCGFloat()!, alpha: alphaWithSecond.toCGFloat()!)
        
        let third = colorArray[2]
        let redWithThird = third[0]
        let greenWithThird  = third[1]
        let blueWithThird = third[2]
        let alphaWithThird  = third[3]
        cell.thirdView.backgroundColor = UIColor(red: redWithThird.toCGFloat()!, green: greenWithThird.toCGFloat()!, blue: blueWithThird.toCGFloat()!, alpha: alphaWithThird.toCGFloat()!)
        

        let forth = colorArray[3]
        let redWithForth = forth[0]
        let greenWithForth  = forth[1]
        let blueWithForth = forth[2]
        let alphaWithForth  = forth[3]
        cell.forthView.backgroundColor = UIColor(red: redWithForth.toCGFloat()!, green: greenWithForth.toCGFloat()!, blue: blueWithForth.toCGFloat()!, alpha: alphaWithForth.toCGFloat()!)
        
        let fifth = colorArray[4]
        let redWithFifth = fifth[0]
        let greenWithFifth  = fifth[1]
        let blueWithFifth = fifth[2]
        let alphaWithFifth  = fifth[3]
        cell.fifthView.backgroundColor = UIColor(red: redWithFifth.toCGFloat()!, green: greenWithFifth.toCGFloat()!, blue: blueWithFifth.toCGFloat()!, alpha: alphaWithFifth.toCGFloat()!)
        
         //圖片呈現部分
        let imgUrlString = clothes.img
        if let imgUrl = URL(string: imgUrlString) {
            URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
                if error != nil {
                     print("Download Image Task Fail: \(error!.localizedDescription)")
                }
                else if let imageData = data {
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
//        detailsViewController.date = clothing[indexPath.row].date
        //時間調整
        let dateString = clothing[indexPath.row].date
        let endIndex = dateString.index(dateString.endIndex, offsetBy: -6)
        let dateForShow = dateString.substring(to: endIndex)
        detailsViewController.date = dateForShow
        
        detailsViewController.type = clothing[indexPath.row].type
        detailsViewController.color = clothing[indexPath.row].color
        detailsViewController.imgUrl = clothing[indexPath.row].img
        detailsViewController.clothesId = clothing[indexPath.row].id
        detailsViewController.shopLocate = clothing[indexPath.row].shopLocate
        
       
        
        
        // 補上圖片
        
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
