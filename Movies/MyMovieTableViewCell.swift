//
//  MyMovieTableViewCell.swift
//  Movies
//
//  Created by Brian Hu on 7/7/16.
//  Copyright © 2016 AlphaCamp. All rights reserved.
//

import UIKit

class MyMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
