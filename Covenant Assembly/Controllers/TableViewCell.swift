//
//  TableViewCell.swift
//  Covenant Assembly
//
//  Created by godwin anyaso on 27/08/2019.
//  Copyright © 2019 godwin anyaso. All rights reserved.
//

import UIKit
import FoldingCell
import MapKit

class TableViewCell: FoldingCell  {

        @IBOutlet public weak var mapview: MKMapView!
        @IBOutlet public weak var venuelabel: UILabel!
    //
    @IBOutlet  weak var datelabel: UILabel!
        @IBOutlet public weak var timelabel: UILabel!
    
    @IBOutlet weak var datelabel2: UILabel!
    @IBOutlet weak var timelabel2: UILabel!
    
        @IBOutlet public weak var cellcounter: UILabel!
    @IBOutlet public weak var coverimgview2: UIImageView!
        @IBOutlet public weak var coverimgview: UIImageView!
    
        @IBOutlet public weak var eventnamelabel: UILabel!
//
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
