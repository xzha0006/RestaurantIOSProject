//
//  RestaurantDetailController.swift
//  AS1RestaurantApp
//
//  Created by XuanZhang on 5/9/17.
//  Copyright © 2017 Monash. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var notifiedSwitch: UISwitch!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    var restaurant: Restaurant?
    var delegate: EditRestaurantDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.initMapView()
        self.initRatingView()
        self.initSlider()
        self.initSwitch()
        
        self.logoImage.image = UIImage(data: self.restaurant!.logo! as Data)
        self.nameLabel.text = "Name: \(self.restaurant!.name ?? "")"
        self.locationLabel.text = "Location: \(self.restaurant!.location ?? "")"
        self.categoryLabel.text = "Category: \(self.restaurant!.category?.title ?? "")"
        
        self.ratingLabel.text = "Rating: " + (NSString(format: "%.1f", self.ratingView.rating) as String) as String
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd"
        let addDate = formatter.string(from: self.restaurant!.addedDate! as Date)
        self.dateLabel.text = "Added Date: \(addDate)"
        
        self.notifiedSwitch.setOn(self.restaurant!.notified, animated: false)
        self.notificationLabel.text = "Notification \(self.restaurant!.notified ? "On" : "Off")"
        self.radiusLabel.text = "Radius: \(self.restaurant!.notifiedRadius) m"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //initilize rating star view
    func initRatingView() {
        self.ratingView.emptyImage = UIImage(named: "StarEmpty")
        self.ratingView.fullImage = UIImage(named: "StarFull")
        
        self.ratingView.contentMode = UIViewContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 1
        self.ratingView.rating = Float(self.restaurant!.rating)
        self.ratingView.editable = false
        self.ratingView.halfRatings = true
        self.ratingView.floatRatings = false
        
    }
    
    //initialize map view
    func initMapView() {
        self.mapView.showsScale = true
        self.mapView.mapType = .standard
        self.mapView.delegate = self
        
        let center = CLLocationCoordinate2D(latitude: restaurant!.latitude, longitude: restaurant!.longitude)
        let region = MKCoordinateRegionMakeWithDistance(center, restaurant!.notifiedRadius * 4, restaurant!.notifiedRadius * 4)
        
        self.mapView.setRegion(region, animated: true)
        
        let logo = UIImage(data: self.restaurant!.logo! as Data)
        let content: String = "\(restaurant!.location ?? "")"
        addAnnotation(self.restaurant!.name, content, center, logo)
        
        if (self.restaurant!.notified) {
            self.showCircle(coordinate: center, radius: restaurant!.notifiedRadius)
        }
        
    }
    
    //draw a circle for restaurant auto notification range
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate, radius: radius)
        self.mapView.add(circle)
        let region = MKCoordinateRegionMakeWithDistance(coordinate, radius * 4, radius * 4)
        self.mapView.setRegion(region, animated: true)
    }
    
    //adding an annotation on the map
    func addAnnotation(_ title: String?,_ subtitle: String?,_ coordinate: CLLocationCoordinate2D?, _ logo: UIImage?) {
        let annotation = RestaurantAnnotation()
        annotation.title = title
        annotation.coordinate = coordinate!
        annotation.subtitle = subtitle
        annotation.logo = logo
        
        self.mapView.addAnnotation(annotation)
        
    }
    
    /*
     custom the annotation.
     adding a logo image
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is RestaurantAnnotation {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            annotationView.canShowCallout = true
            
            let restaurantAnnotation = annotation as! RestaurantAnnotation
            
            let deleteButton = UIButton(type: UIButtonType.custom)
            deleteButton.frame.size.width = 45
            deleteButton.frame.size.height = 45
            deleteButton.setImage(restaurantAnnotation.logo, for: .normal)
            
            annotationView.leftCalloutAccessoryView = deleteButton
            
            return annotationView
        }
        
        return nil
    }
    
    //draw overlay circle
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // If you want to include other shapes, then this check is needed. If you only want circles, then remove it.
        let circleOverlay = overlay as? MKCircle
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay!)
        circleRenderer.fillColor = UIColor.purple
        circleRenderer.alpha = 0.1
        
        return circleRenderer
    }
    
    //init switch
    func initSwitch() {
        self.notifiedSwitch.setOn(false, animated: false)
        self.notificationLabel.text = "Notification Off"
        self.notifiedSwitch.addTarget(self, action: #selector(RestaurantCreateEditController.switchValueDidChange(_:)), for: .valueChanged)
    }
    
    //switch action
    func switchValueDidChange(_ aSwitch: UISwitch) {
        let onOrOff: String = self.notifiedSwitch.isOn ? "On" : "Off"
        self.notificationLabel.text = "Notification " + onOrOff
        
        self.restaurant!.notified = aSwitch.isOn
        
        if (aSwitch.isOn) {
            let center = CLLocationCoordinate2D(latitude: restaurant!.latitude, longitude: restaurant!.longitude)
            showCircle(coordinate: center, radius: CLLocationDistance(self.restaurant!.notifiedRadius))
            self.radiusSlider.isEnabled = true
        } else {
            self.mapView.remove(self.mapView.overlays[0])
            self.radiusSlider.isEnabled = false
        }
        
        self.delegate?.updateRestaurant()
    }
    
    
    //configure radius slider
    func initSlider() {
        if (!self.restaurant!.notified) {
            radiusSlider.isEnabled = false
        }
        else{
            radiusSlider.isEnabled = true
        }
        radiusSlider.minimumValue = 0
        radiusSlider.maximumValue = 2000
        radiusSlider.value = Float (self.restaurant!.notifiedRadius)
        radiusSlider.isContinuous = true
        //        self.radiusLabel.text = "Radius: \(radiusSlider.value)"
        radiusSlider.addTarget(self, action: #selector(RestaurantCreateEditController.sliderValueDidChange(_:)), for: .valueChanged)
    }
    
    //when slider value has been changed, this function will run
    func sliderValueDidChange(_ slider: UISlider) {
        let radiusRange1: Float = 50
        let radiusRange2: Float = 250
        let radiusRange3: Float = 500
        let radiusRange4: Float = 1000
        let radiusRange5: Float = 2000
        
        //set the slider to discrete points.
        
        if slider.value <= (100) {
            slider.value = radiusRange1
            self.radiusLabel.text = "Radius: \(slider.value) m"
        }
        else if slider.value <= (400) {
            slider.value = radiusRange2
            self.radiusLabel.text = "Radius: \(slider.value) m"
        }
        else if slider.value <= (750) {
            slider.value = radiusRange3
            self.radiusLabel.text = "Radius: \(slider.value) m"
        }
        else if slider.value <= (1200) {
            slider.value = radiusRange4
            self.radiusLabel.text = "Radius: \(slider.value) m"
        }
        else {
            slider.value = radiusRange5
            self.radiusLabel.text = "Radius: \(slider.value) m"
        }
        
        self.restaurant!.notifiedRadius = Double(slider.value)
        
        //remove the circle 
        self.mapView.remove(self.mapView.overlays[0])
        
        //create a new circle around the user
        let center = CLLocationCoordinate2D(latitude: restaurant!.latitude, longitude: restaurant!.longitude)
        showCircle(coordinate: center, radius: CLLocationDistance(self.restaurant!.notifiedRadius))
        
        self.delegate?.updateRestaurant()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
