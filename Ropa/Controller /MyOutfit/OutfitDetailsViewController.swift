//
//  OutfitDetailsViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/7/31.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit

class OutfitDetailsViewController: UIViewController {

    
    @IBOutlet weak var outfitImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    
    var date = ""
    var season = ""
    var style = ""
    var note = ""
    var imgUrl = "" 
    
    
    func uploadImage(){
        let imageUrlString = imgUrl
        if let imgUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
                if error != nil {
                    print("Download Image Task Fail: \(error?.localizedDescription)")
                }
                else if let imageData = data {
                    DispatchQueue.main.async {
                        self.outfitImageView.image = UIImage(data: imageData)
                    }
                }
                }.resume()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = date
        seasonLabel.text = season
        styleLabel.text = style
        noteTextView.text = note
        uploadImage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
