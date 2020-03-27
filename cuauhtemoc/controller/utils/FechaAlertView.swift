//
//  FechaAlertView.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 10/3/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation
import UIKit


class FechaAlertView: UIView, UITextFieldDelegate {
    
    static let instance = FechaAlertView()
    @IBOutlet weak var txtFecha: UITextField!
    @IBOutlet weak var txtHorario: UITextField!
    @IBOutlet var parentView: UIView!
    
    var pickerViewFecha = UIDatePicker()
    var pickerViewHora = UIDatePicker()
    var fechaString:String!
    var horaString:String!
    
    override init(frame:CGRect){
        super.init(frame:frame)
        
        Bundle.main.loadNibNamed("FechaAlertView", owner: self, options: nil)
        
        txtFecha.delegate = self
        txtHorario.delegate = self
        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        parentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        pickerViewFecha.datePickerMode = UIDatePicker.Mode.date
        pickerViewFecha.locale = Locale.init(identifier: "es_MX")
        
        pickerViewHora.datePickerMode = UIDatePicker.Mode.time
        pickerViewHora.locale = Locale.init(identifier: "es_MX")
        
        cargarFecha()
        cargarHora()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func commonInit(){
        parentView.removeFromSuperview()
    }
    
    @IBAction func btnContinuar() {
        parentView.removeFromSuperview()
    
    }
    
    func showAlert(){
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
    @IBAction func btnRegresar(_ sender: Any) {
        parentView.removeFromSuperview()
        
    }
    
    func cargarFecha(){
        
        txtFecha.inputView = pickerViewFecha
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.parentView.frame.size.height/6, width: self.parentView.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.parentView.frame.size.width/2, y: self.parentView.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor(red: 0.49411764705882, green: 0, blue: 0.49411764705882, alpha: 0)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed) )
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.parentView.frame.size.width / 3, height: self.parentView.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 13)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Selecciona una fecha:"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        txtFecha.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        
        txtFecha.resignFirstResponder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = "dd MMM YYY"
        let fechaFormater1 = dateFormatter.string(from: (pickerViewFecha.date))
        txtFecha.text = fechaFormater1
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        fechaString = dateFormatter.string(from: (pickerViewFecha.date))
    }
    
    func cargarHora(){
        
        txtHorario.inputView = pickerViewHora
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.parentView.frame.size.height/6, width: self.parentView.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.parentView.frame.size.width/2, y: self.parentView.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor(red: 0.49411764705882, green: 0, blue: 0.49411764705882, alpha: 0)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed2) )
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.parentView.frame.size.width / 3, height: self.parentView.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 13)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Selecciona una fecha:"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        txtHorario.inputAccessoryView = toolBar
    }
    
    @objc func donePressed2() {
        
        txtHorario.resignFirstResponder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = "HH:mm"
        let fechaFormater1 = dateFormatter.string(from: (pickerViewHora.date))
        txtHorario.text = fechaFormater1
        
        dateFormatter.dateFormat = "HH:mm"
        horaString = dateFormatter.string(from: (pickerViewHora.date))
    }

}
