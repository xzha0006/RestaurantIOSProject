//
//  SingleRestaurantScreenController.swift
//  AS1RestaurantApp
//
//  Created by XuanZhang on 4/9/17.
//  Copyright © 2017 Monash. All rights reserved.
//

import UIKit
import CoreData


class SingleCategoryScreenController: UITableViewController, EditRestaurantDelegate {
    
    var category: RestaurantCategory?
    var managedObjectContext: NSManagedObjectContext?
    var restaurants : [NSManagedObject] = []
    var isAscending: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequestRestaurant = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
        fetchRequestRestaurant.predicate = NSPredicate(format: "enable == %@ && category == %@", NSNumber(value: true), category!)
        let sortIndex = NSSortDescriptor(key: "order", ascending: true)
        fetchRequestRestaurant.sortDescriptors = [sortIndex]
        
        do {
            self.restaurants = try self.managedObjectContext!.fetch(fetchRequestRestaurant)
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        
        let restaurant = self.restaurants[indexPath.row] as! Restaurant
        cell.row = indexPath.row
        cell.nameLabel.text = restaurant.name
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd"
        let addDate = formatter.string(from: restaurant.addedDate! as Date)
        cell.dateLabel.text = "Added Date: \(addDate)"
        cell.logoImageView.image = UIImage(data: restaurant.logo! as Data)
        cell.locationLabel.text = restaurant.location
        
        cell.ratingView.emptyImage = UIImage(named: "StarEmpty")
        cell.ratingView.fullImage = UIImage(named: "StarFull")
        
        cell.ratingView.contentMode = UIViewContentMode.scaleAspectFit
        cell.ratingView.maxRating = 5
        cell.ratingView.minRating = 1
        cell.ratingView.rating = Float(restaurant.rating)
        cell.ratingView.editable = false
        cell.ratingView.halfRatings = true
        cell.ratingView.floatRatings = false
        
        cell.ratingLabel.text = "Rating: " + (NSString(format: "%.1f", cell.ratingView.rating) as String) as String
        
        return cell
    }
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.restaurants.count
    }
    
    /**
     This function is used to set the swipe action. When user swipes a cell, two option buttons appears: delete and edit
     */
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            print("DELETE RESTAURANT•ACTION")
            self.showYesNoAlert(row: indexPath.row)
        });
        
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{action, indexpath in
            print("EDIT•ACTION")
            self.performSegue(withIdentifier: "CreateEditRestaurantSegue", sender: indexPath.row)
        });
        editRowAction.backgroundColor = UIColor.orange;
        
        return [deleteRowAction, editRowAction];
    }
    
    //moving table rows to reorder
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedRestaurant = self.restaurants[sourceIndexPath.row]
        self.restaurants.remove(at: sourceIndexPath.row)
        self.restaurants.insert(movedRestaurant, at: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row)")
        
        self.reorderTable()
    }

    //save data and reload table
    func updateRestaurant() {
        saveRecords()
        self.tableView.reloadData()
    }
    
    //save data into core data
    func saveRecords() {
        do {
            try self.managedObjectContext!.save()
            let fetchRequestRestaurant = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
            fetchRequestRestaurant.predicate = NSPredicate(format: "enable == %@ && category == %@", NSNumber(value: true), category!)
            let sortIndex = NSSortDescriptor(key: "order", ascending: true)
            fetchRequestRestaurant.sortDescriptors = [sortIndex]
            
            do {
                self.restaurants = try self.managedObjectContext!.fetch(fetchRequestRestaurant)
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
    
    /**
     This is the create button action. It jumps to segue "CreateEditRestaurantSegue".
     */
    @IBAction func createRestaurant(_ sender: Any) {
        self.performSegue(withIdentifier: "CreateEditRestaurantSegue", sender: "create");

    }

    /**
        action after clicking sort button, present an action sheet with some options
        If you choose the same option twice, order wil reverse
     */
    @IBAction func sortButtonAction(_ sender: Any) {
        if (self.isEditing) {
            self.setEditing(!self.isEditing, animated: true)
        }
        else{
            //choose ascending or deascending based on self.isAcending
            let orderedWay = self.isAscending ? ComparisonResult.orderedAscending : ComparisonResult.orderedDescending
            
            let actionSheet = UIAlertController(title: "Sorting Options", message: "Select an option", preferredStyle: .actionSheet)
            
            //sort by name
            actionSheet.addAction(UIAlertAction(title: "By Name", style: .default, handler: {(action: UIAlertAction) in
                self.restaurants.sort(by: {($0.value(forKey: "name") as! String).compare($1.value(forKey: "name") as! String) == orderedWay})
                self.isAscending = !self.isAscending
                self.reorderTable()
            }))
            
            //sort by rating deascending
            actionSheet.addAction(UIAlertAction(title: "By Rating", style: .default, handler: {(action: UIAlertAction) in
                self.restaurants.sort(by: {($0.value(forKey: "rating") as! Double) > ($1.value(forKey: "rating") as! Double)})
                if (self.isAscending) {
                    self.restaurants.reverse()
                }
                self.isAscending = !self.isAscending
                self.reorderTable()
            }))
            
            //sort by added date ascending
            actionSheet.addAction(UIAlertAction(title: "By Added Date", style: .default, handler: {(action: UIAlertAction) in
                self.restaurants.sort(by: {($0.value(forKey: "addedDate") as! Date).compare(($1.value(forKey: "addedDate") as! Date)) == orderedWay})
                self.isAscending = !self.isAscending
                self.reorderTable()
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Dragging As You Want", style: .default, handler: {(action: UIAlertAction) in
                self.setEditing(!self.isEditing, animated: true)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(actionSheet, animated: true)
        }
    }
    
    //reorder restaurants and save the order into core data
    func reorderTable() {
        var i = 1
        for item in self.restaurants {
            item.setValue(i, forKey: "order")
            i += 1
        }
        self.updateRestaurant()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateEditRestaurantSegue" {
            let controller: RestaurantCreateEditController = segue.destination as! RestaurantCreateEditController
            //send restaurant names
            controller.restaurantNames = self.restaurants.map({
                (item: NSManagedObject) -> String in
                let restaurant = item as! Restaurant
                return restaurant.name!
            })
            controller.delegate = self
            controller.managedObjectContext = self.managedObjectContext
            
            //Edit
            if ((sender as? Int) != nil) {
                let index = sender as! Int
                let restaurant = self.restaurants[index] as! Restaurant
                controller.title = "Edit Restaurant"
                controller.restaurant = restaurant
            }
                
            //Create
            else if sender as? String == "create" {
                controller.title = "Create Restaurant"
                controller.category = self.category
            }
            
        }
        
        if segue.identifier == "ShowRestaurantDetailSegue" {
            let controller: RestaurantDetailController = segue.destination as! RestaurantDetailController
            let RestaurantCell = sender as! RestaurantCell
            let restaurant = self.restaurants[RestaurantCell.row] as! Restaurant
            controller.restaurant = restaurant
            controller.title = restaurant.name
            controller.delegate = self
        }
    }
    
    // Show an alert with an "YES" and "NO" button.
    func showYesNoAlert(row: Int?) {
        let restaurant = self.restaurants[row!] as! Restaurant
        
        let title = NSLocalizedString("Delete restaurant \(restaurant.name!)", comment: "")
        let message = NSLocalizedString("Are you sure you want to delete \(restaurant.name!)?", comment: "")
        let noButtonTitle = NSLocalizedString("NO", comment: "")
        let yesButtonTitle = NSLocalizedString("YES", comment: "")
        
        let alertCotroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the actions.
        let noAction = UIAlertAction(title: noButtonTitle, style: .cancel) { _ in
        }
        
        let yesAction = UIAlertAction(title: yesButtonTitle, style: .default) { _ in
            
        restaurant.setValue(false, forKey: "enable")
        self.updateRestaurant()
        }
        
        // Add the actions.
        alertCotroller.addAction(yesAction)
        alertCotroller.addAction(noAction)
        
        present(alertCotroller, animated: true, completion: nil)
    }

}
