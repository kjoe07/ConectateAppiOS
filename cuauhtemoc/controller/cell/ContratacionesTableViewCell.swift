//
//  ContratacionesTableViewCell.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/26/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class ContratacionesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var txtTitulo: UILabel!
    @IBOutlet weak var txtContenido: UILabel!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnCalificar: UIButton!
    @IBOutlet weak var txtNombre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
