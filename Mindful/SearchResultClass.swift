//
//  SearchResultClass.swift
//  Mindful
//
//  Created by Rafaela Peralva on 11/15/21.
//

import UIKit

class SearchFoodCell: UITableViewCell {
    
    @IBOutlet weak var food_nameLabel: UILabel!
    @IBOutlet weak var food_infoLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
