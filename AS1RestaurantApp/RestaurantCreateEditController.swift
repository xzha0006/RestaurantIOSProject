//
//  RestaurantCreateEditControllerViewController.swift
//  AS1RestaurantApp
//
//  Created by XuanZhang on 4/9/17.
//  Copyright © 2017 Monash. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

protocol EditRestaurantDelegate {
    func updateRestaurant()
}

class RestaurantCreateEditController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FloatRatingViewDelegate {
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    
    @IBOutlet weak var notifiedSwitch: UISwitch!
    var restaurant: Restaurant?
    var restaurantNames: [String]?
    var category: RestaurantCategory?
    var managedObjectContext: NSManagedObjectContext?
    var delegate: EditRestaurantDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initRatingView()
        self.initSwitch()
        self.initSlider()
        
        if (self.title == "Edit Restaurant") {
            self.nameTextField.text = self.restaurant?.name
            self.locationTextField.text = self.restaurant?.location
            self.notifiedSwitch.setOn(self.restaurant!.notified, animated: false)
            self.notificationLabel.text = "Notification \(self.restaurant!.notified ? "On" : "Off")"
            self.ratingView.rating = Float ((self.restaurant?.rating)!)
            self.ratingLabel.text = "Rating: " + (NSString(format: "%.1f", self.ratingView.rating) as String) as String
            self.logoImage.image = UIImage(data: self.restaurant!.logo! as Data)
            self.radiusSlider.value = Float(self.restaurant!.notifiedRadius)
            self.radiusLabel.text = "Radius: \(self.restaurant!.notifiedRadius)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveRestaurant(_ sender: Any) {
        if (self.validation()) {
            if (self.title == "Create Restaurant") {
                let newRestaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: self.managedObjectContext!) as? Restaurant
                newRestaurant?.name = self.nameTextField.text
                newRestaurant?.addedDate = Date() as NSDate
                newRestaurant?.rating = Double (self.ratingView.rating)
                newRestaurant?.notified = self.notifiedSwitch.isOn
                newRestaurant?.notifiedRadius = Double(self.radiusSlider.value)
                newRestaurant?.location = self.locationTextField.text
                newRestaurant?.order = Int32(self.restaurantNames!.count) + 1
                //radius
                let address = self.locationTextField.text!
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(address) { (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                        else {
                            // handle no location found
                            self.showValidationAlert(msg: "Location cannot be found!")
                            return
                    }
                    
                    newRestaurant?.latitude = location.coordinate.latitude
                    newRestaurant?.longitude = location.coordinate.longitude
                }
                
                newRestaurant?.logo = UIImageJPEGRepresentation(self.logoImage.image!, 0.9)! as NSData
                newRestaurant?.category = self.category
                newRestaurant?.enable = true
            }
            
            if (self.title == "Edit Restaurant") {
                self.restaurant?.name = self.nameTextField.text
                self.restaurant?.rating = Double (self.ratingView.rating)

                let address = self.locationTextField.text!
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(address) { (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                        else {
                            // handle no location found
                            self.showValidationAlert(msg: "Location cannot be found!")
                            return
                    }
                    
                    self.restaurant?.latitude = location.coordinate.latitude
                    self.restaurant?.longitude = location.coordinate.longitude
                }
                self.restaurant?.notified = self.notifiedSwitch.isOn
                self.restaurant?.notifiedRadius = Double(self.radiusSlider.value)
                self.restaurant?.location = self.locationTextField.text
                self.restaurant?.logo = UIImageJPEGRepresentation(logoImage.image!, 0.9)! as NSData
            }
            //save the result into core data
            self.delegate?.updateRestaurant()
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    //initialize the rating view
    func initRatingView() {
        self.ratingView.emptyImage = UIImage(named: "StarEmpty")
        self.ratingView.fullImage = UIImage(named: "StarFull")
        
        self.ratingView.delegate = self
        self.ratingView.contentMode = UIViewContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 1
        self.ratingView.rating = 2.5
        self.ratingView.editable = true
        self.ratingView.halfRatings = true
        self.ratingView.floatRatings = false
        
        self.ratingLabel.text = "Rating: " + (NSString(format: "%.1f", self.ratingView.rating) as String) as String
    }
    
    //change rating
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        self.ratingLabel.text = "Rating: " + (NSString(format: "%.1f", self.ratingView.rating) as String) as String
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
        if (!aSwitch.isOn) {
            self.radiusSlider.isEnabled = false
        }
        else{
            self.radiusSlider.isEnabled = true
        }
    }
    
    
    //configure radius slider
    func initSlider() {
        if (self.title == "Edit Restaurant" && !self.restaurant!.notified) {
            radiusSlider.isEnabled = false
        }
        else{
            radiusSlider.isEnabled = true
        }
        radiusSlider.minimumValue = 0
        radiusSlider.maximumValue = 2000
        radiusSlider.value = 500
        radiusSlider.isContinuous = true
        self.radiusLabel.text = "Radius: \(radiusSlider.value)"
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
    }

    
    //after picking an image, dismiss the imagePickerView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.logoImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //pick image button onCLick action
    @IBAction func pickImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Image Source", message: "Select a source", preferredStyle: .actionSheet)
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            actionSheet.addAction(UIAlertAction(title: "Take A Photo", style: .default, handler: {(action: UIAlertAction) in
                imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
                imagePickerController.allowsEditing = false
                self.present(imagePickerController, animated: true)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
    /// Show an alert with error message.
    func showValidationAlert(msg: String?) {
        let title = NSLocalizedString("Input Error", comment: "")
        let message = NSLocalizedString(msg!, comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the action.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { action in
            NSLog("Validation error occured.")
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //
    func validation() -> Bool {
        var result: Bool = true
        var msg: String = ""
        var restaurantName: String = nameTextField.text!
        var location: String = locationTextField.text!
        
        if (restaurantName.characters.count > 21) {
            msg = "restaurant name length should be less than 20!"
            result = false;
        }
        else if (location.characters.count > 101)
        {
            msg = "location length should be less than 100!"
            result = false;
        }
        else if (restaurantName.isEmpty || location.isEmpty)
        {
            msg = "restaurant name or location cannot be empty!"
            result = false;
            
        }
        else if (self.title == "Create Restaurant") && (self.restaurantNames?.contains(restaurantName))!
        {
            msg = "restaurant \(restaurantName) already exists in category \(self.category!.title ?? "")!"
            result = false;
        }
        if (!result) {
            self.showValidationAlert(msg: msg)
        }
        
        return result
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
