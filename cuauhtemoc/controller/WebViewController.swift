//
//  WebViewController.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 5/15/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController,WKNavigationDelegate {
    var term = false
    var aviso = "http://conectateyempleate.com/contenido/aviso/"
    var termino = "https://services.bizne.com.mx/storage/pdf/Terminos%20y%20Condiciones.pdf"
    @IBOutlet weak var web: WKWebView!
    var url: URLRequest!
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicator(color: UIColor(named: "green") ?? .green)
        if !term{
            print("aviso")
            url = URLRequest(url: URL(string: aviso)!)
        }else{
            print("termino")
            url = URLRequest(url: URL(string: termino)!)
        }

        web.load(url)
        web.allowsBackForwardNavigationGestures = true
        web.navigationDelegate = self
        // Do any additional setup after loading the view.
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideActivityIndicator()
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
