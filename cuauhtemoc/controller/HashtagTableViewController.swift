//
//  HashtagTableViewController.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 5/12/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit

class HashtagTableViewController: UITableViewController,UISearchResultsUpdating {
    var result: [Results]?
    var filter: [Results]?
    var isSearch = false
    var values: ((String)->Void)?
    var selectedHashtag: (([Results])->Void)?
    var selected = "" //[String] = []
    var hashtags: [Results] = []
    let searchController = UISearchController(searchResultsController: nil)
    var editingModel: [Results]?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = searchController.searchBar
        self.title = "Selecciona varios #"
        self.hashtags = editingModel ?? [Results]()
        searchController.searchResultsUpdater = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        if hashtags.count == 3{
            self.selectedHashtag?(hashtags)
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  isSearch ? filter?.count ?? 0 : result?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = isSearch ? filter?[indexPath.row].tag ?? "" : result?[indexPath.row].tag ?? ""
        
        if editingModel != nil{
            if self.hashtags.contains(where: {
               return  $0.id == (self.isSearch ? self.filter?[indexPath.row].id : self.result?[indexPath.row].id)
            }){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
       // if isTriple{
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            if hashtags.count < 3{
                cell?.accessoryType = .checkmark
                hashtags.append(isSearch ? (filter?[indexPath.row])! : (result?[indexPath.row])!)
            }
        }else{
            cell?.accessoryType = .none
            hashtags.removeAll(where: {
                $0.id == (isSearch ? filter?[indexPath.row].id : result?[indexPath.row].id)
                //$0.tag?.lowercased().contains(isSearch ? filter?[indexPath.row].tag ?? "" : result?[indexPath.row].tag ?? "") ?? false
            })
            print("the count:",hashtags.count)
//            editingModel?.removeAll(where: {
//                $0.tag?.lowercased().contains(isSearch ? filter?[indexPath.row].tag ?? "" : result?[indexPath.row].tag ?? "") ?? false
//            })
        }
//        }else{
//            cell?.accessoryType = .checkmark
//            self.values?( isSearch ? filter?[indexPath.row].tag ?? "" : result?[indexPath.row].tag ?? "")
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != ""{
            isSearch = true
            self.filter = self.result?.filter({
                $0.tag?.lowercased().contains((searchController.searchBar.text ??  "").lowercased()) ?? false
            })
        }else{
           // searchController.isActive = false
            isSearch = false
        }
        tableView.reloadData()
    }


}
