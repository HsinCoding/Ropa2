//
//  ViewController.swift
//  Ropa
//
//  Created by Chen Hsin on 2018/6/22.
//  Copyright © 2018年 Chen Hsin. All rights reserved.
//

import UIKit

class myWardrobeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let clothArray = ["衣","褲","裙","包","飾","鞋"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = clothArray[indexPath.row]
        
        return cell
    }
    
    
   

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

