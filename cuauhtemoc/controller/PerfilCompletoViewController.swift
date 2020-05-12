//
//  PerfilCompletoViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/26/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit
import Photos

class PerfilCompletoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var perfil:PerfilCompleto!
    var descripcion:[Intereses]! = []
    var intereses:[Intereses]! = []
    var extras:[Intereses]! = []
    var todos:[Intereses]! = []
    var contenido:ContenidoCompleto!
    var dato:[Contenido]! = []
    
    @IBOutlet weak var imgPerfil: UIImageView!
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        cargarDatosPost()
        cargarDatos()
        let pref = UserDefaults();

//        getImage(imageName: "\(pref.string(forKey: "nombreUsuario")!).png")
        imgPerfil.layer.cornerRadius = 48.0
        imgPerfil.clipsToBounds = true
    }
    
    @IBAction func btnEditarPerfil(_ sender: Any) {

        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "editarPerfilViewController") as! EditarPerfilViewController
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnChat(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
        
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnMisTrueques(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "misTruequesViewController") as! MisTruequesViewController
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnMisContrataciones(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "misContratacionesViewController") as! MisContratacionesViewController
        
        self.present(viewController, animated: true, completion: nil)
        
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
        
        if let image = info[.originalImage] as? UIImage{
                self.imgPerfil.image = image//UIImagePickerController.InfoKey.originalImage
                saveImage(imageName:"\(pref.string(forKey: "nombreUsuario")!).png")
            
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "perfilTableViewCell", for: indexPath) as! PerfilTableViewCell
        
        cell.txtTituloContenido.text = self.dato[indexPath.row].titulo
        cell.txtContenido.text = self.dato[indexPath.row].body
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dato.count
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
    
    func cargarDatos(){
        
        let ws = WebServiceClient()
        
        DispatchQueue.main.async {
            ws.wsTokenArray(params: "", ws: "/usuarios/verPerfil/", method: "GET", completion: { data in
                
                do {
                    self.perfil = try JSONDecoder().decode(PerfilCompleto.self, from: data as! Data)
                    self.descripcion.append(contentsOf: self.perfil.perfil?.descripcion ?? [Intereses]())
                    self.intereses.append(contentsOf: self.perfil.perfil?.descripcion ?? [Intereses]())
                    self.extras.append(contentsOf: self.perfil.perfil?.descripcion ?? [Intereses]())
                    
                    self.todos.append(contentsOf: self.perfil.perfil?.descripcion ?? [Intereses]())
                    self.todos.append(contentsOf: self.perfil.perfil?.intereses ?? [Intereses]())
                    self.todos.append(contentsOf: self.perfil.perfil?.extras ?? [Intereses]())
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            })
        }
    }
    
    func cargarDatosPost(){
        
        let ws = WebServiceClient()
        let pref = UserDefaults();
        print("/contenido/list_post/?page_size=30&usuario=\(pref.value(forKey: "idUsuario") ?? 0)")
        
        DispatchQueue.main.async {
            ws.wsTokenArray(params: "", ws: "/contenido/list_post/?page_size=30&usuario=\(pref.value(forKey: "idUsuario") ?? "")", method: "GET", completion: { data in
                
                do {
                    self.contenido = try JSONDecoder().decode(ContenidoCompleto.self, from: data as! Data)
                    self.dato.append(contentsOf: self.contenido.results)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            })
        }
    }
    
    @IBAction func btnMercado(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "contenidoViewController") as! ContenidoViewController
    
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func btnCargarOferta(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "cargarOfertaViewController") as! CargarOfertaViewController
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnNotificaciones(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "notificacionesViewController") as! NotificacionesViewController
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnPerfil(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "perfilCompletoViewController") as! PerfilCompletoViewController
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnEmpelo(_ sender: Any) {
        
        
    }
   

}
