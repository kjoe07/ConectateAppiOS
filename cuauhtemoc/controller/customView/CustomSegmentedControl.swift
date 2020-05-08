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
    override func draw(_ rect: CGRect) {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(named: "green")?.cgColor  ?? UIColor.green.cgColor
        setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        setTitleTextAttributes([.foregroundColor: UIColor(named: "green") ?? .green],for: .normal)
//        self.selectedSegmentTintColor = UIColor(named: "green") ?? .green
//        self.backgroundColor = .white
    }
    

}
