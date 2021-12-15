//
//  SearchResult.swift
//  Mindful
//
//  Created by Rafaela Peralva on 11/5/21.
//

import Foundation

//get method classes
class FoodResponse: Codable {
    var common = [FoodDetail]()

}
class FoodDetail: Codable {
    var food_name: String? = ""
}

//classes for post method
class FoodNutrition: Codable {
    var foods = [Nutrition]()
}

class Nutrition: Codable {
    var serving_weight_grams: Float?
    var food_name: String? = ""
    var nf_calories: Float?
    var nf_total_fat: Float?
    var nf_saturated_fat: Float?
    var nf_cholesterol: Float?
    var nf_sodium: Float?
    var nf_total_carbohydrate: Float?
    var nf_dietary_fiber: Float?
    var nf_sugars: Float?
    var nf_protein: Float?
    var nf_potassium: Float?
    var photo: ThumbPic?
}

class ThumbPic: Codable {
    var thumb: String? = ""
}
