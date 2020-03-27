//
//  NotificacionesTableViewCell.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/26/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class NotificacionesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgIndicador: UIImageView!
    @IBOutlet weak var imgTipoNotificacion: UIImageView!
    
    @IBOutlet weak var txtNotificacion: UILabel!
    @IBOutlet weak var btnAcciom: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
