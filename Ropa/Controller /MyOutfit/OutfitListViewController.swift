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
        let cell = outfitTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OutfitListCell
    
        let outfit = outfits[indexPath.row]
        
        
        
        return cell 
    }
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

   

}
