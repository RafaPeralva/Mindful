//
//  FoodDetailCell.swift
//  Mindful
//
//  Created by Rafaela Peralva on 12/9/21.
//

import UIKit

class FoodDetailCell: UITableViewCell {
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        @IBOutlet var foodNameLabel: UILabel!
        @IBOutlet var foodDetailsLabel: UILabel!
        @IBOutlet var thumbImage: UIImageView!// Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
