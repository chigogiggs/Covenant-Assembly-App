//
//  GalleryViewController.swift
//  Covenant Assembly
//
//  Created by godwin anyaso on 27/08/2019.
//  Copyright © 2019 godwin anyaso. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController , iCarouselDelegate,iCarouselDataSource{
    
    var images = [UIImage]()

    @IBOutlet weak var carouselview: iCarousel!
    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 1...23{
            if let imag = UIImage(named: "\(i).jpeg") {
                images.append(imag)
            }else{
                print("error getting image for ")
            }
        }
//        images = [1,2,3,4,5,6,7]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselview.type = .coverFlow

        // Do any additional setup after loading the view.
    }
    

    func numberOfItems(in carousel: iCarousel) -> Int {
        return images.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let width = (self.view?.frame.width)! - 30
        let height = (self.view?.frame.height)! - 100
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.backgroundColor = .blue
        
        let imgview = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imgview.image = images[index]
//        imgview.image.frame = imgview.contentClippingRect
//        imgview.contentMode = .center;
//        imgview.image = images[index].resizeCG(size: imgview.bounds.size)
        view.addSubview(imgview)
        return view
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing{
            return value * 1.2
        }
        return value
    }

}
//
//extension UIImage {
//    func resizeCG(size:CGSize) -> UIImage? {
//        let bitsPerComponent = cgImage?.bitsPerComponent
//        let bytesPerRow = cgImage?.bytesPerRow
//        let colorSpace = cgImage?.colorSpace
//        let bitmapInfo = cgImage?.bitmapInfo
//
//        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: bitsPerComponent!, bytesPerRow: bytesPerRow!, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
//        CGContext.interpolationQuality(context!, .high)
//
//        CGContextDrawImage(context, CGRect(origin: CGPoint.zero, size: size), self.CGImage)
//
//        return context!.makeImage().flatMap { UIImage(cgImage: $0) }
//    }
//}
