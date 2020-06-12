//
//  SolicitudesTruequesViewController.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 6/11/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit

class SolicitudesTruequesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var trueques: [Accion]?
    var id: Int?
    var formater = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        formater.locale = Locale(identifier: "es_MX")
        formater.dateFormat = "yyyy-MM-dd HH:mm"
        formater.doesRelativeDateFormatting = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trueques?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TruequeTableViewCell
        let date = formater.date(from: trueques?[indexPath.row].fecha ?? "")
        formater.dateStyle = .medium
        cell.dateLabel.text = formater.string(from: date ?? Date())
        cell.title.text = "\(trueques?[indexPath.row].usuario?.nombre ?? "envió su propuesta de trueque:")"
        let val = trueques?[indexPath.row].cuerpo?.components(separatedBy: "|")
        cell.servicio.text = val?[0] ?? ""
        cell.pide.text = val?[1] ?? ""
        cell.aceptButton.tag = indexPath.row
        cell.chatButton.tag = indexPath.row
        cell.rejectButton.tag = indexPath.row
        cell.chatButton.addTarget(self, action: #selector(self.chat(_:)), for: .primaryActionTriggered)
        cell.aceptButton.addTarget(self, action: #selector(self.acept(_:)), for: .primaryActionTriggered)
        cell.rejectButton.addTarget(self, action: #selector(self.cancel(_:)), for: .primaryActionTriggered)
        //cell.pide.text = trueques?[indexPath.row].
        //cell.servicio.text = trueques?[indexPath.row].
        return cell
    }
    
    func loadData(){
        NetworkLoader.loadData(url: "\(Api.singleContent.url)\(id ?? 0)/", data: [:], method: .get, completion: { [weak self] (result: MyResult<PostCompleto>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(let data):
                    if data.acciones?.count  ?? 0 > 0{
                        self.trueques = data.acciones?.filter({
                            $0.tipo == 4
                        })
                        self.tableView.reloadData()
                    }else{
                        self.showAlert(title: "Ups!", message: "algo salio mál y no sabemos que fue")
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    
    @objc func acept(_ sender: UIButton){
        let params = ["tipo":3]
        NetworkLoader.loadData(url: "\(Api.calificar.url)\(trueques?[sender.tag].id ?? 0)/", data:params, method: .put, completion: {[weak self] (result:MyResult<LoginResponse>)in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(let data):
                    print(data)
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    @objc func cancel(_ sender: UIButton){
        let params = ["tipo":4]
        NetworkLoader.loadData(url: "\(Api.calificar.url)\(trueques?[sender.tag].id ?? 0)/", data:params, method: .put, completion: {[weak self] (result:MyResult<LoginResponse>)in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(let data):
                    print(data)
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    
    @objc func chat(_ sender: UIButton){
        let phone = trueques?[sender.tag].usuario?.celular ?? ""
        self.openWhatsApp(phone: phone)
    }

}
