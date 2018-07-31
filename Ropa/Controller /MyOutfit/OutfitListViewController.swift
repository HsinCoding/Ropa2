//
//  OutfitListViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/27.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class OutfitListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyOutfitManagerDelegate {
    
    var outfits:[Outfit] = []
    var ref: DatabaseReference?
    let myOutfitManager = MyOutfitManager()
    @IBOutlet weak var outfitTableView: UITableView!
    
    func manager(_ manager: MyOutfitManager, didfetch Outfits: [Outfit]) {
        outfits = Outfits
        self.outfitTableView.reloadData()
    }
    
    func manager(_ manager: MyOutfitManager, didFaithWith error: Error) {
        //跳過
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("gg",outfits.count)
        return outfits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OutfitListCell
    
        let outfit = outfits[indexPath.row]
        cell.seasonLabel.text = outfit.season
        cell.styleLabel.text = outfit.style
        cell.userNameLabel.text = "Default"
        
        //圖片處理部分
        let imgUrlString = outfit.img
        if let imgUrl = URL(string: imgUrlString) {
            URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
                if error != nil {
                    print("Download Image Task Fail: \(error!.localizedDescription)")
                }
                else if let imageData = data {
                    DispatchQueue.main.async {
                        cell.outfitImageView.image = UIImage(data: imageData)
                    }
                }
            }.resume()
        }
        return cell 
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let outfitDetailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "OutfitDetailsViewController") as! OutfitDetailsViewController
        
        outfitDetailsViewController.date = outfits[indexPath.row].date
        outfitDetailsViewController.note = outfits[indexPath.row].note
        outfitDetailsViewController.season = outfits[indexPath.row].season
        outfitDetailsViewController.style = outfits[indexPath.row].style
        outfitDetailsViewController.imgUrl = outfits[indexPath.row].img
        
        self.navigationController?.pushViewController(outfitDetailsViewController, animated: true)
    }
    
    
    
    
    @IBAction func addButton(_ sender: Any) {
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let addNewOutfitViewController = mainStory.instantiateViewController(withIdentifier: "AddNewOutfitViewController")
        self.navigationController?.pushViewController(addNewOutfitViewController, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if Auth.auth().currentUser?.uid != nil {
            myOutfitManager.delegate = self
            myOutfitManager.getMyOutfit()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

   

}
