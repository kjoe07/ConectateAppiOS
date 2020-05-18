//
//  BorderCardView.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 4/9/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit
@IBDesignable
class BorderCardView: UIView {
    @IBInspectable var radius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = radius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 1{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor  = .clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var shadowsOffSetWidth : CGFloat = 0{
        didSet{
            layer.shadowOffset = CGSize(width: shadowsOffSetWidth, height: shadowsOffSetHeight)
        }
    }
    @IBInspectable var shadowsOffSetHeight : CGFloat = 2{
        didSet{
            layer.shadowOffset = CGSize(width: shadowsOffSetWidth, height: shadowsOffSetHeight)
        }
    }    
    @IBInspectable var shadowColor : UIColor = UIColor.black{
        didSet{
            layer.shadowColor = shadowColor.cgColor
        }
    }
    @IBInspectable var shadowOpacity : Float = 0.16{
        didSet{
            layer.shadowOpacity = shadowOpacity
        }
    }
    @IBInspectable var shadowBlur: CGFloat = 32{
        didSet{
            layer.shadowRadius = shadowBlur / 2
        }
    }
    @IBInspectable var shadowSpread: CGFloat = 0{
        didSet{
            if shadowSpread == 0{
                layer.shadowPath = nil
            }else{
                let dx = -shadowSpread
                let rect  = bounds.insetBy(dx: dx, dy: dx)
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
            }
        }
    }
}
