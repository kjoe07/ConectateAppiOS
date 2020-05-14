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
    var todos:[Intereses]! = []
    var usuario:Usuario!
    var scrollGestureRecognizer: UITapGestureRecognizer!
    var textFields: [UITextField]!
    
    
    @IBOutlet weak var imgPerfil: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtNombre.delegate = self
        txtApellido.delegate = self
        txtTelefono.delegate = self
        txtCorreo.delegate = self
        txtPassword.delegate = self
        txtCP.delegate = self
        
        textFields = [txtNombre, txtApellido, txtTelefono, txtCorreo, txtPassword, txtCP];
        
        let toolbar = UIToolbar();
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
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    
    @IBAction func btnRegresar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnEditarPerfil(_ sender: Any) {
    }
    
    @IBAction func btnGuardarPerfil(_ sender: Any) {
        guardarPerfil();
    }
 
    func guardarPerfil(){
        
        let ws = WebServiceClient()
       // let pref = UserDefaults()
        
        let parametros = "{nombre:\(self.txtNombre.text!),apellido:\(self.txtApellido.text!)&cp:\(self.txtCP.text!)}"
        print(parametros)
        
        DispatchQueue.main.async {
            
            ws.wsToken(params: parametros, ws: "/usuarios/update_usuario/", method: "PATCH", completion: {data in
                
                self.enviarMensaje(titulo: "", mensaje: "Tu perfil se ha modificado correctamente")
                
            })
        }
    }
    
    func cargarDatos(){
        
        let ws = WebServiceClient()
        let pref = UserDefaults();
        
        DispatchQueue.main.async {
            ws.wsTokenArray(params: "", ws: "/usuarios/verPerfil/", method: "GET", completion: { data in
                
                do {
                    self.perfil = try JSONDecoder().decode(PerfilCompleto.self, from: data as! Data)
                    
                    self.todos.append(contentsOf: self.perfil.perfil?.descripcion ?? [Intereses]())
                    self.todos.append(contentsOf: self.perfil.perfil?.intereses ?? [Intereses]())
                    self.todos.append(contentsOf: self.perfil.perfil?.extras ?? [Intereses]())
                    
                    self.usuario = self.perfil.perfil?.usuario
                    
                    self.txtNombre.text = self.usuario.nombre
                    self.txtApellido.text = self.usuario.apellido
                    self.txtTelefono.text = self.usuario.celular
                    self.txtCorreo.text = pref.string(forKey: "mailUsuario")
                    self.txtPassword.text = pref.string(forKey: "password")
                    self.txtPassword.text = self.usuario.cp
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/3.0)-5, height: 40)
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
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pref = UserDefaults()
        
        if let image = info[.originalImage]  as? UIImage{
            self.imgPerfil.image = image
            saveImage(imageName:"\(pref.string(forKey: "nombreUsuario")!).png")
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
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
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "perfilCompletoViewController")
        self.present(viewController!, animated: true, completion: nil)
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
    
    func enviarMensaje( titulo:String, mensaje:String){
        
        let btnAlert = UIAlertController(title: titulo, message:mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
        }
        
        btnAlert.addAction(okAction)
        self.present(btnAlert, animated: true, completion: nil)
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
