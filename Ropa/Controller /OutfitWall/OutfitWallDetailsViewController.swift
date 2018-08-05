//
//  OutfitWallDetailsViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/2.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class OutfitWallDetailsViewController: UIViewController {

    
    @IBOutlet weak var outfitWallImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    
    
    
    var date = ""
    var userId = ""
    var imgUrl = ""
    var style = ""
    
    
    func getUserName() {
        Database.database().reference().child("userInfo").child(userId).observeSingleEvent(of:.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let userName = dictionary["userName"] as? String else { return }
            self.userNameLabel.text = userName
            
        }
    }
    
    
    func uploadImage(){
        let imageUrlString = imgUrl
        if let imgUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
                if error != nil {
                    print("Download Image Task Fail: \(error?.localizedDescription)")
                }
                else if let imageData = data {
                    DispatchQueue.main.async {
                        self.outfitWallImage.image = UIImage(data: imageData)
                    }
                }
                }.resume()
        }
    }
    
    
// 按讚功能
//    @IBAction func likeButton(_ sender: UIButton) {
//        Database.database().reference().child("outfit").child("outfitId")
//
//
//    }
//
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      dateLabel.text = date
      styleLabel.text = style
      getUserName()
      uploadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
