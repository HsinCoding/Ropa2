//
//  OutfitWallViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/8/1.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit
import FirebaseDatabase


class OutfitWallViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,OutfitWallManagerDelegate {
    
    var outfitWall: [Outfit] = []
    var ref: DatabaseReference?
    let outfitWallmanager = OutfitWallManager()
    
    @IBOutlet weak var outfitWallTableView: UITableView!
    
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
        cell.dateLabel.text = outfitWall.date
        cell.likeAmount.text = "按讚數量"
        cell.styleLabel.text = outfitWall.style
    
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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        outfitWallmanager.delegate = self
        outfitWallmanager.getOutfitWall()
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
