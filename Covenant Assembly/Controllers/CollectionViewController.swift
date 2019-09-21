//
//  CollectionViewController.swift
//  Covenant Assembly
//
//  Created by godwin anyaso on 14/08/2019.
//  Copyright © 2019 godwin anyaso. All rights reserved.
//

import UIKit


struct eachcell {
    var img: UIImage?
    var title: String?
}
class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collection = [eachcell]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection = [eachcell.init(img: UIImage(named: "book"), title: "Books"),
                      eachcell.init(img: UIImage(named: "video"), title: "Sermon Videos"),
                      eachcell.init(img: UIImage(named: "audio"), title: "Audio"),
                      eachcell.init(img: UIImage(named: "picture"), title: "Gallery")]
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageview.image = collection[indexPath.row].img
        cell.title.text =  collection[indexPath.row].title
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath.row)
        if indexPath.row == 0{
//            performSegue(withIdentifier: "book", sender: self)
        }
        if indexPath.row == 1{
            performSegue(withIdentifier: "video", sender: self)
        }
        if indexPath.row == 2{
//            performSegue(withIdentifier: "audio", sender: self)
        }
        if indexPath.row == 3{
//            performSegue(withIdentifier: "picture", sender: self)
        }
        
    }

    
    
}
