//
//  ComentariosTableViewCell.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/25/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class ComentariosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var txtNombreUsuario: UILabel!
    @IBOutlet weak var txtComentario: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
