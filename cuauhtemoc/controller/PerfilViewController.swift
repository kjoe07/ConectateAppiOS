//
//  PerfilViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/16/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit
//import AlamofireImage

class PerfilViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate,UISearchResultsUpdating,UISearchBarDelegate {

    @IBOutlet weak var fotosCollectionView: UICollectionView!
    @IBOutlet weak var buscador: UITextField!
    @IBOutlet weak var search: UIView!
    
    //var dato:[Intereses] = []
    var busqueda:[Results]? = []
    var intereses:[Int] = []
    var result: [Results]?
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fotosCollectionView.delegate = self
        fotosCollectionView.dataSource = self
        fotosCollectionView.backgroundColor =  UIColor(white: 1, alpha: 0.0)
        searchController.searchResultsUpdater = self
        definesPresentationContext = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        search.addSubview(searchController.searchBar)
        searchController.searchBar.leftAnchor.constraint(equalTo: search.leftAnchor).isActive = true
        searchController.searchBar.rightAnchor.constraint(equalTo: search.rightAnchor).isActive = true
        searchController.searchBar.heightAnchor.constraint(equalTo: search.heightAnchor).isActive = true
        
        searchController.searchBar.delegate = self

        cargarDatos()
       // buscador.delegate = self
    }
    
    @IBAction func btnGuardar(_ sender: Any) {
        
        if(self.intereses.count == 3){
            self.agregarDescripcion(descripcion: intereses)
        } else {
            enviarMensaje(titulo: "¡Ups!", mensaje: "Selecciona 5 hashtags que describan tu perfil para continuar")
        }
    }
    
    func cargarDatos(){
        let params = ["page_size":300]
        showActivityIndicator(color: .green)
        NetworkLoader.loadData(url: Api.listProfileHashtags.url, data: params, method: .get, completion: {[weak self] (result: MyResult<HashtagProfileResponse>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideActivityIndicator()
                switch result{
                case .success(dat: let dat):
                    if dat.count ?? 0 > 0 && dat.results?.count ?? 0 > 0{
                        self.result = dat.results
                        self.fotosCollectionView.reloadData()
                    }
                case .failure(let e):
                    self.showAlert(title: "", message: e.localizedDescription)
                }
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fotoCollectionView", for: indexPath) as! ImagenesCollectionViewCell
        let url = !isSearching ?  result?[indexPath.row].imagen : busqueda?[indexPath.row].imagen//busqueda[indexPath.row].imagen!
        cell.txtNombre.text = "#\(!isSearching ? result?[indexPath.row].tag ?? "" : busqueda?[indexPath.row].tag ?? "")"
        //cell.imgCell.contentMode = .scaleAspectFit
        if let imageURL = URL(string: url?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""){
            cell.imgCell.kf.setImage(with: imageURL, placeholder: UIImage(named: "hashtagGreen"))
            
            //setImage(with: imageURL, placeholder: UIImage(named: "hashtagGreen"), options: nil, progressBlock: nil, completionHandler: nil) setImage(with: imageURL)//af_setImage(withURL: imageURL)
        }
        if self.intereses.count > 0 {
            if intereses.contains( !isSearching ?  self.result?[indexPath.row].id ?? -1 : busqueda?[indexPath.row].id ?? -1){
                cell.showIcon()
            }else{
                cell.hideIcon()
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? busqueda?.count ?? 0 :  result?.count ?? 0//busqueda.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let val = (UIScreen.main.bounds.width - 80) / 3
        return CGSize(width:  val, height: val)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == fotosCollectionView{
            return 20
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImagenesCollectionViewCell {
            if let index = intereses.firstIndex(of: self.result?[indexPath.row].id ?? -1){
                intereses.remove(at: index)
                cell.hideIcon()
            } else {
                if(self.intereses.count > 2){
                    self.showAlert(title: "¡Ups!", message: "Solo puedes agregar 3 hashtags")
                }else {
                    intereses.append(self.result?[indexPath.row].id ?? 0)
                    cell.showIcon()
                }                
            }
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
    
    func agregarDescripcion(descripcion:[Int]){
        let params = ["descripciones":intereses]
        showActivityIndicator(color: .green)
        NetworkLoader.loadData(url: Api.description.url, data: params, method: .post, completion: {[weak self] (result: MyResult<SendCodeResponse>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideActivityIndicator()
                switch result{
                case .success(dat: let dat):
                    if dat.result ?? 0 == 1{
                        self.performSegue(withIdentifier: InteresesViewController.identifier, sender: self)
                    }else{
                        self.showAlert(title: "¡Ups!", message: "Ocurrio un error al comunicarnos con el servidor")
                    }
                case .failure(let e):
                    self.showAlert(title: "", message: e.localizedDescription)
                }
            }
        })
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchTerm = searchController.searchBar.text
        if  searchTerm != ""{
            isSearching = true
            busqueda =  result?.filter({
//                guard let val = $0.tag else {return false}
//                return searchTerm?.contains(val) ?? false
                $0.tag?.lowercased().contains(searchTerm!.lowercased()) ?? false
            })
            self.fotosCollectionView.reloadData()
        }else{
            isSearching = false
            
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
        
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        isSearching = false
        fotosCollectionView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textchanged")
        if searchText.isEmpty {
            isSearching = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.searchController.resignFirstResponder()
                self.view.endEditing(true)
                self.fotosCollectionView.reloadData()
            }
        }
    }
}
