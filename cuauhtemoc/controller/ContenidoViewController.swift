//
//  ContenidoViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/21/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class ContenidoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,/* UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,*/ UISearchResultsUpdating {
    
    //var busquedaTxt:[String] = []
    //var contenido:ContenidoCompleto!
    //var dato:[Contenido]! = []
    var busqueda: [Post]?  = []
    //var keywords:[Keyword]! = []
    var result: [Post]?
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching = false
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var segmented: CustomSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buscador: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsCancelButton = true
        
//        self.collectionView.dataSource = self
//        self.collectionView.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
       // self.buscador.delegate = self
        self.cargarDatos()
    }
    
    @IBAction func btnBuscarContenido(_ sender: Any) {
        if tableView.tableHeaderView == nil{
            tableView.tableHeaderView = searchController.searchBar
        }else{
            tableView.tableHeaderView = nil
        }
        
//        self.busqueda.removeAll()
//        if(self.buscador.text! == ""){
//            //self.busqueda.append(contentsOf: self.dato)
//        } else {
//
//            self.busquedaTxt.append(self.buscador.text!)
//
//            for i in 0...self.dato.count-1 {
//                for k in 0...self.busquedaTxt.count-1{
//                    if(self.dato[i].titulo?.lowercased().contains(self.busquedaTxt[k].lowercased()) ?? false
//                        || ((self.dato[i].body?.lowercased().contains(self.busquedaTxt[k].lowercased())) != nil)){
//                        busqueda.append(self.dato[i])
//                    } else {
//                        if (self.dato[i].keywords?.count ?? 0 > 0){
//                            for j in 0...(self.dato[i].keywords?.count ?? 0) - 1 {
//                                if((self.dato[i].keywords?[j].tag.contains(self.busquedaTxt[k].lowercased())) != nil){
//                                    busqueda.append(self.dato[i])
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            self.buscador.text = ""
//        }
//        self.collectionView.reloadData()
//        self.tableView.reloadData()
//        print(self.busqueda.count)
    }
    
    func cargarDatos(){
        let params = ["page_size":300]
        NetworkLoader.loadData(url: Api.listContent.url, data: params, method: .get, completion: {[weak self] (result: MyResult<PostResponse>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(let dat):
                    if dat.count ?? 0 > 0{
                        self.result = dat.results
                        self.tableView.reloadData()
                    }else{
                        self.showAlert(title: "¡Ups!", message: dat.error ?? "")
                    }
                case .failure(let e):
                    self.showAlert(title: "¡Ups!", message: e.localizedDescription)
                }
            }
        })
        
//        let ws = WebServiceClient()
//
//        DispatchQueue.main.async {
//            ws.wsTokenArray(params: "", ws: "/contenido/list_post/?page_size=300", method: "GET", completion: { data in
//
//                do {
//                    self.contenido = try JSONDecoder().decode(ContenidoCompleto.self, from: data as! Data)
//                    self.dato.append(contentsOf: self.contenido.results)
//                    self.busqueda.append(contentsOf: self.contenido.results)
//
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                } catch let jsonError {
//                    print(jsonError)
//                }
//            })
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contenidoViewCell", for: indexPath) as! ContenidoViewCell
        cell.txtTitulo.text = isSearching ?  self.busqueda?[indexPath.row].titulo ?? "": result?[indexPath.row].titulo ?? ""
        cell.txtNombreUsuario.text = isSearching ?  self.busqueda?[indexPath.row].usuario?.nombre ?? "" : result?[indexPath.row].usuario?.nombre ?? ""
       // cell.txtContenido.text = isSearching ? self.busqueda?[indexPath.row].body ?? "" : result?[indexPath.row].body ?? ""
        cell.labelAddress.text = isSearching ? busqueda?[indexPath.row].fecha ?? "" : result?[indexPath.row].fecha
        cell.labelAddress.text = isSearching ? busqueda?[indexPath.row].establecimiento?.direccion : result?[indexPath.row].establecimiento?.direccion 
        if let url = URL(string: "\(Strings().rutaImagen)/\(isSearching ? busqueda?[indexPath.row].img?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "" : result?[indexPath.row].img?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "")"){
            cell.imagenContenido.contentMode = .scaleToFill
            cell.imagenContenido.af_setImage(withURL: url)
        }
        cell.keywords = isSearching ? busqueda?[indexPath.row].keywords : result?[indexPath.row].keywords
        cell.collectionView.dataSource = cell
        cell.collectionView.reloadData()
//        if (self.busqueda?[indexPath.row].keywords?.count ?? 0 > 0){
//            self.keywords.removeAll()
//            cell.keywords.removeAll()
//
//            cell.keywords.append(Keyword(id: 0, tipo: 0, tag: self.busqueda[indexPath.row].tipo!, imagen: ""))
//            self.keywords.append(contentsOf: self.busqueda[indexPath.row].keywords!)
//            cell.keywords.append(contentsOf: self.keywords)
//        }
        
        cell.btnLike.tag = indexPath.row
        cell.btnCompartir.tag = indexPath.row
        cell.btnBloquear.tag = indexPath.row
        cell.btnComentarios.tag = indexPath.row
        cell.btnTruques.tag = indexPath.row
        
        cell.btnLike.addTarget(self, action:#selector(btnLike(sender:)) , for: .touchUpInside)
        
        cell.btnCompartir.addTarget(self, action:#selector(btnCompartir(sender:)) , for: .touchUpInside)
        
        cell.btnBloquear.addTarget(self, action:#selector(btnBloquear(sender:)) , for: .touchUpInside)
        
        cell.btnComentarios.addTarget(self, action:#selector(btnComentarios(sender:)) , for: .touchUpInside)
        
        cell.btnTruques.addTarget(self, action:#selector(btnTruques(sender:)) , for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func btnLike(sender:UIButton){
        
        sender.setBackgroundImage(UIImage(named: "img_like_rosa"), for: UIControl.State.normal)
        wsAccion(tipo: "1",post: self.busqueda![sender.tag].id ?? 0,cuerpo: "")
    }
    
    @objc func btnCompartir(sender:UIButton){
        // let text = UserDefaults.standard.shareCode ?? ""//"Compartir tu Codigo en Redes Sociales."
        // print("text",text)
        //let image = QRCreator.generateQR(from: text) ?? UIImage()//generateQRCode(from: text) ?? UIImage()
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: index) as! ContenidoViewCell
        guard let image2 = cell.imagenContenido else{return}//imageSlider.currentSlideshowItem?.imageView.image else {return}
        // set up activity view controller
        let textToShare = [cell.txtTitulo.text ?? "",image2 ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.saveToCameraRoll,.addToReadingList,.copyToPasteboard,.openInIBooks,.mail,.message,.print ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func btnBloquear(sender:UIButton){
        
        let btnAlert = UIAlertController(title: "Atención", message:"¿Relamente quieres dejar de ver este contenido?", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Sí", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            
            self.wsAccion(tipo: "2",post: self.busqueda![sender.tag].id ?? 0,cuerpo: "")
        }
        
        btnAlert.addAction(okAction)
        self.present(btnAlert, animated: true, completion: nil)
    }
    
    @objc func btnComentarios(sender:UIButton){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "comentariosViewController") as! ComentariosViewController
        viewController.post = isSearching ? self.busqueda?[sender.tag] : result?[sender.tag]
        self.present(viewController, animated: true, completion: nil)
    }

    @objc func btnTruques(sender:UIButton){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ofrecerTruequeViewController") as! OfrecerTruequeViewController
        viewController.post =  isSearching ? self.busqueda?[sender.tag] : result?[sender.tag]
        self.present(viewController, animated: true, completion: nil)
    }

    
    func wsAccion(tipo:String, post:Int, cuerpo:String ){
        let params = ["tipo":tipo,"post":post,"cuerpo":cuerpo] as [String : Any]
        NetworkLoader.loadData(url: Api.contentAction.url, data: params, method: .get, completion: {[weak self] (result: MyResult<ActionResponse?>) in
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
        
//        let ws = WebServiceClient()
//        let params = "tipo=\(tipo)&post=\(post)&cuerpo=\(cuerpo)"
//
//        DispatchQueue.main.async {
//            ws.wsToken(params: params, ws: "/contenido/acciones/add", method: "POST", completion: { data in
//
//            })
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ?  busqueda?.count ?? 0 : result?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "verContenidoViewController") as! VerContenidoViewController
        controller.contenido = isSearching ? busqueda?[indexPath.row] : result?[indexPath.row]//self.dato[indexPath.row]
        self.present(controller, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.imageView?.af_cancelImageRequest()
        cell.imageView?.image = nil
    }
    
    func enviarMensaje( titulo:String, mensaje:String){
        
        let btnAlert = UIAlertController(title: titulo, message:mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
        }
        btnAlert.addAction(okAction)
        self.present(btnAlert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return busquedaTxt.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (collectionView.bounds.width/3.0)-5, height: 40)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "simpleHashCollectionViewCell", for: indexPath) as! SimpleHashCollectionViewCell
//        cell.txtHashTags.text = "#\(self.busquedaTxt[indexPath.row])"
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        self.busquedaTxt.remove(at: indexPath.row)
//
//        if(self.busquedaTxt.count <= 0){
//            self.busqueda.append(contentsOf: self.contenido.results)
//            self.tableView.reloadData()
//        }
//
//        collectionView.reloadData()
//    }
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != ""{
            isSearching = true
            self.busqueda = result?.filter({
                $0.titulo?.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "") ?? false
            })
        }else{
            isSearching = false
        }
        tableView.reloadData()
    }
    
}
