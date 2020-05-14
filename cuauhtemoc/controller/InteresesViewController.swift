//
//  InteresesViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/20/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class InteresesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var fotosCollectionView: UICollectionView!
    @IBOutlet weak var search: UIView!
    //@IBOutlet weak var buscador: UITextField!
    
    var dato:[Intereses] = []
    var busqueda:[Results]? = []
    var result: [Results]?
    var intereses:[Int] = []
    var contenido:ContenidoCompleto!
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fotosCollectionView.delegate = self
        fotosCollectionView.dataSource = self
        fotosCollectionView.backgroundColor =  UIColor(white: 1, alpha: 0.0)
        cargarDatos()
        definesPresentationContext = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        search.addSubview(searchController.searchBar)
        searchController.searchBar.leftAnchor.constraint(equalTo: search.leftAnchor).isActive = true
        searchController.searchBar.rightAnchor.constraint(equalTo: search.rightAnchor).isActive = true
        searchController.searchBar.heightAnchor.constraint(equalTo: search.heightAnchor).isActive = true
        
        searchController.searchBar.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnGuardar(_ sender: Any) {
        
        if(self.intereses.count == 5){
            self.agregarDescripcion(values: intereses)
        } else {
            self.showAlert(title: "¡Ups!", message: "Selecciona 5 hashtags que describan tu perfil para continuar")
        }
    }
    
    func cargarDatos(){
        let params = ["page_size":300]
        showActivityIndicator(color: .green)
        NetworkLoader.loadData(url: Api.listInterestHashtags.url, data: params, method: .get, completion: {[weak self] (result: MyResult<HashtagProfileResponse>) in
            DispatchQueue.main.async {
                guard let self = self else  {return}
                self.hideActivityIndicator()
                switch result{
                case .success(dat: let data):
                    if data.count ?? 0 > 0 && data.results?.count ?? 0 > 0{
                        self.result = data.results
                        //self.busqueda = data.results ?? [Results]()
                        self.fotosCollectionView.reloadData()
                    }
                case .failure(let e):
                    self.showAlert(title: "¡Ups!", message: e.localizedDescription)
                }
            }
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fotoCollectionView", for: indexPath) as! ImagenesCollectionViewCell
        cell.txtNombre.text = "#\(isSearching ?  busqueda?[indexPath.row].tag ?? "" : result?[indexPath.row].tag ?? "")"
        if let url = isSearching ? busqueda?[indexPath.row].imagen?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) : result?[indexPath.row].imagen?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "", let imageURL = URL(string: url){
            cell.imgCell.kf.setImage(with: imageURL)//af_setImage(withURL: imageURL)
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
        return isSearching ? busqueda?.count ?? 0 : result?.count ?? 0
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
            if let index = intereses.firstIndex(of: isSearching ? self.busqueda?[indexPath.row].id ?? 0 : self.result?[indexPath.row].id ?? 0){
                intereses.remove(at: index)
                cell.hideIcon()
            } else {
                if(self.intereses.count >= 5){
                    self.showAlert(title: "¡Ups!", message: "Solo puedes agregar 5 hashtags")
                } else {
                    intereses.append(isSearching ? self.busqueda?[indexPath.row].id ?? 0 : self.result?[indexPath.row].id ?? 0)
                    cell.showIcon()
                }
            }
        }
    }
    
    func agregarDescripcion(values:[Int]){
        let params = ["intereses":values]
        showActivityIndicator(color: .green)
        NetworkLoader.loadData(url: Api.addInterest.url, data: params, method: .post, completion: {[weak self] (resul: MyResult<SendCodeResponse>) in
            DispatchQueue.main.async {
                guard let self = self else{return}
                self.hideActivityIndicator()
                switch resul{
                case .success(dat: let data):
                    if data.result ?? 0 == 1{
                        self.performSegue(withIdentifier: PersonalizadoViewController.identifier, sender: self)
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
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textchanged")
        if searchText.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.searchController.resignFirstResponder()
                self.view.endEditing(true)
            }
        }
    }
}
