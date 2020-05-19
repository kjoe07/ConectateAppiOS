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
    @IBOutlet weak var imgPerfil: UIImageView!
    @IBOutlet weak var username: UILabel!
    var perfil:PerfilCompleto!
    var descripcion:[Results]! = []
    var intereses:[Results]! = []
    var extras:[Results]! = []
    var todos:[Results]! = []
    var contenido:ContenidoCompleto!
    var dato:[Post]! = []
    var user: Usuario?
    var opciones = ["Editar perfil","Mis trueques","Mis ventas","Aviso de privacidad"/*,"Términos y condiciones"*/,"Cerrar sesión"]
    var images = ["greenPencil","mano","dolar","servicio_enlace"/*,"servicio_enlace"*/,"power"]
    let imagePicker = UIImagePickerController()
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "fondo"), for: .default)
        let image = UIImage(named: "conectateBar")
        let imageView = UIImageView(image: image)
        navigationItem.titleView = imageView
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
       
        //imgPerfil.layer.cornerRadius = 48.0
        //imgPerfil.clipsToBounds = true
        
        guard let userData = UserDefaults.standard.object(forKey: "usuario") as? Data else {return}
        user = try? JSONDecoder().decode(Usuario.self, from: userData)
        print("ther user:",user)
        cargarDatosPost()
        cargarDatos()
        guard let imageData = UserDefaults.standard.object(forKey: "userImage") as? Data else {return}
        imgPerfil.image = UIImage(data: imageData)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "web"{
            let vc = segue.destination as! WebViewController
            if sender as! String == "term"{
                vc.term = true
            }
        }else if segue.identifier == "truequesContrata"{
            let vc = segue.destination as! MisContratacionesViewController
            vc.trueques = (sender as! String) == "trueques" ? true : false            
        }else if segue.identifier == "editarPerfil"{
            let vc = segue.destination as! EditarPerfilViewController
            vc.perfil = perfil
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let userData = UserDefaults.standard.object(forKey: "userImage") as? Data else {return}
        imgPerfil.image = UIImage(data: userData)
        cargarDatosPost()
        cargarDatos()
    }
    
    @IBAction func loadService(_ sender: UIButton){
        (self.parent?.parent as! UITabBarController).selectedIndex = 1
    }
    
    @IBAction func btnMisContrataciones(_ sender: Any) {
        self.performSegue(withIdentifier: "truequesContrata", sender: "contrata")
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
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        let image = imgPerfil.image!
        let data = image.pngData()
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "perfilCompletoViewController")
        self.present(viewController!, animated: true, completion: nil)
    }
    
    func getImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
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
    
    
    //MARK: - TableView Functions -
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if dato.count > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "perfilTableViewCell", for: indexPath) as! PerfilTableViewCell
                cell.txtTituloContenido.text = self.dato[indexPath.row].titulo
                cell.txtContenido.text = self.dato[indexPath.row].body
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataCell") as! NoDataCell
                cell.addOfert.addTarget(self, action: #selector(self.loadService(_:)), for: .touchUpInside)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell") as! OpcionesTableViewCell
            cell.txtContenido.text = opciones[indexPath.row]
            cell.imagen.image = UIImage(named: images[indexPath.row])
            cell.imagen.tintColor = UIColor(named: "green") ?? .green
            return cell //?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.dato.count > 0 ? dato.count : 1
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as! SeccionesTableViewCell
        if section == 0 {
            cell.txtContenido.text = "Mis ofertas"
        }else{
            cell.txtContenido.text = "Opciones"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if dato.count > 0 {
                self.performSegue(withIdentifier: "truequesContrata", sender: "contrata")
            }
        }else{
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "editarPerfil", sender: self)
            case 1:
                self.performSegue(withIdentifier: "truequesContrata", sender: "trueques")
            case 2:
                self.performSegue(withIdentifier: "truequesContrata", sender: "contrata")
            case 3:
                self.performSegue(withIdentifier: "web", sender: "aviso")
            //case 4:
          //      self.performSegue(withIdentifier: "web", sender: "term")
            case 4:
                UserDefaults.standard.removeObject(forKey: "usuario")
                UserDefaults.standard.removeObject(forKey: "completed")
                UserDefaults.standard.removeObject(forKey: "userImage")
                UserDefaults.standard.synchronize()
                KeychainService.removePassword(service: "cuauhtemoc", account: "token")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                self.view.window?.rootViewController = vc
            default:
                break
            }
        }
    }
        
    //MARK: - CollectionView functions -
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
    //MARK: - Network Functions -
    
    func cargarDatos(){
        showActivityIndicator(color: .green)
        NetworkLoader.loadData(url: Api.seeProfile.url, data: [:], method: .get, completion: {[weak self] (result:MyResult<PerfilCompleto>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideActivityIndicator()
                switch result{
                case .success(let data):
                    if data.perfil != nil{
                        self.descripcion = data.perfil?.descripcion //?? [Results]()
                        self.intereses = data.perfil?.intereses //?? [Results]()
                        self.extras = data.perfil?.extras //?? [Results]
                        self.todos.append(contentsOf: self.descripcion)
                        self.todos.append(contentsOf: self.intereses)
                        self.todos.append(contentsOf: self.extras)
                        self.username.text = "\(data.perfil?.usuario?.nombre ?? "") \(data.perfil?.usuario?.apellido ?? "")"
                        if let urlString = data.perfil?.foto{
                            guard let url = URL(string: urlString) else {return}
                            self.imgPerfil.kf.setImage(with: url)
                        }
                        self.perfil = data
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    
    func cargarDatosPost(){
        let params = ["page_size":30,"usuario": user?.id ?? 0]
        NetworkLoader.loadData(url: Api.listContent.url, data: params, method: .get, completion: {[weak self] (result:MyResult<PostResponse>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(dat: let data):
                    if data.count ?? 0 > 0{
                        self.dato = data.results
                        self.tableView.reloadData()
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    //MARK: -
   

}
