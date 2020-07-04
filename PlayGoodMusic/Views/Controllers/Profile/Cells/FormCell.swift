//
//  FormCell.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 04/07/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit

class FormCell: UITableViewCell {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var textField: UITextField! {
        didSet {
            self.textField.layer.borderColor = UIColor.gray.cgColor
            self.textField.layer.borderWidth = 0.3
            self.textField.attributedPlaceholder = NSAttributedString(string: "placeholder text",
                                                                      attributes: [.foregroundColor: UIColor.gray])

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
