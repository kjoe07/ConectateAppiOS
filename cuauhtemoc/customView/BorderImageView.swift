//
//  BorderImageView.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 4/15/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit
@IBDesignable
class BorderImageView: UIImageView {

    @IBInspectable var borderColor: UIColor = .black{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat = 0.0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }

}
