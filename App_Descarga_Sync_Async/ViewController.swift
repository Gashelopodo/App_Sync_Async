//
//  ViewController.swift
//  App_Descarga_Sync_Async
//
//  Created by cice on 10/3/17.
//  Copyright © 2017 gashe.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    //MARK: - outlet
    
    @IBOutlet weak var myImageContainerView: UIImageView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    //MARK: - action
    
    @IBAction func syncMethodDownloadACTION(_ sender: Any) {
        
        myActivityIndicator.isHidden = false
        myActivityIndicator.startAnimating()
        
        
        let url = URL(string: "http://www.gratisimagenes.su/wp-content/uploads/2014/09/fondo-17.jpg")
        let data = NSData(contentsOf: url!)
        let image = UIImage(data: data! as Data)
        
        myImageContainerView.image = image
        myActivityIndicator.isHidden = true
        myActivityIndicator.stopAnimating()
    }
    
    @IBAction func asyncMethodDownloadACTION(_ sender: Any) {
        
        let queue = DispatchQueue(label: "downloadsSecondPriority", attributes: [])
        let url = URL(string: "http://www.gratisimagenes.su/wp-content/uploads/2014/09/fondo-17.jpg")
        
        myActivityIndicator.isHidden = false
        myActivityIndicator.startAnimating()
        
        //Creamos la cola en 2º plano
        queue.async {
            
            /*let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)*/
            
            do{
                let data = try Data(contentsOf: url!)
                var image = UIImage(data: data)
                
                //Cola principal
                DispatchQueue.main.async {
                    self.myImageContainerView.image = image
                }
                
            }catch{
                //mostrarmos un alert de error por ejemplo
            }
            
            self.myActivityIndicator.isHidden = true
            self.myActivityIndicator.stopAnimating()
            
        }
        
    }
    
    @IBAction func asyncPlusMethodDownloadACTION(_ sender: Any) {
        
        myActivityIndicator.isHidden = false
        myActivityIndicator.startAnimating()
        
        //callback En modo comando
       /* fotoFondo { (image) in
            self.myActivityIndicator.isHidden = false
            self.myActivityIndicator.startAnimating()
            self.myImageContainerView.image = image
        }*/
        
        //calback especificando funcion
        fotoFondo(pintarImagen)
        
    }
    
    func pintarImagen(_ image : UIImage){
        self.myActivityIndicator.isHidden = true
        self.myActivityIndicator.stopAnimating()
        self.myImageContainerView.image = image
    }
    
    
    typealias imageClosure = (_ image : UIImage) -> ()
    
    //Callback ->
    func fotoFondo(_ callback : @escaping imageClosure){
        DispatchQueue.global().async {
            let url = URL(string: "http://www.gratisimagenes.su/wp-content/uploads/2014/09/fondo-17.jpg")
            
            do{
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                
                //Cola principal
                DispatchQueue.main.async {
                    callback(image!)
                }
                
            }catch{
            
            }
        }
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator.isHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

