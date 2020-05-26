//
//  UItableViewExtension.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 5/26/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit
extension UITableView{
    func setEmptyView(title: String, message: String, imageString: String?) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        //let imageURL = imageString ?? ""
        var image = UIImage()
        if imageString != nil{
            image = convertImageToBW(image: UIImage(imageLiteralResourceName: imageString  ?? ""))
            
        }
         //= //?? UIImage()
        let imageView = UIImageView()
        imageView.image = image
        imageView.layer.cornerRadius = 78
        imageView.clipsToBounds = true
        emptyView.addSubview(imageView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)//UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = .lightGray//UIColor(named: "veryLightPinkTwo")
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)//UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        //titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 78).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 156).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 156).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
func convertImageToBW(image:UIImage) -> UIImage {

    let filter = CIFilter(name: "CIPhotoEffectTonal")

    // convert UIImage to CIImage and set as input

    let ciInput = CIImage(image: image)
    filter?.setValue(ciInput, forKey: "inputImage")

    // get output CIImage, render as CGImage first to retain proper UIImage scale

    let ciOutput = filter?.outputImage
    let ciContext = CIContext()
    let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)

    return UIImage(cgImage: cgImage!)
}
