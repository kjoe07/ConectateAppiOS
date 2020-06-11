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
    override func viewWillAppear(_ animated: Bool) {
        cargarDatos()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .clear
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        //self.navigationController?.navigationBar.topItem?.title = " "
        //self.title = "Editar Perfil"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
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
                        self.notificaciones = dat.results?.filter({
                            $0.tipo ?? 0 != 2
                        })
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
       
        cell.btnAcciom.setTitle("Chat", for: .normal)
        cell.imgTipoNotificacion.tintColor = UIColor(named: "green") ?? .green
        //cell.imgTipoNotificacion.imageView?.image?.renderingMode = UIImage.RenderingMode.alwaysTemplate
        if notificaciones?[indexPath.row].tipo == 1 {
            cell.imgTipoNotificacion.setImage(#imageLiteral(resourceName: "heartGreen"), for: .normal)
            cell.btnAcciom.isHidden = true
             //cell.btnAcciom.addTarget(self, action: #selector(self.goChat(_:)), for: .touchUpInside)
        } else if notificaciones?[indexPath.row].tipo == 3 {
            cell.imgTipoNotificacion.setImage(UIImage(named: "img_mensaje"), for: .normal)
            cell.btnAcciom.setTitle("Ver", for: .normal)
            cell.btnAcciom.addTarget(self, action: #selector(self.showComments(_:)), for: .touchUpInside)
            cell.btnAcciom.isHidden = false
            //cell.imgTipoNotificacion.image = UIImage(named: "img_mensaje")
        } else if notificaciones?[indexPath.row].tipo == 4 {
            cell.imgTipoNotificacion.setImage(UIImage(named: "img_trueque_morado"), for: .normal)
            cell.btnAcciom.setTitle("Ver", for: .normal)
            cell.btnAcciom.addTarget(self, action: #selector(self.showTrueques(_:)), for: .primaryActionTriggered)
            cell.btnAcciom.isHidden = false
        } else if notificaciones?[indexPath.row].tipo == 5 {
            cell.imgTipoNotificacion.setImage( #imageLiteral(resourceName: "servicio_precio"), for: .normal)
            cell.btnAcciom.isHidden = false
            cell.btnAcciom.addTarget(self, action: #selector(self.goChat(_:)), for: .primaryActionTriggered)
        } else if notificaciones?[indexPath.row].tipo == 7 {
            cell.imgTipoNotificacion.setImage(#imageLiteral(resourceName: "greenPencil"), for: .normal)
            cell.btnAcciom.addTarget(self, action: #selector(self.goChat(_:)), for: .touchUpInside)
            cell.btnAcciom.isHidden = false
        } else if notificaciones?[indexPath.row].tipo == 8 {
            cell.imgTipoNotificacion.setImage( #imageLiteral(resourceName: "servicio_precio"), for: .normal)
             cell.btnAcciom.addTarget(self, action: #selector(self.goChat(_:)), for: .touchUpInside)
            cell.btnAcciom.isHidden = false
        } else if notificaciones?[indexPath.row].tipo == 9 {
            cell.imgTipoNotificacion.setImage(UIImage(named: "servicio_redes"), for: .normal)
            cell.btnAcciom.isHidden = true
             //cell.btnAcciom.addTarget(self, action: #selector(self.goChat(_:)), for: .touchUpInside)
        }
        cell.imgTipoNotificacion.tintColor = UIColor(named: "green") ?? .green
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch{
            if busqueda?.count ?? 0 == 0{
                tableView.setEmptyView(title: "Ups!", message: "no encontramos ninguna publicación que coincida con los criterios de búsqueda", imageString: "Icon")
            }else{
                tableView.restore()
            }
        }else{
            if notificaciones?.count ?? 0 == 0{
                tableView.setEmptyView(title: "", message: "No tienes ninguna notificacion en estos momentos", imageString: "Icon")
            }else{
                tableView.restore()
            }
        }
        return isSearch ? busqueda?.count ?? 0 : self.notificaciones?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    @IBAction func goChat(_ sender: Any){
        let index = (sender as? UIButton)?.tag ?? 0
        openWhatsApp(phone: isSearch ? busqueda?[index].usuario_envio?.celular ?? "" : notificaciones?[index].usuario_envio?.celular ?? "")
    }
    @IBAction func showComments(_ sender:UIButton){
        let vc = UIStoryboard(name: "conecta", bundle: nil).instantiateViewController(identifier: "comentariosViewController") as! ComentariosViewController
        vc.id = self.notificaciones?[sender.tag].content_object?.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func showTrueques(_ sender: UIButton){
        self.performSegue(withIdentifier: "trueques", sender: sender)
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
    func didDismissSearchController(_ searchController: UISearchController) {
        navigationItem.searchController = nil
        self.navigationController?.view.setNeedsLayout()
        self.navigationController?.view.layoutSubviews()
        let view = UIView()
        self.navigationController?.navigationBar.insertSubview(view, at: 1)
        view.removeFromSuperview()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trueques"{
            let vc = segue.destination as! SolicitudesTruequesViewController
            vc.id = self.notificaciones?[(sender as? UIButton)?.tag ?? 0].content_object?.id
        }
    }

}
