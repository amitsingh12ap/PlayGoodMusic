//
//  ProfilePicCell.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 04/07/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit

protocol ProfilePicCellDelwgate: class {
    func capturePicture()
}

class ProfilePicCell: UITableViewCell {

    @IBOutlet weak var profilePic: RoundButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    weak var delegate: ProfilePicCellDelwgate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func captureProfile(_ sender: Any) {
        self.delegate?.capturePicture()
    }
    
}
