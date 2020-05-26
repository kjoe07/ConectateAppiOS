//
//  OfrecerTruequeViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/25/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class OfrecerTruequeViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var textFields: [UITextField]!
    var post: Post?
    var perfil:PerfilCompleto!
    var descripcion:[Keyword]! = []
    
    @IBOutlet weak var txtPerfil: UITextField!
    @IBOutlet weak var txtOfreces: UITextField!
    @IBOutlet weak var txtCambio: UITextField!
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtOfreces.delegate = self
        txtCambio.delegate = self
        pickerView.delegate = self
        
        textFields = [txtPerfil, txtOfreces, txtCambio];
        cargarDatos()
    }
    
    @IBAction func btnHacerTrueque(_ sender: Any) {
        if(validarDatos(textFields: textFields)){
            wsAccion(tipo: "4",post: self.post?.id ?? 0,cuerpo: "\(self.txtOfreces.text!)|\(self.txtCambio.text!)")
        }
    }

    func validarDatos(textFields: [UITextField]) -> Bool{
        for textField in textFields {
            if (textField.text?.isEmpty)!{
                self.showAlert(title: "¡Ups!", message: "Todos los campos para continuar")
                return false;
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func wsAccion(tipo:String, post:Int, cuerpo:String ){
        let params = ["tipo":tipo,"post":post,"cuerpo":cuerpo] as [String : Any]
        NetworkLoader.loadData(url: Api.contentAction.url, data: params, method: .post, completion: {[weak self] (result: MyResult<ActionResponse?>) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result{
                case.success(dat: let dat):
                    if dat?.count ?? 0 > 0 {
                        print("success")
                    }
                case .failure(let e):
                    print(e.localizedDescription)
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    
    @IBAction func btnRegresar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    func cargarDatos(){
        showActivityIndicator(color: .green)
        NetworkLoader.loadData(url: Api.seeProfile.url, data: [:], method: .get, completion:{ [weak self] (result: MyResult<PerfilCompleto>) in
            DispatchQueue.main.async {
                guard let self = self else{return}
                self.hideActivityIndicator()
                switch result{
                case .success(dat: let data):
                    if data.perfil != nil{
                        self.perfil = data
                        self.descripcion = data.perfil?.descripcion ?? [Keyword]()
                        self.cargarHashTags()
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    
    func cargarHashTags(){
        
        txtPerfil.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.black
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor(red: 0.49411764705882, green: 0, blue: 0.49411764705882, alpha: 0)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed2) )
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 13)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Selecciona:"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        txtPerfil.inputAccessoryView = toolBar
    }
    
    @objc func donePressed2() {
        
        print("Ingreso")
        txtPerfil.resignFirstResponder()
        txtPerfil.text = descripcion[pickerView.selectedRow(inComponent: 0)].tag
        //txtHasTags.text = busqueda[pickerViewHashTags.selectedRow(inComponent: 0)]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.descripcion.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.descripcion![row].tag
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
