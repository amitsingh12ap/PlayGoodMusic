//
//  LiveEventCell.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 03/07/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit

class LiveEventCell: UITableViewCell {

    @IBOutlet weak var thumnail: UIImageView!
    @IBOutlet weak var nowPlayingLbl: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var subHeaderLbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
