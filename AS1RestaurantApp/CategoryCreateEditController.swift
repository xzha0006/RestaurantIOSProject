//
//  CategoryCreateEditController.swift
//  AS1RestaurantApp
//
//  Created by XuanZhang on 1/9/17.
//  Copyright © 2017 Monash. All rights reserved.
//

import UIKit
import CoreData
import Foundation


protocol EditCategoryDelegate {
    func updateCategory()
}
/*
 This controller is used as Create and Edit. I use self.title to represent those two functionalities.
 self.title == "Edit Category" means that it does the Edit functionality, "Create Category" means Create functionality
 */
class CategoryCreateEditController: UIViewController, ChangeColorDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var textCategoryTitle: UITextField!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var imageIcon: UIImageView!
    
    var category: RestaurantCategory?
    var managedObjectContext: NSManagedObjectContext?
    var delegate: EditCategoryDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.title == "Edit Category") {
            self.textCategoryTitle.text = self.category?.title
            self.colorView.backgroundColor = UIColor.color(withData: self.category!.color! as Data)
            self.imageIcon.image = UIImage(data: self.category!.icon! as Data)
        }
        
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
        if (self.title == "Create Category") {
            let category = NSEntityDescription.insertNewObject(forEntityName: "RestaurantCategory", into: self.managedObjectContext!) as? RestaurantCategory
            category!.title = self.textCategoryTitle.text
            category!.color = colorView.backgroundColor!.encode() as NSData
            category!.icon = UIImageJPEGRepresentation(imageIcon.image!, 0.9)! as NSData
            category!.enable = true
            
        }
        
        if (self.title == "Edit Category") {
            category?.title = self.textCategoryTitle.text
            category?.color = colorView.backgroundColor!.encode() as NSData
            //        category!.icon = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_pizza"), 0.9)! as NSData
        }
        //save the result into core data
        self.delegate?.updateCategory()
        _ = navigationController?.popViewController(animated: true)
    }

//    func pickImage(_ sender: Any) {
//        let image = UIImagePickerController()
//        image.delegate = self
//        
//        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        image.allowsEditing = false
//        
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
