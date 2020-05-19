//
//  MethodViewController.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 5/19/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit

class MethodViewController: UIViewController {
    @IBOutlet weak var efectivoSwitch: UISwitch!
    @IBOutlet weak var paypal: UISwitch!
    @IBOutlet weak var cardSwitch: UISwitch!
    var selected: (([String])->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func acept(_ sender: Any) {
        var option = [String]()
        if efectivoSwitch.isOn{
            option.append("Efectivo")
        }
        if cardSwitch.isOn{
            option.append("Tarjeta de crédito/débito")
        }
        if paypal.isOn{
            option.append("PayPal")
        }
        selected?(option)
        self.dismiss(animated: true, completion: nil)
    }    
}
