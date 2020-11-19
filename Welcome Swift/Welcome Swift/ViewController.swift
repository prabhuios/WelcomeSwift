//
//  ViewController.swift
//  Welcome Swift
//
//  Created by apple on 10/11/20.
//

import UIKit
import CoreLocation

import SystemConfiguration.CaptiveNetwork

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lbl: UILabel!
    
    var locationManager = CLLocationManager()

    
    var ssid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        // 1
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
            
        // 2
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
            
        }
        
        // 4
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {

        let ssid = self.getConnectedWifiInfo()

            print(ssid?["SSID"])
            
        }
        
    }
    override func viewWillLayoutSubviews() {
        
        lbl.font = .systemFont(ofSize: 14)
        lbl.text = "HI"
        lbl.sizeToFit()
    }
    
    func say(_ text: String) {
        
        print(text)
    }
}

extension ViewController {
    
    // 1
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            print("Current location: \(currentLocation)")
        }
    }

    // 2
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func getConnectedWifiInfo() -> [AnyHashable: Any]? {

        if let ifs = CFBridgingRetain( CNCopySupportedInterfaces()) as? [String],
            let ifName = ifs.first as CFString?,
            let info = CFBridgingRetain( CNCopyCurrentNetworkInfo((ifName))) as? [AnyHashable: Any] {

            return info
        }
        return nil

    }
}

