//
//  CategoryCreateEditController.swift
//  AS1RestaurantApp
//
//  Created by XuanZhang on 1/9/17.
//  Copyright © 2017 Monash. All rights reserved.
//

import UIKit
import CoreData

/**
    This protocol is used to update the categories in core data and home page
 */
protocol EditCategoryDelegate {
    func updateCategory()
}

/*
 This controller is used as Create and Edit. I use self.title to represent those two functionalities.
 self.title == "Edit Category" means that it does the Edit functionality, "Create Category" means Create functionality
 */
class CategoryCreateEditController: UIViewController, ChangeColorDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var textCategoryTitle: UITextField!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var imageIcon: UIImageView!
    
    var category: RestaurantCategory?
    var managedObjectContext: NSManagedObjectContext?
    var delegate: EditCategoryDelegate?
    var categoryName: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.title == "Edit Category") {
            self.textCategoryTitle.text = self.category?.title
            self.colorView.backgroundColor = UIColor.color(withData: self.category!.color! as Data)
            self.imageIcon.image = UIImage(data: self.category!.icon! as Data)
        }
        
        //dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CategoryCreateEditController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setColor(_ color: UIColor) {
        self.colorView.backgroundColor = color
    }
    
    @IBAction func showColorPicker(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpView") as! PopUpColorPickerController
        popOverVC.defaultColor = colorView.backgroundColor
        popOverVC.delegate = self
        popOverVC.view.frame = self.view.frame
        self.addChildViewController(popOverVC)
        
        
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }

    /*
     pick an image from gallery or camera
     */
    @IBAction func finish(_ sender: Any) {
        if (self.validation()) {
            if (self.title == "Create Category") {
                let newCategory = NSEntityDescription.insertNewObject(forEntityName: "RestaurantCategory", into: self.managedObjectContext!) as? RestaurantCategory
                newCategory!.title = self.textCategoryTitle.text
                newCategory!.color = colorView.backgroundColor!.encode() as NSData
                newCategory!.icon = UIImageJPEGRepresentation(imageIcon.image!, 0.9)! as NSData
                newCategory!.enable = true
                newCategory!.order = Int32(self.categoryName!.count) + 1
                
            }
            
            if (self.title == "Edit Category") {
                self.category?.title = self.textCategoryTitle.text
                self.category?.color = colorView.backgroundColor!.encode() as NSData
                self.category!.icon = UIImageJPEGRepresentation(self.imageIcon.image!, 0.9)! as NSData
            }
            //save the result into core data
            self.delegate?.updateCategory()
            _ = navigationController?.popViewController(animated: true)
            
        }
    }

    //action after picking an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageIcon.image = image
        }
        else {
            showValidationAlert(msg: "Picking Image Failure.")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //cancel image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //pick an image from library or take a photo
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
    
    func validation() -> Bool {
        var result: Bool = true
        var msg: String = ""
        var titleName: String = textCategoryTitle.text!
        
        if (titleName.characters.count > 21) {
            msg = "category title length should be less than 20!"
            result = false;
        }
        else if (titleName.isEmpty)
        {
            msg = "category title cannot be empty!"
            result = false;

        }
        else if (self.title == "Create Category") && (self.categoryName?.contains(titleName))!
        {
            msg = "category \(titleName) already exists!"
            result = false;
        }
        if (!result) {
            self.showValidationAlert(msg: msg)
        }
        
        return result
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
