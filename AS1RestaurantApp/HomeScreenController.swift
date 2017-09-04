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
        let fetchRequestCategory = NSFetchRequest<NSManagedObject>(entityName: "RestaurantCategory")
//        fetchRequestCategory.predicate = NSPredicate(format: "enable == %@", NSNumber(value: true))
        let fetchRequestRestaurant = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
//        fetchRequestRestaurant.predicate = NSPredicate(format: "enable == %@", NSNumber(value: true))
        
        do {
//            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RestaurantCategory")
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
//            
//            try self.managedObjectContext.execute(deleteRequest)
//            try self.managedObjectContext.save()
            
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
        
        var restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Pizza1"
        restaurant!.rating = 5
        restaurant!.latitude = -37
        restaurant!.longitude = 145
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_pizza"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        
        category!.addToRestaurants(restaurant!)
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Pizza2"
        restaurant!.rating = 5
        restaurant!.latitude = -37
        restaurant!.longitude = 147
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_pizza"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        
        category!.addToRestaurants(restaurant!)
        
        category = NSEntityDescription.insertNewObject(forEntityName: "RestaurantCategory", into: managedObjectContext) as? RestaurantCategory
        category!.title = "Burger"
        category!.color = UIColor.blue.encode() as NSData
        category!.icon = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_burger"), 0.9)! as NSData
        category!.enable = true
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Pizza1"
        restaurant!.rating = 5
        restaurant!.latitude = -37
        restaurant!.longitude = 145
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_pizza"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        
        category!.addToRestaurants(restaurant!)
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Pizza2"
        restaurant!.rating = 5
        restaurant!.latitude = -37
        restaurant!.longitude = 147
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_pizza"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        
        category!.addToRestaurants(restaurant!)
        
        category = NSEntityDescription.insertNewObject(forEntityName: "RestaurantCategory", into: managedObjectContext) as? RestaurantCategory
        category!.title = "Ramen"
        category!.color = UIColor.red.encode() as NSData
        category!.icon = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_ramen"), 0.9)! as NSData
        category!.enable = true
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Pizza5"
        restaurant!.rating = 5
        restaurant!.latitude = -36
        restaurant!.longitude = 145
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_pizza"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        
        category!.addToRestaurants(restaurant!)
        
        restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        restaurant!.name = "Pizza6"
        restaurant!.rating = 5
        restaurant!.latitude = -35
        restaurant!.longitude = 147
        restaurant!.logo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "category_pizza"), 0.9)! as NSData
        restaurant!.enable = true
        restaurant!.addedDate = Date() as NSDate
        
        category!.addToRestaurants(restaurant!)
        
        saveRecords()
        
        
    }
   
    
    func saveRecords() {
        do {
            try self.managedObjectContext.save()
            let fetchRequestCategory = NSFetchRequest<NSManagedObject>(entityName: "RestaurantCategory")
            fetchRequestCategory.predicate = NSPredicate(format: "enable == %@", NSNumber(value: true))
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
    
    //delegate function to update home page
    func updateCategory() {
        saveRecords()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = self.categories[indexPath.row] as! RestaurantCategory
        
        cell.titleLabel.text = category.title
        cell.titleLabel.textColor = UIColor.color(withData: category.color! as Data)
        cell.iconImageView.image = UIImage(data: category.icon! as Data)
     
        return cell
     }
    
    @IBAction func createCategory(_ sender: Any) {
        self.performSegue(withIdentifier: "EditCategorySegue", sender: "create");
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{action, indexpath in
            print("EDIT•ACTION")
            self.performSegue(withIdentifier: "EditCategorySegue", sender: indexPath.row)
        });
        editRowAction.backgroundColor = UIColor.orange;
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            print("DELETE•ACTION")
            let category = self.categories[indexPath.row] as! RestaurantCategory
            category.enable = false
            for item in category.restaurants! {
                let restaurant = item as! Restaurant
                restaurant.enable = false
            }
            self.updateCategory()
        });
        
        return [deleteRowAction, editRowAction];
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditCategorySegue" {
            let controller: CategoryCreateEditController = segue.destination as! CategoryCreateEditController
            if ((sender as? Int) != nil) {
                let index = sender as! Int
                let category = categories[index] as! RestaurantCategory
                controller.title = "Edit Category"
                controller.category = category
                controller.managedObjectContext = self.managedObjectContext
                controller.delegate = self
            }
            else if sender as? String == "create" {
                controller.title = "Create Category"
                controller.managedObjectContext = self.managedObjectContext
                controller.delegate = self

//                let controller = segue.destination as! CategoryCreateEditController
//                controller.itemString = sender as? String
            }
            
        }
        if segue.identifier == "ShowRestaurantsSegue" {
            let controller: SingleCategoryScreenController = segue.destination as! SingleCategoryScreenController
            let fromCategory = sender as? RestaurantCategory
            controller.category = fromCategory
            
        }
        
        
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
 

}

extension UIColor {
    class func color(withData data:Data) -> UIColor {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! UIColor
    }
    
    func encode() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}

