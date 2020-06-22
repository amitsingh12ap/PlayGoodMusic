//
//  ListTableCell.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 20/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit

class ListTableCell: UITableViewCell {

    @IBOutlet weak var thumnail: UIImageView!
    @IBOutlet weak var eventStatusLbl: UILabel!
    @IBOutlet weak var eventInfoLbl: UILabel!
    @IBOutlet weak var priceContainer: UIView! {
        didSet {
            priceContainer.layer.borderWidth = 2
            priceContainer.layer.borderColor = UIColor.init(red: 145/255, green: 33/255, blue: 19/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var eventType: UILabel!
    
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
