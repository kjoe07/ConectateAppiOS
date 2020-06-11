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
    var trueques: [Post]?
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return UITableViewCell()
    }

}
