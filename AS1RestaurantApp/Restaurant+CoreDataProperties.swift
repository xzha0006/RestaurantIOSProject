//
//  Restaurant+CoreDataProperties.swift
//  AS1RestaurantApp
//
//  Created by XuanZhang on 28/8/17.
//  Copyright © 2017 Monash. All rights reserved.
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var name: String?
    @NSManaged public var location: String?
    @NSManaged public var addedDate: NSDate?
    @NSManaged public var rating: Double
    @NSManaged public var enable: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var logo: NSData?
    @NSManaged public var category: RestaurantCategory?

}
