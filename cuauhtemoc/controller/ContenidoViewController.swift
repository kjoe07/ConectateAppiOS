//
//  ContenidoViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/21/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit
import Kingfisher
import BadgeControl
class ContenidoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,/* UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,*/ UISearchResultsUpdating,UISearchControllerDelegate {
    
    //var busquedaTxt:[String] = []
    //var contenido:ContenidoCompleto!
    //var dato:[Contenido]! = []
    var busqueda: [Post]?  = []
    //var keywords:[Keyword]! = []
    var result: [Post]?
    var employ: [Post]?
    let searchController = UISearchController(searchResultsController: nil)
    let locationDelegate = LocationCoordinateDelegate()
    var isSearching = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmented: CustomSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buscador: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        //navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsCancelButton = true
        searchController.delegate  = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        locationDelegate.requestAuthorization()
        locationDelegate.updated = {[weak self] loc in
            guard let self = self else {return}
            self.cargarDatos(latitud: loc.latitude, longitud: loc.longitude)
        }
        self.cargarDatos(latitud: nil, longitud: nil)
    }
    
    @IBAction func btnBuscarContenido(_ sender: Any) {
        if navigationItem.searchController == nil{
            navigationItem.searchController = searchController
            self.navigationController?.view.setNeedsLayout()
            self.navigationController?.view.layoutIfNeeded()
        }else{
            navigationItem.searchController = nil
            self.navigationController?.view.setNeedsLayout()
            self.navigationController?.view.layoutIfNeeded()
        }
    }
    
    func cargarDatos(latitud:Double?,longitud: Double?){
        var params = ["page_size":300] as [String:Any]
        if latitud != nil{
            params["latitud"] = latitud ?? 0.0
        }
        if longitud != nil{
            params["longitud"] = longitud ?? 0.0
        }
        NetworkLoader.loadData(url: Api.listContent.url, data: params, method: .get, completion: {[weak self] (result: MyResult<PostResponse>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(let dat):
                    if dat.count ?? 0 > 0{
                        self.result = dat.results
                        self.employ = dat.results?.filter({
                            $0.tipo?.lowercased() == "empleo"
                        })
                        self.tableView.reloadData()
                    }else{
                        self.showAlert(title: "¡Ups!", message: dat.error ?? "")
                    }
                case .failure(let e):
                    self.showAlert(title: "¡Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    //MARK: - TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? busqueda?.count ?? 0 : segmented.selectedSegmentIndex == 0 ? result?.count ?? 0 : employ?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "verContenidoViewController") as! VerContenidoViewController
        controller.contenido = isSearching ? busqueda?[indexPath.row] : segmented.selectedSegmentIndex == 0 ? result?[indexPath.row] : employ?[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        //self.present(controller, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let myCell = cell as! ContenidoViewCell
        myCell.imagenContenido.image = #imageLiteral(resourceName: "hashtagGreen")
        myCell.imagenContenido.contentMode = .center
        myCell.imagenContenido.kf.cancelDownloadTask()
        myCell.labelAddress.isHidden = false
        //myCell.labelSchedule.isHidden = false
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contenidoViewCell", for: indexPath) as! ContenidoViewCell
        cell.txtTitulo.text = isSearching ?  self.busqueda?[indexPath.row].titulo ?? "": segmented.selectedSegmentIndex == 0 ? result?[indexPath.row].titulo ?? "" : employ?[indexPath.row].titulo ?? ""
        cell.txtNombreUsuario.text = isSearching ?  self.busqueda?[indexPath.row].usuario?.nombre ?? "" : segmented.selectedSegmentIndex == 0 ? result?[indexPath.row].usuario?.nombre ?? "" : employ?[indexPath.row].usuario?.nombre ?? ""
        cell.txtCoincidencia.isHidden = true
        let distance = isSearching ? busqueda?[indexPath.row].distancia : segmented.selectedSegmentIndex == 0 ? result?[indexPath.row].distancia :  employ?[indexPath.row].distancia
        if distance != nil {
            cell.txtCoincidencia.isHidden = false
            let double = Double(distance ?? "0") ?? 0.0
            let formater = MeasurementFormatter()
            formater.locale = Locale(identifier: "es_MX")
            formater.numberFormatter.usesGroupingSeparator = true
            formater.numberFormatter.maximumFractionDigits = 0
            formater.unitOptions = .naturalScale
            formater.unitStyle = .short
            let measure = Measurement(value: double, unit: UnitLength.kilometers )
            let stringDistance  = formater.string(from: measure)
            cell.txtCoincidencia.text = "a \(stringDistance)"
        }
        if isSearching ? busqueda?[indexPath.row].establecimiento != nil : segmented.selectedSegmentIndex == 0 ? result?[indexPath.row].establecimiento != nil : employ?[indexPath.row].establecimiento != nil{
            cell.labelAddress.text = isSearching ? busqueda?[indexPath.row].establecimiento?.direccion : result?[indexPath.row].establecimiento?.direccion
            cell.locationIcon.isHidden = false
        }else{
            cell.locationIcon.isHidden = true
            cell.labelAddress.text = isSearching ? busqueda?[indexPath.row].body ?? "" : segmented.selectedSegmentIndex == 0 ? result?[indexPath.row].body ?? "" : employ?[indexPath.row].body ?? ""
        }
        cell.txtNumComentarios.text = "\(isSearching ? busqueda?[indexPath.row].comments ?? 0 : segmented.selectedSegmentIndex == 0 ? result?[indexPath.row].comments ?? 0 : employ?[indexPath.row].comments ?? 0) comentarios "
        let imagenURlString = isSearching ? busqueda?[indexPath.row].img?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "" : segmented.selectedSegmentIndex == 0 ? result?[indexPath.row].img?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "" : employ?[indexPath.row].img?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        print("imageurlString:",imagenURlString)
        if imagenURlString != "",  let url = URL(string: "\(Strings().rutaImagen)/\(imagenURlString)"){
            print("the url:",url.description)
            cell.imagenContenido.contentMode = .scaleToFill
            cell.imagenContenido.kf.setImage(with: url)//af_setImage(withURL: url)
        }
        let badge = BadgeController(for: cell.btnTruques, in: .upperRightCorner, badgeBackgroundColor: UIColor(named: "green") ?? .green, badgeTextColor: .white, badgeTextFont: nil, borderWidth: 1, borderColor: UIColor(named: "green") ?? .green, animation: nil, badgeHeight: 20, animateOnlyWhenBadgeIsNotYetPresent: true)
        badge.addOrReplaceCurrent(with: isSearching ? busqueda?[indexPath.row].trueques?.description ?? "0" : segmented.selectedSegmentIndex == 0 ? result?[indexPath.row].trueques?.description ?? "0" : employ?[indexPath.row].trueques?.description ?? "0", animated: true)
        cell.keywords = isSearching ? busqueda?[indexPath.row].keywords : segmented.selectedSegmentIndex == 0 ? result?[indexPath.row].keywords : employ?[indexPath.row].keywords
        cell.collectionView.dataSource = cell
        cell.collectionView.reloadData()
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
    //MARK: -
    
    @objc func btnLike(sender:UIButton){
        let id = isSearching ? self.busqueda![sender.tag].id ?? 0 : segmented.selectedSegmentIndex == 0 ? result?[sender.tag].id ?? 0 : employ?[sender.tag].id ?? 0
        wsAccion(tipo: "1",post: id ,cuerpo: "")
    }
    
    @objc func btnCompartir(sender:UIButton){
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: index) as! ContenidoViewCell
        guard let image2 = cell.imagenContenido else{return}//imageSlider.currentSlideshowItem?.imageView.image else {return}
        let textToShare = [cell.txtTitulo.text ?? "",image2 ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.saveToCameraRoll,.addToReadingList,.copyToPasteboard,.openInIBooks,.mail,.message,.print ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func btnBloquear(sender:UIButton){
        let id = isSearching ? self.busqueda![sender.tag].id ?? 0 : segmented.selectedSegmentIndex == 0 ? result?[sender.tag].id ?? 0 : employ?[sender.tag].id ?? 0
        let btnAlert = UIAlertController(title: "Atención", message:"¿Relamente quieres dejar de ver este contenido?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Sí", style: UIAlertAction.Style.default) {_ in
            self.wsAccion(tipo: "2",post: id,cuerpo: "")
        }
        btnAlert.addAction(okAction)
        self.present(btnAlert, animated: true, completion: nil)
    }
    
    @objc func btnComentarios(sender:UIButton){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "comentariosViewController") as! ComentariosViewController
        viewController.post = isSearching ? self.busqueda?[sender.tag] : segmented.selectedSegmentIndex == 0 ?  result?[sender.tag] : employ?[sender.tag]
        self.present(viewController, animated: true, completion: nil)
    }

    @objc func btnTruques(sender:UIButton){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ofrecerTruequeViewController") as! OfrecerTruequeViewController
        viewController.post =  isSearching ? self.busqueda?[sender.tag] :  segmented.selectedSegmentIndex == 0 ?  result?[sender.tag] : employ?[sender.tag]
        self.navigationController?.pushViewController(viewController, animated: true)
        //self.present(viewController, animated: true, completion: nil)
    }

    
    func wsAccion(tipo:String, post:Int, cuerpo:String ){
        let params = ["tipo":tipo,"post":post,"cuerpo":cuerpo] as [String : Any]
        NetworkLoader.loadData(url: Api.contentAction.url, data: params, method: .post, completion: {[weak self] (result: MyResult<Contenido?>) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result{
                case.success(dat: let dat):
                    if dat?.id ?? 0 > 0 {
                        self.showAlert(title: "Felicidades", message: "Tu propuesta de trueque fue enviada")
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let e):
                    print(e.localizedDescription)
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != ""{
            isSearching = true
            if segmented.selectedSegmentIndex == 0 {
                self.busqueda = result?.filter({
                    $0.titulo?.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "") ?? false
                })
            }else{
                self.busqueda = employ?.filter({
                    $0.titulo?.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "") ?? false
                })
            }
        }else{
            isSearching = false
        }
        tableView.reloadData()
    }
    
    @IBAction func change(_ sender: Any) {
        tableView.reloadData()
    }
    func didDismissSearchController(_ searchController: UISearchController) {
        navigationItem.searchController = nil
        self.navigationController?.view.setNeedsLayout()
        self.navigationController?.view.layoutSubviews()
        let view = UIView()
        self.navigationController?.navigationBar.insertSubview(view, at: 1)
        view.removeFromSuperview()
    }
}
