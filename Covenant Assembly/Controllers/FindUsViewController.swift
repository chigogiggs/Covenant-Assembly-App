//
//  FindUsViewController.swift
//  Covenant Assembly
//
//  Created by godwin anyaso on 16/08/2019.
//  Copyright © 2019 godwin anyaso. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subTitle: String?
    
    init(pintTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D){
        self.title = pintTitle
        self.subTitle = pinSubTitle
        self.coordinate = location
    }
}
class FindUsViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate{
    @IBOutlet weak var distancelabel: UILabel!
    @IBOutlet weak var arrivaltime: UILabel!
    @IBOutlet weak var defaultview: UIButtonX!
    @IBOutlet weak var sateliteview: UIButtonX!
    @IBOutlet weak var infoview: UIViewX!
    @IBOutlet weak var textview: UITextFieldX!
    @IBOutlet weak var mapview: MKMapView!
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sateliteview.alpha = 0
        defaultview.alpha = 0
        infoview.alpha = 0
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        if let coor = mapview.userLocation.location?.coordinate{
            mapview.setCenter(coor, animated: true)
        }
        
//        let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
//        let regionn = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 4.995467, longitude: 7.892301)
//, span: span)
//
//        self.mapview.setRegion(regionn, animated: true)
        
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: locValue, span: span)
//        mapview.setRegion(region, animated: true)
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = locValue
//        annotation.title = "You"
//        annotation.subtitle = "current location"
//        mapview.addAnnotation(annotation)
//
//        //centerMap(locValue)
//    }
    
    
    func getcoord(address: String) -> [Double] {
        var list = [Double]()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    print("couldnt find corrd for that address")
                    return
            }
            print("location is \(location.coordinate)")
            // Use your location
            list.append(location.coordinate.latitude)
            list.append(location.coordinate.longitude)
            print("list is \(list)")

        }
        return list
    }
    
    func get_direction(str_sourcelocation: String!){
        
//        let sourcelocation: CLLocationCoordinate2D!
//        let cords = getcoord(address: str_sourcelocation)
        
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(str_sourcelocation) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    print("couldnt find corrd for that address")
                    return
            }
            print("location is \(location.coordinate)")
            // Use your location
        print("here\(location)")
//        if cords.count != 0{
            print("kokokok")
        
            let sourcelocation = CLLocationCoordinate2D(latitude: 40.679827,
                                                    longitude: -73.995416)
        
            //CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.latitude)
            //
            let destinationlocation = CLLocationCoordinate2D(latitude: 40.685407, longitude: -73.994534)
                
                //CLLocationCoordinate2D(latitude: 4.995467, longitude: 7.892301)
        
            let sourcepin = customPin(pintTitle: str_sourcelocation, pinSubTitle: "", location: sourcelocation)
            let destinationpin = customPin(pintTitle: "Word of Faith Covenant Assembly", pinSubTitle: "", location: destinationlocation)
        
            self.mapview.addAnnotation(sourcepin)
            self.mapview.addAnnotation(destinationpin)
        
        
            let sourceplacemark = MKPlacemark(coordinate: sourcelocation)
            let destinationplacemark = MKPlacemark(coordinate: destinationlocation)
        
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourceplacemark)
            directionRequest.destination = MKMapItem(placemark: destinationplacemark)
            directionRequest.transportType = .automobile
        
        
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let directionResponse = response else {
                    if let error = error {
                        print("we have error getting directions == \(error.localizedDescription)")
                        self.popup(title: "Hold up!", msg: error.localizedDescription)
                    }
                    return
                }
                let route = directionResponse.routes[0]
                self.mapview.addOverlay(route.polyline, level: .aboveRoads)
                var rect  = route.polyline.boundingMapRect
//                rect.size.height = rect.height + (rect.height * 0.5)
                rect.size.width = rect.height + (rect.width * 0.5)
                
                                self.mapview.setCenter(route.polyline.coordinate, animated: true)
                let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
                let region = MKCoordinateRegion(center: route.polyline.coordinate, span: span)
                
                self.mapview.setRegion(region, animated: true)
                
                let distance = route.distance
                let ETa = route.expectedTravelTime
                let realETA = self.stringFromTimeInterval(interval: ETa)
                
                UIView.animate(withDuration: 1, animations: {
                    self.distancelabel.text = "Distance: \(distance/1000) Km"
                    self.arrivaltime.text = "Arrival Time: \(realETA[1]) Mins "
                    self.infoview.alpha = 1
                    
                })
                
                
                
                
            }
        }
        self.mapview.delegate = self
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
    
    @IBAction func use_my_current_location(_ sender: Any) {
        textview.placeholder = "current location"
        view.endEditing(true)
        get_direction(str_sourcelocation: "New york")
    }
    
    @IBAction func go(_ sender: Any) {
        
        let address = self.textview.text
        if address == ""{
            print("addres bar iss rempty")
            popup(title: "Hold Up!", msg: "address bar is empty")
        }
        else{
            view.endEditing(true)
            get_direction(str_sourcelocation: address)
        }
        
    }
    @IBAction func mylocation(_ sender: Any) {
        if let coor = mapview.userLocation.location?.coordinate{
            mapview.setCenter(coor, animated: true)
        }
    }
    
    @IBAction func dropdown(_ sender: Any) {
        UIView.animate(withDuration: 1.3) {
            if self.sateliteview.alpha == 0{
                self.sateliteview.alpha = 1
            }else {
                self.sateliteview.alpha = 0
            }
            
            if self.defaultview.alpha == 0{
                self.defaultview.alpha = 1
            }else {
                self.defaultview.alpha = 0
            }

        }
        
        
    }
    
    
    @IBAction func satelite(_ sender: Any) {
        self.mapview.mapType = .satellite
//        dropdown(self)
    }
    @IBAction func defaultview(_ sender: Any) {
        self.mapview.mapType = .standard
//        dropdown(self)
    }
    
    
    
    func stringFromTimeInterval (interval: TimeInterval?) -> [String] {
        let endingDate = Date()
        var timelist = [String]()
        if let timeInterval = interval {
            let startingDate = endingDate.addingTimeInterval(-timeInterval)
            let calendar = Calendar.current
            
            var componentsNow = calendar.dateComponents([.hour, .minute, .second], from: startingDate, to: endingDate)
            if let hour = componentsNow.hour, let minute = componentsNow.minute, let seconds = componentsNow.second {
                if hour > 0{
                    timelist.append("\(hour)")
                }else{
                    timelist.append("")
                }
                
                if minute > 0{
                    timelist.append("\(minute)")
                }else{
                    timelist.append("")
                }

                
                if seconds > 0{
                    timelist.append("\(seconds)")
                }else{
                    timelist.append("00")
                }

                
                return timelist
                
            } else {
                return ["","","00"]
            }
            
        } else {
            return ["","","00"]
        }
    }

    
    
    func popup(title: String, msg: String){
        let alert = UIAlertController(title: title ,message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var chiurchlocation: MKMapView!
    
    @IBAction func churchlocation(_ sender: Any) {
        let destinationppin = customPin(pintTitle: "Word of Faith Covenant Assembly", pinSubTitle: "", location:  CLLocationCoordinate2D(latitude: 4.995467, longitude: 7.892301))
        
//        self.mapview.addAnnotation(sourcepin)
        self.mapview.addAnnotation(destinationppin)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        self.mapview.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 4.995467, longitude: 7.892301), span: span), animated: true)
    }
    
    
}
