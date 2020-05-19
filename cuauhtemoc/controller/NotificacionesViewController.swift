//
//  NotificacionesViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/26/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class NotificacionesViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var notificaciones:[Notificacion]? = []
    var busqueda: [Notificacion]? = []
    var isSearch = false
    let searchController = UISearchController(searchResultsController: nil)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        cargarDatos()
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsCancelButton = true
        searchController.searchBar.delegate = self
        //searchController.searchBar.placeholder = "Buscar"
       // searchController.searchBar.barStyle = .default
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barTintColor = UIColor(named: "green") ?? .green
        searchController.searchBar.tintColor = UIColor(named: "green") ?? .green
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Buscar", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "green") ?? .green])
        searchController.searchBar.searchTextField.textColor = UIColor(named: "green") ?? .green
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "green") ?? UIColor.systemBlue]
        //searchController.searchBar.barStyle = .default
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        //navigationItem.searchController = searchController
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "fondo"), for: .default)
        let image = UIImage(named: "conectateBar")
        let imageView = UIImageView(image: image)
        navigationItem.titleView = imageView
        //setNeedsStatusBarAppearanceUpdate()
        //tableView.tableHeaderView = searchController.searchBar
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.layer.cornerRadius = 17
            textfield.backgroundColor = .white
            //textfield.textColor = UIColor(named: "green") ?? UIColor.systemBlue
            let placeholder = "Buscar"
            let color = UIColor(named: "green") ?? UIColor.green
            textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
            let textFieldInsideSearchBarLabel = textfield.value(forKey: "placeholderLabel") as? UILabel
            textFieldInsideSearchBarLabel?.textColor = color
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor(named: "green") ?? UIColor.green
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        cargarDatos()
    }
    func cargarDatos(){
        showActivityIndicator(color: UIColor(named: "green") ?? .green)
        NetworkLoader.loadData(url: Api.notification.url, data: [:], method: .get, completion: {[weak self] (result: MyResult<ResponseNotification>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideActivityIndicator()
                switch result{
                case .success(dat: let dat):
                    if dat.count ?? 0 > 0{
                        self.notificaciones = dat.results
                        self.tableView.reloadData()
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificacionesTableViewCell", for: indexPath) as! NotificacionesTableViewCell
        cell.name.text = isSearch ? busqueda?[indexPath.row].cuerpo : notificaciones?[indexPath.row].cuerpo
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "es_MX")
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormater.date(from:  isSearch ? busqueda?[indexPath.row].fecha ?? "" : notificaciones?[indexPath.row].fecha ?? "")
        if let date = date{
            dateFormater.doesRelativeDateFormatting = true
            dateFormater.dateStyle = .medium
            dateFormater.timeStyle = .none
            
            let dateString = dateFormater.string(from: date)
            cell.txtNotificacion.text = dateString//notificaciones?[indexPath.row].content_object?.body ?? ""
        }else{
            cell.txtNotificacion.text = ""//notificaciones?[indexPath.row].content_object?.body ?? ""
        }
        cell.btnAcciom.tag = indexPath.row
        cell.btnAcciom.addTarget(self, action: #selector(self.goChat(_:)), for: .touchUpInside)
        cell.btnAcciom.setTitle("Chat", for: .normal)
        if notificaciones?[indexPath.row].content_object?.tipo == 1 {
            cell.imgTipoNotificacion.setImage(UIImage(named: "emtptyHeart"), for: .normal)
        } else if notificaciones?[indexPath.row].content_object?.tipo == 2 {
            //cell.imgTipoNotificacion.image = UIImage(named: "btn_bloqueat")
            cell.imgTipoNotificacion.setImage(UIImage(named: "btn_bloqueat"), for: .normal)
        } else if notificaciones?[indexPath.row].content_object?.tipo == 3 {
            cell.imgTipoNotificacion.setImage(UIImage(named: "img_mensaje"), for: .normal)
            //cell.imgTipoNotificacion.image = UIImage(named: "img_mensaje")
        } else if notificaciones?[indexPath.row].content_object?.tipo == 4 {
            cell.imgTipoNotificacion.setImage(UIImage(named: "img_trueque_morado"), for: .normal)
            cell.btnAcciom.isHidden = true
        } else if notificaciones?[indexPath.row].content_object?.tipo == 5 {
            cell.imgTipoNotificacion.setImage( UIImage(named: "img_contratar_morado"), for: .normal)
            
        } else if notificaciones?[indexPath.row].content_object?.tipo == 6 {
            cell.imgTipoNotificacion.setImage(UIImage(named: "btn_add_circulo_amarillo"), for: .normal)
            
        } else if notificaciones?[indexPath.row].content_object?.tipo == 7 {
            cell.imgTipoNotificacion.setImage(UIImage(named: "img_lapiz_morado"), for: .normal)
            
        } else if notificaciones?[indexPath.row].content_object?.tipo == 8 {
            cell.imgTipoNotificacion.setImage( UIImage(named: "servicio_precio"), for: .normal)
        } else if notificaciones?[indexPath.row].content_object?.tipo == 9 {
            cell.imgTipoNotificacion.setImage(UIImage(named: "servicio_redes"), for: .normal)
        }
        cell.imgTipoNotificacion.tintColor = UIColor(named: "green") ?? .green
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch ? busqueda?.count ?? 0 : self.notificaciones?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    @IBAction func goChat(_ sender: Any){
        let index = (sender as? UIButton)?.tag ?? 0
        openWhatsApp(phone: isSearch ? busqueda?[index].usuario_envio?.celular ?? "" : notificaciones?[index].usuario_envio?.celular ?? "")
        //openWhatsApp()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != ""{
            isSearch = true
            self.busqueda = self.notificaciones?.filter({
                $0.cuerpo?.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "") ?? false
            })
        }else{
            isSearch = false
            //searchController.isActive = false
        }
        tableView.reloadData()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
