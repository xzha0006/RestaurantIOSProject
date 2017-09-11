//
//  HomeScreenController
//  AS1RestaurantApp
//  This is the home screen controller
//  Created by XuanZhang on 27/8/17.
//  Copyright © 2017 Monash. All rights reserved.
//

import UIKit
import CoreData
import Foundation

//This is the home page controller
class HomeScreenController: UITableViewController, EditCategoryDelegate {
    var categories: [NSManagedObject] = []
    var restaurants: [NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext
    
    
    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetch the valid data where enable == true
        let fetchRequestCategory = NSFetchRequest<NSManagedObject>(entityName: "RestaurantCategory")
        fetchRequestCategory.predicate = NSPredicate(format: "enable == %@", NSNumber(value: true))
        let sortIndex = NSSortDescriptor(key: "order", ascending: true)
        fetchRequestCategory.sortDescriptors = [sortIndex]
        
        let fetchRequestRestaurant = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
        fetchRequestRestaurant.predicate = NSPredicate(format: "enable == %@", NSNumber(value: true))
        
        do {
            self.categories = try self.managedObjectContext.fetch(fetchRequestCategory)
            self.restaurants = try self.managedObjectContext.fetch(fetchRequestRestaurant)

//            delete
//            for item in self.categories {
//                managedObjectContext.delete(item)
//            }
//            
//            for item in self.restaurants {
//                managedObjectContext.delete(item)
//            }
//            
//            saveRecords()
            
            if self.categories.count == 0
            {
                addInitialCategoryData()
            }
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //create category data
    func addInitialCategoryData() {
        var category = NSEntityDescription.insertNewObject(forEntityName: "RestaurantCategory", into: managedObjectContext) as? RestaurantCategory
        category!.title = "Pizza"
        category!.color = UIColor.green.encode() as NSData
        category!.icon = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_pizza"), 0.9)! as NSData
        category!.enable = true
        category!.order = 1
        
        var restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Pizza Papa"
        restaurant!.rating = 5
        restaurant!.latitude = -37
        restaurant!.longitude = 145
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_pizza"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        restaurant!.notified = true
        restaurant!.notifiedRadius = 1000
        restaurant!.location = "200 Collins St, Melbourne"
        restaurant!.order = 1
        
        category!.addToRestaurants(restaurant!)
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Pizza Mama"
        restaurant!.rating = 5
        restaurant!.latitude = -37
        restaurant!.longitude = 147
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_pizza"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        restaurant!.notified = true
        restaurant!.notifiedRadius = 1000
        restaurant!.location = "300 Collins St, Melbourne"
        restaurant!.order = 2
        
        category!.addToRestaurants(restaurant!)
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Pizza Boy"
        restaurant!.rating = 3.5
        restaurant!.latitude = -37
        restaurant!.longitude = 146.5
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_pizza"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        restaurant!.notified = true
        restaurant!.notifiedRadius = 1000
        restaurant!.location = "400 Collins St, Melbourne"
        restaurant!.order = 3
        
        category!.addToRestaurants(restaurant!)
        
        category = NSEntityDescription.insertNewObject(forEntityName: "RestaurantCategory", into: managedObjectContext) as? RestaurantCategory
        category!.title = "Burger"
        category!.color = UIColor.blue.encode() as NSData
        category!.icon = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_burger"), 0.9)! as NSData
        category!.enable = true
        category!.order = 2
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Burger Papa"
        restaurant!.rating = 5
        restaurant!.latitude = -37
        restaurant!.longitude = 143
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_burger"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        restaurant!.notified = true
        restaurant!.notifiedRadius = 1000
        restaurant!.location = "100 Lygon St, Melbourne"
        restaurant!.order = 1
        
        category!.addToRestaurants(restaurant!)
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Burger Mama"
        restaurant!.rating = 5
        restaurant!.latitude = -37
        restaurant!.longitude = 148
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_burger"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        restaurant!.notified = true
        restaurant!.notifiedRadius = 1000
        restaurant!.location = "200 Lygon St, Melbourne"
        restaurant!.order = 2
        
        category!.addToRestaurants(restaurant!)
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Burger Boy"
        restaurant!.rating = 5
        restaurant!.latitude = -35.5
        restaurant!.longitude = 147.5
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_burger"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        restaurant!.notified = true
        restaurant!.notifiedRadius = 1000
        restaurant!.location = "300 Lygon St, Melbourne"
        restaurant!.order = 3
        
        category!.addToRestaurants(restaurant!)
        
        category = NSEntityDescription.insertNewObject(forEntityName: "RestaurantCategory", into: managedObjectContext) as? RestaurantCategory
        category!.title = "Ramen"
        category!.color = UIColor.red.encode() as NSData
        category!.icon = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_ramen"), 0.9)! as NSData
        category!.enable = true
        category!.order = 3
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Ramen Papa"
        restaurant!.rating = 5
        restaurant!.latitude = -36
        restaurant!.longitude = 145
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_ramen"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        restaurant!.notified = true
        restaurant!.notifiedRadius = 1000
        restaurant!.location = "300 Swanston St, Melbourne"
        restaurant!.order = 1
        
        category!.addToRestaurants(restaurant!)
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Ramen Mama"
        restaurant!.rating = 5
        restaurant!.latitude = -35
        restaurant!.longitude = 147
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_ramen"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        restaurant!.notified = true
        restaurant!.notifiedRadius = 1000
        restaurant!.location = "400 Swanston St, Melbourne"
        restaurant!.order = 2
        
        category!.addToRestaurants(restaurant!)
        
        category!.addToRestaurants(restaurant!)
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Ramen Boy"
        restaurant!.rating = 5
        restaurant!.latitude = -35
        restaurant!.longitude = 147.5
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_ramen"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        restaurant!.notified = true
        restaurant!.notifiedRadius = 1000
        restaurant!.location = "500 Swanston St, Melbourne"
        restaurant!.order = 3
        
        saveRecords()
        
        
    }
    
    /**
        delegate function to save core data, update categories, restaurants and reload the table view
     */
    func updateCategory() {
        saveRecords()
        self.tableView.reloadData()
    }
    
    /**
        save data
    */
    func saveRecords() {
        do {
            try self.managedObjectContext.save()
            let fetchRequestCategory = NSFetchRequest<NSManagedObject>(entityName: "RestaurantCategory")
            fetchRequestCategory.predicate = NSPredicate(format: "enable == %@", NSNumber(value: true))
            let sortIndex = NSSortDescriptor(key: "order", ascending: true)
            fetchRequestCategory.sortDescriptors = [sortIndex]
            
            let fetchRequestRestaurant = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
            fetchRequestRestaurant.predicate = NSPredicate(format: "enable == %@", NSNumber(value: true))
            
            do {
                self.categories = try self.managedObjectContext.fetch(fetchRequestCategory)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tableview number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //tableview number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categories.count
    }
    
    //tableview initialize cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = self.categories[indexPath.row] as! RestaurantCategory
        
        cell.titleLabel.text = category.title
        cell.titleLabel.textColor = UIColor.color(withData: category.color! as Data)
        cell.iconImageView.image = UIImage(data: category.icon! as Data)
        cell.row = indexPath.row
     
        return cell
     }
    
    /**
        This is the create button action. It jumps to segue "CreateEditCategorySegue".
     */
    @IBAction func createCategory(_ sender: Any) {
        self.performSegue(withIdentifier: "CreateEditCategorySegue", sender: "create");
    }

    //set the table to editable mode
    @IBAction func sortButtonAction(_ sender: Any) {
        self.setEditing(!self.isEditing, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedCategory = self.categories[sourceIndexPath.row]
        self.categories.remove(at: sourceIndexPath.row)
        self.categories.insert(movedCategory, at: destinationIndexPath.row)
        
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row)")

        //rewrite the order
        var i = 1
        for item in self.categories {
            item.setValue(i, forKey: "order")
            i += 1
        }
        
        self.updateCategory()
    }

    
    /**
        This function is used to set the swipe action. When user swipes a cell, two option buttons appears: delete and edit
    */
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{action, indexpath in
            print("EDIT•ACTION")
            self.performSegue(withIdentifier: "CreateEditCategorySegue", sender: indexPath.row)
        });
        editRowAction.backgroundColor = UIColor.orange;
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            print("DELETE•ACTION")
            self.showYesNoAlert(row: indexPath.row)
        });
        
        return [deleteRowAction, editRowAction];
    }
    
    // Show an alert with an "YES" and "NO" button.
    func showYesNoAlert(row: Int?) {
        let category = self.categories[row!] as! RestaurantCategory
        
        let title = NSLocalizedString("Delete category \(category.title!)", comment: "")
        let message = NSLocalizedString("Are you sure you want to delete all the restaurants under \(category.title!) category?", comment: "")
        let noButtonTitle = NSLocalizedString("NO", comment: "")
        let yesButtonTitle = NSLocalizedString("YES", comment: "")
        
        let alertCotroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the actions.
        let noAction = UIAlertAction(title: noButtonTitle, style: .cancel) { _ in
        }
        
        let yesAction = UIAlertAction(title: yesButtonTitle, style: .default) { _ in
            
            category.enable = false
            for item in category.restaurants! {
                let restaurant = item as! Restaurant
                restaurant.enable = false
            }
            self.updateCategory()
        }
        
        // Add the actions.
        alertCotroller.addAction(yesAction)
        alertCotroller.addAction(noAction)
        
        present(alertCotroller, animated: true, completion: nil)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateEditCategorySegue" {
            let controller: CategoryCreateEditController = segue.destination as! CategoryCreateEditController
            controller.delegate = self
            controller.managedObjectContext = self.managedObjectContext
            //send category names to controller
            controller.categoryName = self.categories.map({
                (item: NSManagedObject) -> String in
                let category = item as! RestaurantCategory
                return category.title!
            })
            
            if ((sender as? Int) != nil) {
                let index = sender as! Int
                let category = categories[index] as! RestaurantCategory
                controller.title = "Edit Category"
                controller.category = category
            }
            else if sender as? String == "create" {
                controller.title = "Create Category"
            }
        }
        
        if segue.identifier == "ShowRestaurantsSegue" {
            let controller: SingleCategoryScreenController = segue.destination as! SingleCategoryScreenController
            let categoryCell = sender as! CategoryCell
            let category = categories[categoryCell.row] as? RestaurantCategory
            controller.category = category
            controller.title = category?.title
            controller.managedObjectContext = self.managedObjectContext
        }
     }
    
    

}

//This method converts UIColor to Data and reverses. Citing from stackoverflow.
extension UIColor {
    class func color(withData data:Data) -> UIColor {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! UIColor
    }
    
    func encode() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}

