//
//  PostTableViewCell.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/23/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgServicio: UIImageView!
    @IBOutlet weak var lblTexto: UILabel!
    
    @IBOutlet weak var imgPost: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
