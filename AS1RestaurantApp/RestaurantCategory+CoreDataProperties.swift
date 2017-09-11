//
//  RestaurantCategory+CoreDataProperties.swift
//  AS1RestaurantApp
//
//  Created by XuanZhang on 28/8/17.
//  Copyright © 2017 Monash. All rights reserved.
//

import Foundation
import CoreData


extension RestaurantCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestaurantCategory> {
        return NSFetchRequest<RestaurantCategory>(entityName: "RestaurantCategory")
    }

    @NSManaged public var title: String?
    @NSManaged public var color: NSData?
    @NSManaged public var icon: NSData?
    @NSManaged public var enable: Bool
    @NSManaged public var order: Int32
    @NSManaged public var restaurants: NSSet?

}

// MARK: Generated accessors for restaurants
extension RestaurantCategory {

    @objc(addRestaurantsObject:)
    @NSManaged public func addToRestaurants(_ value: Restaurant)

    @objc(removeRestaurantsObject:)
    @NSManaged public func removeFromRestaurants(_ value: Restaurant)

    @objc(addRestaurants:)
    @NSManaged public func addToRestaurants(_ values: NSSet)

    @objc(removeRestaurants:)
    @NSManaged public func removeFromRestaurants(_ values: NSSet)

}
