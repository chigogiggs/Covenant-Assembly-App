//
//  MenuViewController.swift
//  sidemenutest
//
//  Created by godwin anyaso on 14/08/2019.
//  Copyright © 2019 godwin anyaso. All rights reserved.
//

import UIKit

enum Menutype: Int{
    case cancel
    case pastorsmessage
    case gallery
    case downloads
    case tithesandoffering
    case findus
    case upload
}

class MenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //         self.clearsSelectionOnViewWillAppear = false
        //        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func cancelsidemenu(_ sender: Any) {
        dismiss(animated: true) {
//            print("dismissing \(Menutype)")
                    }
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menutype = Menutype(rawValue: indexPath.row) else {return}
        
        if indexPath.row == 0{
            //            performSegue(withIdentifier: "book", sender: self)
            print("0 \(menutype)")
            dismiss(animated: true, completion: nil)
        }
        if indexPath.row == 1{
            print("1 \(menutype)")        }
        if indexPath.row == 2{
            print("2 \(menutype)")
            performSegue(withIdentifier: "gallery", sender: self)

        }
        if indexPath.row == 3{
            //            performSegue(withIdentifier: "picture", sender: self)
               print("3 \(menutype)")
        }
        if indexPath.row == 4{
            print("4 \(menutype)")
        }
        if indexPath.row == 5{
            //            performSegue(withIdentifier: "picture", sender: self)
            print("5 \(menutype)")
            performSegue(withIdentifier: "findus", sender: self)
        }

        if indexPath.row == 6{
            //            performSegue(withIdentifier: "picture", sender: self)
            print("5 \(menutype)")
        }
//        dismiss(animated: true) {
//            print("dismissing \(menutype)")
//        }
    }
}
