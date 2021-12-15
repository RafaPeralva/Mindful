//
//  FoodEntity+CoreDataProperties.swift
//  Mindful
//
//  Created by Rafaela Peralva on 12/10/21.
//
//

import Foundation
import CoreData


extension FoodEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntity> {
        return NSFetchRequest<FoodEntity>(entityName: "FoodEntity")
    }

    @NSManaged public var addedDate: Date?
    @NSManaged public var calories: Float
    @NSManaged public var carbs: Float
    @NSManaged public var cholesterol: Float
    @NSManaged public var date: Date?
    @NSManaged public var fiber: Float
    @NSManaged public var food_name: String?
    @NSManaged public var potassium: Float
    @NSManaged public var protein: Float
    @NSManaged public var sat_fat: Float
    @NSManaged public var sodium: Float
    @NSManaged public var sugars: Float
    @NSManaged public var total_fat: Float
    @NSManaged public var weight: Float

}

extension FoodEntity : Identifiable {

}
