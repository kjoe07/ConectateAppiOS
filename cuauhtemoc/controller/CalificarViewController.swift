//
//  CalificarViewController.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 6/10/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit

class CalificarViewController: UIViewController {
    @IBOutlet weak var stack: UIStackView!
    var id: Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func send(_ sender: Any) {
        var i = 0
        for view in stack.subviews{
            if (view as? UIButton)?.isSelected ?? false{
                i += 1
            }
        }
        let params = ["calification": "\(i)"]
        NetworkLoader.loadData(url: "\(Api.calificar.url)\(id ?? 0)/", data: params, method: .patch, completion: { [weak self] (result:MyResult<calificarResponse>)in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(let data):
                    if data.id == self.id{
                        self.navigationController?.popViewController(animated: true)
                        self.showAlert(title: "Felicidades", message: "tu calificación ha sido publicada!")
                    }else{
                        self.showAlert(title: "Ups!", message: "ocurrio un erro")
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
            
        })
//        BackendConnection.postGenericData(urlString: BackendConnection.Endpoints.calificate.url, method: "post", data: params as [String:AnyObject],completion:  {(result:MiBizneResponse?, mesage, response) in
//            if result?.error == nil{
//                self.dissmissed?()
//            }else{
//                self.showAlert(title: "¡Ups!", message: mesage?.message ?? "")
//                self.dissmissed?()
//            }
//        })
    }
       
    @IBAction func action(_ sender: UIButton) {
        //if sender.isSelected{
        for i in 0...sender.tag{
            (stack.subviews[i] as? UIButton)?.isSelected = true
        }
        for i in sender.tag + 1..<stack.subviews.count{
            (stack.subviews[i] as? UIButton)?.isSelected = false
        }
        
        //}
    }
}
