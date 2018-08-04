//
//  OutfitWallViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/1.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import FirebaseDatabase


class OutfitWallViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,OutfitWallManagerDelegate,UserInfoManagerDelegate {
    
    
    var outfitWall: [Outfit] = []
    var userInfo: [UserInfo] = []
    var ref: DatabaseReference?
    let outfitWallmanager = OutfitWallManager()
    
    @IBOutlet weak var outfitWallTableView: UITableView!
    
    
    func manager(_ manager: UserInfoManager, didfetch UserInfo: [UserInfo]) {
        userInfo = UserInfo
        self.outfitWallTableView.reloadData()
    }
    
    func manager(_ manager: UserInfoManager, didFaithWith error: Error) {
        //skip
    }

   
    func manager(_ manager: OutfitWallManager, didfetch OutfitWall: [Outfit]) {
        outfitWall = OutfitWall
        self.outfitWallTableView.reloadData()
        
    }
    
    func manager(_ manager: OutfitWallManager, didFaithWith error: Error) {
        //skip
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("table數量有:",outfitWall.count)
        return outfitWall.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OutfitWallTableViewCell
        let outfitWall = self.outfitWall[indexPath.row]
        var userNameForShow = ""
        cell.dateLabel.text = outfitWall.date
        cell.likeAmount.text = "按讚數量"
        cell.styleLabel.text = outfitWall.style
        
    
        //使用者暱稱轉換
        let userID = outfitWall.owner
        Database.database().reference().child("userInfo").child(userID).observeSingleEvent(of:.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let userName = dictionary["userName"] as? String else { return }
            userNameForShow = userName
            cell.userNameLabel.text = userNameForShow
        }
       
        //圖片處理部分
        let imgUrlString = outfitWall.img
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
        let outfitWallDetailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "OutfitWallDetailsViewController") as! OutfitWallDetailsViewController
        var userNameForShow = ""
        outfitWallDetailsViewController.date = outfitWall[indexPath.row].date
        outfitWallDetailsViewController.imgUrl = outfitWall[indexPath.row].img
        outfitWallDetailsViewController.style = outfitWall[indexPath.row].style
        outfitWallDetailsViewController.userId = outfitWall[indexPath.row].owner
        
        //userName 處理
//        let userID = outfitWall[indexPath.row].owner
//        Database.database().reference().child("userInfo").child(userID).observeSingleEvent(of:.value) { (snapshot) in
//                guard let dictionary = snapshot.value as? [String:Any] else { return }
//                guard let userName = dictionary["userName"] as? String else { return }
//                print("第三個",userName)
//                userNameForShow = userName
//                print("真的名字啦",userNameForShow)
//                outfitWallDetailsViewController.userName = userNameForShow
//                print("lalala",  outfitWallDetailsViewController.userName)
//        }
        
   
        self.navigationController?.pushViewController(outfitWallDetailsViewController, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        outfitWallmanager.delegate = self
        outfitWallmanager.getOutfitWall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}
