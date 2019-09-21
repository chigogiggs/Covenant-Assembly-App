//
//  EventViewController.swift
//  Covenant Assembly
//
//  Created by godwin anyaso on 25/08/2019.
//  Copyright © 2019 godwin anyaso. All rights reserved.
//

import UIKit
import FoldingCell
import Firebase
import MapKit



class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var noeventslabel: UILabel!
    struct data {
        var name: String?
        var date: String?
        var time: String?
        var venue: String?
        var img: UIImage?
    }
    
    var celllist = [data]() {
        didSet{
            print("celllist data updated")
            if celllist.count == 0{
                noeventslabel.alpha = 1
            }else{
                noeventslabel.alpha = 0
            }
            tableView.reloadData()
        }
    }
    
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 320
        
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    
@IBOutlet weak var tableView: UITableView!

        override func viewDidLoad() {
        super.viewDidLoad()
            
        populatetable()
        setup()
        print("celllict is \(celllist)")
        // Do any additional setup after loading the view.
    }
    
    // MARK: Helpers
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    // MARK: Actions
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }



    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as FoldingCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celllist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "io", for: indexPath) as! TableViewCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2,0.26, 0.2, 0.2,0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        cell.datelabel.text = celllist[indexPath.row].date
        cell.timelabel.text = celllist[indexPath.row].time
        cell.venuelabel.text = celllist[indexPath.row].venue
        cell.eventnamelabel.text = celllist[indexPath.row].name
        cell.cellcounter.text = "\(indexPath.row)"
        if celllist[indexPath.row].img == nil{
            print("img might be empty")
        }else{
            cell.coverimgview.image = celllist[indexPath.row].img
            cell.coverimgview2.image = celllist[indexPath.row].img
        }
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            
            // fix https://github.com/Ramotion/folding-cell/issues/169
//            if cell.frame.maxY > tableView.frame.maxY {
//                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
//            }
        }, completion: nil)
    }
    
}


extension EventViewController{
    
    func populatetable(){
        let ref:DatabaseReference!  //root.child("users").child("stephenwarren001@yahoo.com")
        ref = Database.database().reference()
        // only need to fetch once so use single event
        ref.child("Eventlist").observe(.childAdded) { (snapshot) in
             if !snapshot.exists() { return }
            print("snapshot is \(snapshot)")
            if let dict = snapshot.value as? NSDictionary{
                if let event_name = dict["eventtype"]{
                    if let event_img = dict["image"]{
                        if let event_time = dict["time"]{
                            if let event_date = dict["date"]{
                                
                                if let event_venue = dict["venue"]{
                                    var data_instance = data()
                                    data_instance.date = event_date as! String
                                    data_instance.name = event_name as! String
                                    data_instance.time = event_time as! String
                                    data_instance.venue = event_venue as! String
                                    let str = event_img as! String
                                    print("str is \(str)")
                                    let theeventimg_url = URL(string: str)
//                                    let theeventimg = self.downloadImage(from: theeventimg_url!)
                                    let data_from_url = try? Data(contentsOf: theeventimg_url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                                    
                                    
                                    
                                    let urll = URL(string: str)!
                                    self.getImage(from: urll) { immage, error in
                                        guard let immage = immage else {
                                            print("error:", error ?? "")
                                            return
                                        }
                                        print("image size:", immage.size)
                                        // use your image here and don't forget to always update the UI from the main thread
                                        DispatchQueue.main.async {
                                            if immage == nil {
                                                assertionFailure("img empty")
                                            }else{
                                                data_instance.img = immage
                                                self.tableView.reloadData()
                                            }
                                            
                                            self.celllist.append(data_instance)

                                            
                                        }
                                    }
                                    

                                    
                                    
                                    
                                                                        self.tableView.reloadData()
                                    
//
                                    
                                }
                            }
                        }
                    }
                }
                
                
            }else{
                assertionFailure("could not get any info from firebase database")
            }

        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func getImage(from url: URL, completion: @escaping (UIImage?, Error?) -> ()) {
        print("download started:", url.absoluteString)
        URLSession.shared.dataTask(with: url) { data, reponse, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            print("download finished:")
            completion(UIImage(data: data), nil)
            }.resume()
    }
    
    
    
}
