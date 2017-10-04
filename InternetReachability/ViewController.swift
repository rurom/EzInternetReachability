//
//  ViewController.swift
//  InternetReachability
//
//  Created by Roman on 10/1/17.
//  Copyright © 2017 Roman Rudavskiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let inetReachability = InternetReachability()!
    @IBOutlet weak var infoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        inetReachability.whenReachable = { _ in
            DispatchQueue.main.async {
                self.view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                print("Internet is OK!")
            }
        }
        inetReachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                self.inetAlert()
                self.view.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
                    print("Internet connection FAILED!")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: Notification.Name.reachabilityChanged, object: inetReachability)
        
        do {
            try inetReachability.startNotifier()
        } catch {
            print("Could not start notifier")
        }
        
    }//viewDidLoad
    
    
    @objc func internetChanged(note:Notification) {
        
                let reachability =  note.object as! InternetReachability
        
                //reachability.isReachable is deprecated, right solution --> connection != .none
                if reachability.connection != .none {
                    
                    //reachability.isReachableViaWiFi is deprecated, right solution --> connection == .wifi
                    if reachability.connection == .wifi {
                        DispatchQueue.main.async {
                            self.view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                           self.infoLbl.text = "Internet via WIFI is OK!"
                        }
        
                    } else {
                        DispatchQueue.main.async {
                            self.view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                            self.infoLbl.text = "Internet via Cellular is OK!"
                        }
                    }
                } else {
                    inetAlert()
                    self.infoLbl.text = "No Internet connection!"
                    self.view.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                }
            }
    
    func inetAlert() {
        //Alert Pop-up no internet connection
        let alertController = UIAlertController(title: "", message: "Please, check your internet connection", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }

}//class

