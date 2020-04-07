//
//  InteresesViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/20/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class InteresesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var fotosCollectionView: UICollectionView!
    @IBOutlet weak var buscador: UITextField!
    
    var dato:[Intereses] = []
    var busqueda:[Intereses] = []
    var intereses:[Int] = []
    var contenido:ContenidoCompleto!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fotosCollectionView.delegate = self
        fotosCollectionView.dataSource = self
        fotosCollectionView.backgroundColor =  UIColor(white: 1, alpha: 0.0)
        
        cargarDatos()
        buscador.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.busqueda.removeAll()
        if(self.buscador.text! == ""){
            self.busqueda.append(contentsOf: self.dato)
        } else {
            for i in 0...self.dato.count-1 {
                if(self.dato[i].tag.lowercased().contains(self.buscador.text!)){
                    busqueda.append(self.dato[i])
                    self.fotosCollectionView.reloadData()
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnGuardar(_ sender: Any) {
        
        if(self.intereses.count == 5){
            
            for i in 0...4 {
                self.agregarDescripcion(descripcion: String(intereses[i]))
            }
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "personalizadoViewController") as! PersonalizadoViewController
            self.present(viewController, animated: true, completion: nil)
        } else {
            enviarMensaje(titulo: "¡Ups!", mensaje: "Selecciona 5 hashtags que describan tu perfil para continuar")
        }
    }
    
    
    func cargarDatos(){
        
        let ws = WebServiceClient()
        
        DispatchQueue.main.async {
            ws.wsToken(params: "", ws: "/clasificador/listHastTagIntereses/?page_size=300", method: "GET", completion: {data in
                
                let algo = data.object(forKey: "results") as! NSArray
                for val in algo {
                    
                    let item = val as! NSDictionary
                    self.dato.append(Intereses(id: item.object(forKey: "id") as! Int, tipo: item.object(forKey: "tipo") as! Int, tag: item.object(forKey: "tag") as! String, imagen: item.object(forKey: "imagen") as! String))
                }
                self.busqueda.append(contentsOf: self.dato)
                DispatchQueue.main.async {
                    self.fotosCollectionView.reloadData()
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let url = busqueda[indexPath.row].imagen!
        let imageURL = URL(string: url)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fotoCollectionView", for: indexPath) as! ImagenesCollectionViewCell
        
        cell.txtNombre.text = "#\(busqueda[indexPath.row].tag!)"
        cell.imgCell.contentMode = .scaleAspectFit
        cell.imgCell.af_setImage(withURL: imageURL!)
        
        if(self.intereses.count>0){
            if intereses.firstIndex(of: self.busqueda[indexPath.row].id) != nil{
                print("Valor \(self.busqueda[indexPath.row].id ?? 0)")
                cell.showIcon()
            } else {
                cell.hideIcon()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return busqueda.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 120)
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
            
            if let index = intereses.firstIndex(of: self.busqueda[indexPath.row].id){
                intereses.remove(at: index)
                cell.hideIcon()
            } else {
                if(self.intereses.count >= 5){
                    self.enviarMensaje(titulo: "¡Ups!", mensaje: "Solo puedes agregar 5 hashtags")
                } else {
                    intereses.append(self.busqueda[indexPath.row].id)
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
    
    func agregarDescripcion(descripcion:String){
        
        let ws = WebServiceClient()
        let parametros = "hashtag=\(descripcion)"
        let pref = UserDefaults();
        
        DispatchQueue.main.async {
            
            ws.wsToken(params: parametros, ws: "/usuarios/unInteres/", method: "POST", completion: {data in
                
                pref.setValue("2", forKey: "bandera")
                
            })
        }
    }
    
    
    /*
     
     func cargarDatos(){
     
     let pref = UserDefaults()
     let request = NSMutableURLRequest(url: NSURL(string: "\(Strings().ws)/clasificador/listHastTagIntereses/?page_size=300")! as URL)
     request.httpMethod = "GET"
     request.setValue("Token \(pref.string(forKey: "token")!)", forHTTPHeaderField: "Authorization")
     
     let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
     
     guard error == nil && data != nil else {
     print(error!.localizedDescription)
     return
     }
     
     guard let data = data else { return }
     do {
     print("Entro")
     self.contenido = try JSONDecoder().decode(ContenidoCompleto.self, from: data)
     print("Parseo")
     print(self.contenido.results.count)
     self.dato.append(contentsOf: self.contenido.results)
     self.busqueda.append(contentsOf: self.contenido.results)
     
     DispatchQueue.main.async {
     self.fotosCollectionView.reloadData()
     
     }
     } catch let jsonError {
     print(jsonError)
     }
     }
     task.resume()
     }
 
 */
    
    
    
}
