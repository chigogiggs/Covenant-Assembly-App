//
//  HomeViewController.swift
//  Covenant Assembly
//
//  Created by godwin anyaso on 13/08/2019.
//  Copyright © 2019 godwin anyaso. All rights reserved.
//

import UIKit

struct scrollviewdatastruct {
    let title: String?
    let img: UIImage?
}

class HomeViewController: UIViewController, UIScrollViewDelegate {
    let transition = Slideintransition()
    var scrollviewdata = [scrollviewdatastruct]()
    @IBOutlet weak var pastorimgview: UIImageView!
    @IBOutlet weak var Scrollview: UIScrollView!
    var pagereverse_indicator = 0
    @IBOutlet weak var pagecontroller: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Scrollview.delegate = self
        scrollviewdata = [scrollviewdatastruct.init(title: "first", img: UIImage(named: "pastor1") ),
                          scrollviewdatastruct.init(title: "second", img: UIImage(named: "pastor2")),
                          scrollviewdatastruct.init(title: "third", img: UIImage(named: "pastor3")),
                          scrollviewdatastruct.init(title: "fourth", img: UIImage(named: "pastor4"))]

        Scrollview.contentSize.width = Scrollview.frame.width * CGFloat(scrollviewdata.count)
        
        var i = 0
        for data in scrollviewdata{
            let view = Customview(frame: CGRect(x:  (self.Scrollview.frame.width * CGFloat(i)), y: 0, width: self.Scrollview.frame.width , height: self.Scrollview.frame.height))
            view.imageview.image = data.img
            self.Scrollview.addSubview(view)
            i += 1
        }
        
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(movetonextscreen), userInfo: nil, repeats: true)
        
    }
//    var xOffSet = CGFloat(0)
//    @objc func timerAction() {
//        xOffSet += CGFloat(10);
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            
//            
//            UIView.animate(withDuration: 1, animations:
//                self.Scrollview.contentOffset.x = CGFloat(xOffSet)
//            )
//            
//        }
//        
//    }

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let num = Int(scrollView.contentOffset.x / CGFloat(self.view.bounds.width))
        print("num is \(num)")
        pagecontroller.currentPage = num
        if num > 5{
            pagereverse_indicator = 1
        }
        if num < 1{
            pagereverse_indicator = 0
        }
    }
    
    
    @objc func movetonextscreen(){
        UIView.animate(withDuration: 2.0) {
            
            
            if self.pagereverse_indicator == 0{
                if self.Scrollview.contentOffset.x < (self.Scrollview.contentSize.width - (self.view.frame.width)){
                    self.Scrollview.contentOffset.x += self.view.bounds.width
                }
            }else{
                if self.Scrollview.contentOffset.x > 0 {
                    self.Scrollview.contentOffset.x -= self.view.bounds.width
                }
            }
        }
    }

    
    
    
    
    
    @IBAction func didtapmenu(_ sender: Any) {
        print("here")
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let menuviewcontroller = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        menuviewcontroller.modalPresentationStyle = .overCurrentContext
        menuviewcontroller.transitioningDelegate = self
        present(menuviewcontroller, animated: true)
    }



}
extension HomeViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

class Customview: UIView {
    let imageview : UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageview)
        imageview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




//Zechariah 1:7
//Verse Concepts
//On the twenty-fourth day of the eleventh month, which is the month Shebat, in the second year of Darius, the word of the LORD came to Zechariah the prophet, the son of Berechiah, the son of Iddo, as follows:
//
