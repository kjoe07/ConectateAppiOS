//
//  TruequeTableViewCell.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 6/11/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit

class TruequeTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var servicio: UILabel!
    @IBOutlet weak var pide: UILabel!
    @IBOutlet weak var aceptButton: BorderCurvedButton!
    @IBOutlet weak var rejectButton: BorderCurvedButton!
    @IBOutlet weak var chatButton: BorderCurvedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
