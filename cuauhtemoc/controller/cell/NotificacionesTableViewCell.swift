//
//  NotificacionesTableViewCell.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/26/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class NotificacionesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgIndicador: UIView!
    @IBOutlet weak var imgTipoNotificacion: UIButton!
    
    @IBOutlet weak var txtNotificacion: UILabel!
    @IBOutlet weak var btnAcciom: UIButton!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
