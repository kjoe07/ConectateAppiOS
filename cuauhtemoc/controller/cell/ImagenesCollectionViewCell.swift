//
//  ImagenesCollectionViewCell.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/16/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class ImagenesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var btnBackGroung: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func showIcon() {
        
        btnBackGroung.backgroundColor = UIColor(red: 246/256, green: 56/256, blue: 121/256, alpha: 1.0)
        
    }
    
    func hideIcon() {
            btnBackGroung.backgroundColor = UIColor.clear
    }
 
    
    
    
}
