//
//  BorderTextField.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 4/9/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit
@IBDesignable
class BorderTextField: UITextField {
    @IBInspectable var borderColor: UIColor = UIColor.white{
        didSet{
                layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 28 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.white{
        didSet{
            layer.shadowColor = shadowColor.cgColor
        }
    }
    @IBInspectable var shadowOffset: Double = 0{
        didSet{
            layer.shadowOffset = CGSize(width: 0, height: shadowOffset)
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.64{
        didSet{
            layer.shadowOpacity = shadowOpacity
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0{
        didSet{
            layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable var rightImage: UIImage = UIImage(){
        didSet{
            let imageView = UIImageView(image: rightImage)
            self.rightView = imageView
        }
    }
    @IBInspectable var isRightViewVisible: Bool = false{
        didSet{
            if isRightViewVisible{
                rightViewMode = .always
            }else{
                rightViewMode = .never
            }
        }
    }
    @IBInspectable var placeHolderColor: UIColor = .white {
        didSet{
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor])
        }
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return  bounds.insetBy(dx: 16, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 24, y: (bounds.height/2) - 6, width: 18, height: 12)//bounds.insetBy(dx: (bounds.width - 32), dy: 16)
    }
}
