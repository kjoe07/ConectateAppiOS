//
//  CustomSegmentedControl.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 4/10/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit
@IBDesignable
class CustomSegmentedControl: UISegmentedControl {
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = .clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var selectedTextColor: UIColor = .black{
        didSet{
            setTitleTextAttributes([.foregroundColor: selectedTextColor], for: .selected)
        }
    }
    @IBInspectable var unselectedTextColor: UIColor = .black{
        didSet{
            setTitleTextAttributes([.foregroundColor:unselectedTextColor],for: .normal)
        }
    }
    @IBInspectable var selectedColor: UIColor = .green{
        didSet{
            self.selectedSegmentTintColor = selectedColor
        }
    }
    @IBInspectable var unselectedColor: UIColor = .white{
        didSet{
            backgroundColor = unselectedColor
        }
    }
//    override func draw(_ rect: CGRect) {
//        layer.borderWidth = 1.0
//        layer.borderColor = UIColor(named: "orangeYellow")?.cgColor
//        setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
//        setTitleTextAttributes([.foregroundColor: UIColor(named: "orangeYellow") ?? UIColor.systemYellow],for: .normal)
//    }

}
