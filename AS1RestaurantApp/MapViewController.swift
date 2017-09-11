//
//  MapViewController.swift
//  AS1RestaurantApp
//
//  Created by XuanZhang on 5/9/17.
//  Copyright © 2017 Monash. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, EditRestaurantDelegate {
    
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: -37, longitude: 145)
    var restaurants: [NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext
    var restaurantDisplayRadius: Float = 500
    
    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        fetchRestaurants()
        showCircle(coordinate: self.currentLocation!, radius: CLLocationDistance(self.restaurantDisplayRadius))
        self.drawAnnotation()
        initSlider()
        
        self.radiusLabel.text = "Restaurants In Radius: \(self.restaurantDisplayRadius) m"
        self.mapView.userTrackingMode = .follow
        self.mapView.showsUserLocation = true
        self.mapView.showsScale = true
        self.mapView.mapType = .standard
        self.mapView.delegate = self
        
        
        
        
    }
    
    //do something when user's current location is changed
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        currentLocation = location.coordinate
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegionMakeWithDistance(center, Double(self.restaurantDisplayRadius) * 4, Double(self.restaurantDisplayRadius) * 4)
        
        self.mapView.setRegion(region, animated: true)
    }
    
    //region enter monitoring
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let alert = UIAlertController(title: "Restaurant Pop Up!", message: "You are entering \(region.identifier)'s region", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //draw annotations and circles, and start to monitor certain regions
    func drawAnnotation() {
        var i = 0
        for item in self.restaurants {
            let restaurant = item as! Restaurant
            let location = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            let restaurantCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let userCLLocation = CLLocation(latitude: self.currentLocation!.latitude, longitude: self.currentLocation!.longitude)
            
            let distance = userCLLocation.distance(from: restaurantCLLocation)
            if (Float(distance) < self.restaurantDisplayRadius)
            {
                let logo = UIImage(data: restaurant.logo! as Data)
                let content: String = "\(restaurant.location ?? "")"
                addAnnotation(restaurant.name, content, location, logo, i)
                if restaurant.notified == true {
                    showCircle(coordinate: location, radius: restaurant.notifiedRadius)
                    //start monitoring
                    let geoLocation = CLCircularRegion(center: location, radius: restaurant.notifiedRadius, identifier: restaurant.name!)
                    geoLocation.notifyOnEntry = true
                    self.locationManager.startMonitoring(for: geoLocation)
                }
            }
            i += 1
        }
    }
    
    //adding an annotation on the map
    func addAnnotation(_ title: String?,_ subtitle: String?,_ coordinate: CLLocationCoordinate2D?, _ logo: UIImage?, _ index: Int?) {
        let annotation = RestaurantAnnotation()
        annotation.title = title
        annotation.coordinate = coordinate!
        annotation.subtitle = subtitle
        annotation.logo = logo
        annotation.index = index
        self.mapView.addAnnotation(annotation)
    }
    
    //fetch restaurants from core data
    func fetchRestaurants() {
        let fetchRequestRestaurant = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
        fetchRequestRestaurant.predicate = NSPredicate(format: "enable == %@", NSNumber(value: true))
        do {
            self.restaurants = try self.managedObjectContext.fetch(fetchRequestRestaurant)
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    //configure radius slider
    func initSlider() {
        radiusSlider.minimumValue = 0
        radiusSlider.maximumValue = 2000
        radiusSlider.value = 500
        radiusSlider.isContinuous = true
        
        radiusSlider.addTarget(self, action: #selector(MapViewController.sliderValueDidChange(_:)), for: .valueChanged)
    }
    
    //when slider value has been changed, this function will run
    func sliderValueDidChange(_ slider: UISlider) {
        let radiusRange1: Float = 50
        let radiusRange2: Float = 250
        let radiusRange3: Float = 500
        let radiusRange4: Float = 1000
        let radiusRange5: Float = 2000
        
        if slider.value <= (radiusRange1 + 100) {
            slider.value = radiusRange1
            self.restaurantDisplayRadius = radiusRange1
        }
        else if slider.value <= (radiusRange2 + 100) {
            slider.value = radiusRange2
            self.restaurantDisplayRadius = radiusRange2
        }
        else if slider.value <= (radiusRange3 + 250) {
            slider.value = radiusRange3
            self.restaurantDisplayRadius = radiusRange3
        }
        else if slider.value <= (radiusRange4 + 300) {
            slider.value = radiusRange4
            self.restaurantDisplayRadius = radiusRange4;
        }
        else {
            slider.value = radiusRange5
            self.restaurantDisplayRadius = radiusRange5;
        }
        
        self.radiusLabel.text = "Restaurants In Radius: \(self.restaurantDisplayRadius) m"
        
        //remove the circle around user
        self.mapView.overlays.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.remove($0)
            }
        }
        
        //create a new circle around the user
        showCircle(coordinate: self.currentLocation!, radius: CLLocationDistance(self.restaurantDisplayRadius))
        
        let region = MKCoordinateRegionMakeWithDistance(self.currentLocation!, Double(self.restaurantDisplayRadius) * 4, Double(self.restaurantDisplayRadius) * 4)
        
        self.mapView.setRegion(region, animated: true)
        
        //remove and draw annotations
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.locationManager.monitoredRegions.forEach{
            locationManager.stopMonitoring(for: $0)
        }
        
        self.drawAnnotation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //every time this view appears, reload the annotations
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchRestaurants()
        
        let region = MKCoordinateRegionMakeWithDistance(self.currentLocation!, Double(self.restaurantDisplayRadius) * 4, Double(self.restaurantDisplayRadius) * 4)
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.removeOverlays(self.mapView.overlays)
        self.locationManager.monitoredRegions.forEach{
            locationManager.stopMonitoring(for: $0)
        }
        
        showCircle(coordinate: self.currentLocation!, radius: CLLocationDistance(self.restaurantDisplayRadius))
        self.drawAnnotation()
    }
    
    //draw a circle for restaurant auto notification range
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate, radius: radius)
        mapView.add(circle)
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
        
            let logoButton = UIButton(type: UIButtonType.custom)
            logoButton.frame.size.width = 45
            logoButton.frame.size.height = 45
            logoButton.setImage(restaurantAnnotation.logo, for: .normal)
        
            annotationView.leftCalloutAccessoryView = logoButton
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = btn
        
            return annotationView
        }
        
        return nil
    }
    
    //draw overlay circle
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleOverlay = overlay as? MKCircle
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay!)
        
        let currentCLLocation = CLLocation(latitude: self.currentLocation!.latitude, longitude: self.currentLocation!.longitude)
        
        let overlayCLLocation = CLLocation(latitude: circleOverlay!.coordinate.latitude, longitude: circleOverlay!.coordinate.longitude)
        //compare the overlay center and user location
        if (currentCLLocation.distance(from: overlayCLLocation) < 3) {
            circleRenderer.lineWidth = 2
            circleRenderer.strokeColor = UIColor.blue
        }
        else
        {
            circleRenderer.fillColor = UIColor.purple
            circleRenderer.alpha = 0.1
            
        }
        
        return circleRenderer
    }
    
    //tap annotation then jump to detail view
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            self.performSegue(withIdentifier: "MapToDetailSegue", sender: view)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapToDetailSegue" {
            let annotationView = sender as! MKAnnotationView
            let annotation = annotationView.annotation as! RestaurantAnnotation
            let controller: RestaurantDetailController = segue.destination as! RestaurantDetailController
            let restaurant = self.restaurants[annotation.index] as! Restaurant
            
            controller.restaurant = restaurant
            controller.title = restaurant.name
            controller.delegate = self
        }
    }
    
    //save data and reload the map
    func updateRestaurant() {
        saveRecords()
//        let region = MKCoordinateRegionMakeWithDistance(self.currentLocation!, Double(self.restaurantDisplayRadius) * 4, Double(self.restaurantDisplayRadius) * 4)
//        
//        self.mapView.setRegion(region, animated: true)
//        self.mapView.removeAnnotations(self.mapView.annotations)
//        self.mapView.removeOverlays(self.mapView.overlays)
//        self.locationManager.monitoredRegions.forEach{
//            locationManager.stopMonitoring(for: $0)
//        }
//        showCircle(coordinate: self.currentLocation!, radius: CLLocationDistance(self.restaurantDisplayRadius))
//        self.drawAnnotation()
    }
    
    //save data into core data
    func saveRecords() {
        do {
            try self.managedObjectContext.save()
            let fetchRequestRestaurant = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
            fetchRequestRestaurant.predicate = NSPredicate(format: "enable == %@", NSNumber(value: true))
            
            do {
                self.restaurants = try self.managedObjectContext.fetch(fetchRequestRestaurant)
            }
            catch {
                let fetchError = error as NSError
                print(fetchError)
            }
            
        }
        catch let error {
            print("Could not save: \(error)")
        }
    }


}
