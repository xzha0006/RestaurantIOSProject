//
//  SingleRestaurantScreenController.swift
//  AS1RestaurantApp
//
//  Created by XuanZhang on 4/9/17.
//  Copyright © 2017 Monash. All rights reserved.
//

import UIKit


class SingleCategoryScreenController: UITableViewController {
    
    var category: RestaurantCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        
        let restaurants = self.category?.restaurants?.allObjects as! [Restaurant]
        let restaurant = restaurants[indexPath.row]
        
        cell.nameLabel.text = restaurant.name
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let addDate = formatter.string(from: restaurant.addedDate as! Date)
        cell.dateLabel.text = addDate
        cell.logoImageView.image = UIImage(data: restaurant.logo! as Data)
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.category?.restaurants?.count)!
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
