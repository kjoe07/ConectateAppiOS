//
//  EditarPerfilViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/26/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//
import UIKit
import Photos

class EditarPerfilViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtCP: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCooperativa: UITextField!
    
    var perfil:PerfilCompleto!
    var todos:[Keyword]! = []
    var usuario:Usuario!
    var scrollGestureRecognizer: UITapGestureRecognizer!
    var textFields: [UITextField]!
    var changed = false
    let userData = UserDefaults.standard.value(forKey: "usuario") as? Data ?? Data()
    var user: Usuario?
    @IBOutlet weak var imgPerfil: UIImageView!
    let imagePicker = UIImagePickerController()
    var newpass: String?
    var imagedChange = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        txtNombre.delegate = self
        txtApellido.delegate = self
        txtTelefono.delegate = self
        txtCorreo.delegate = self
        txtPassword.delegate = self
        txtCP.delegate = self
        textFields = [txtNombre, txtApellido, txtCP];
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClick))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        txtTelefono.inputAccessoryView = toolbar
        txtCP.inputAccessoryView = toolbar
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        scrollGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        cargarDatos()
        guard let imageData = UserDefaults.standard.value(forKey: "userImage") as? Data else {return}    
        imgPerfil.image = UIImage(data: imageData)
    }

    
    @IBAction func btnGuardarPerfil(_ sender: Any) {
        print("changed status:",changed)
        if changed{
             guardarPerfil()
        }else if newpass != nil{
            changepass()
        }else{
            if imagedChange {
                self.showAlert(title: "Perfil actualizado", message: "")
                self.navigationController?.popViewController(animated: true)
            }else{
                self.showAlert(title: "Ups!", message: "es necesario cambiar algún campo para guardarlo")
            }
        }
    }
 
    func guardarPerfil(){
        let params = ["nombre":self.txtNombre.text ?? "","apellido":self.txtApellido.text ?? "","cp": txtCP.text ?? ""]
        showActivityIndicator(color: UIColor(named: "green") ?? .green)
        NetworkLoader.loadData(url: Api.updateUser.url, data: params, method: .patch, completion: {[weak self] (result: MyResult<Perfil>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideActivityIndicator()
                switch result{
                case .success( let data):
                    if self.newpass != nil{
                        self.changepass()
                    }else{
                        if self.newpass == nil{
                            self.showAlert(title: "Perfil actulizado", message: "")
                            self.navigationController?.popViewController(animated: true)
                            let data = try? JSONEncoder().encode(data)
                            UserDefaults.standard.set(data, forKey: "usuario")
                        }
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    
    func cargarDatos(){
        self.todos.append(contentsOf: self.perfil.perfil?.descripcion ?? [Keyword]())
        self.todos.append(contentsOf: self.perfil.perfil?.intereses ?? [Keyword]())
        self.todos.append(contentsOf: self.perfil.perfil?.extras ?? [Keyword]())
        
        self.usuario = self.perfil.perfil?.usuario
        
        self.txtNombre.text = self.usuario.nombre
        self.txtApellido.text = self.usuario.apellido
        self.txtTelefono.text = self.usuario.celular
        //self.txtCorreo.text = user.//pref.string(forKey: "mailUsuario")
        self.txtPassword.text = "XXXXX"//pref.string(forKey: "password")
        self.txtCP.text = self.usuario.cp
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/3.0)-5, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "simpleHashCollectionViewCell", for: indexPath) as! SimpleHashCollectionViewCell
        cell.txtHashTags.text = "#\(self.todos[indexPath.row].tag!)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    @IBAction func btnCambiarFoto(_ sender: Any) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch status{
            case .authorized:
                self.loadFromLibrary()
                break
            case .denied:
                self.pedirPermiso(titulo: "Debes habilitar permisos", mensaje: "Para modificar tu foto de perfil es necesario habilites los permisos", aceptar: "Otorgar permiso")
                break
            case .notDetermined:
                break
                
            case .restricted:
                break
                
            @unknown default:
                break
                
            }
        }
    }
    
    func pedirPermiso(titulo:String, mensaje:String, aceptar:String){
        let alertController = UIAlertController (title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
        let settingsAction = UIAlertAction(title: aceptar, style: UIAlertAction.Style.default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func loadFromLibrary(){
        DispatchQueue.main.async {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[.originalImage]  as? UIImage{
            self.imgPerfil.image = image
            saveImage(imageName: user?.nombre ?? "")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveImage(imageName: String){
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the image we took with camera
        let image = imgPerfil.image!
        //get the PNG data for this image
        let data = image.pngData()
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        
        
        UserDefaults.standard.set(data, forKey: "userImage")
        imagedChange = true
        
       // let viewController = self.storyboard?.instantiateViewController(withIdentifier: "perfilCompletoViewController")
       // self.present(viewController!, animated: true, completion: nil)
    }
    
    func getImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            //self.imgPerfil.image = UIImage(contentsOfFile: imagePath)
            
            self.imgPerfil.image = self.rotateImage( image: UIImage(contentsOfFile: imagePath)!)
            
        }else{
            print("Panic! No Image!")
        }
    }
    
    func rotateImage(image:UIImage) -> UIImage {
        var rotatedImage = UIImage()
        switch image.imageOrientation
        {
        case .right:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .down)
        case .down:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .left)
        case .left:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .up)
        default:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
        }
        return rotatedImage
    }
    
    @objc func doneClick(){
        view.endEditing(true)
    }
    
    @objc func hideKeyBoard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if(UIDevice.current.userInterfaceIdiom == .pad){
            
        }else {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func textfieldDidChange(_ textfield: UITextField){
        if textfield == txtCooperativa{
            newpass = textfield.text
        }else if textfield != txtPassword{
            changed = true
        }
    }
    func changepass(){
        let params = ["old_password":txtPassword.text ?? "","new_password":txtCooperativa.text ?? ""]
        showActivityIndicator(color: UIColor(named: "green") ?? .green)
        NetworkLoader.loadData(url: Api.updatePassword.url, data: params, method: .patch, completion: {[weak self] (result: MyResult<ChangePass>) in
            DispatchQueue.main.async {
                guard let self = self else{return}
                self.hideActivityIndicator()
                switch result{
                case .success(dat: let data):
                    if data.result ?? 0  ==  1 {
                        self.showAlert(title: "Exito", message: "su contraseña se ha cambiado con exito")
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    
    @IBAction func editHashtags(_ sender: UIButton){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "InteresesViewController") as! InteresesViewController
        vc.selectedResult = self.perfil.perfil?.intereses
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
