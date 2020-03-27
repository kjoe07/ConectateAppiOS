//
//  ContenidoViewCell.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/21/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class ContenidoViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var keywords:[Keyword]! = []
    
    @IBOutlet weak var imagenContenido: UIImageView!
    
    @IBOutlet weak var txtCoincidencia: UILabel!
    
    @IBOutlet weak var txtTitulo: UILabel!
    
    @IBOutlet weak var txtNombreUsuario: UILabel!
    
    @IBOutlet weak var txtContenido: UILabel!
    
    @IBOutlet weak var txtNumComentarios: UILabel!
    
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var btnBloquear: UIButton!
    
    @IBOutlet weak var btnCompartir: UIButton!
    
    @IBOutlet weak var btnComentarios: UIButton!
    
    @IBOutlet weak var btnTruques: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }
    
    func showIcon() {
        
        
        
    }
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width/3.0)-5, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
         return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "simpleHashCollectionViewCell", for: indexPath) as! SimpleHashCollectionViewCell
        
        cell.txtHashTags.text = "#\(keywords[indexPath.row].tag!)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    
}
