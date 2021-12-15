//
//  FoodDetailViewController.swift
//  Mindful
//
//  Created by Rafaela Peralva on 11/17/21.
//

import UIKit
import CoreData

class FoodDetailViewController: UITableViewController {
    let date = Date()
    var name = ""
    var typeFunc = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var resultFood: Nutrition?
    let keys = ["Name", "Weight", "Calories", "Fat", "Saturated Fat", "Cholesterol", "Sodium", "Carbs", "Fiber", "Sugars", "Protein", "Potassium"]
    var values: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if (typeFunc == "add") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(addItem))
            
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(done))
        }
        
        func value(forAttribute attribute: Float?) -> String {
            guard let attribute = attribute else {
                return "-"
            }
            return String(attribute)
        }
        
        getNutrition(searchText: name) { foodOutput  in
            guard
                let foods = foodOutput?.foods,
                let resultFood = foods.first
            else {
                return
            }
            self.resultFood = resultFood
            self.values = [
                resultFood.food_name ?? "Unknown",
                value(forAttribute: resultFood.serving_weight_grams),
                value(forAttribute: resultFood.nf_calories ),
                value(forAttribute: resultFood.nf_total_fat ),
                value(forAttribute: resultFood.nf_saturated_fat ),
                value(forAttribute: resultFood.nf_cholesterol ),
                value(forAttribute: resultFood.nf_sodium ),
                value(forAttribute: resultFood.nf_total_carbohydrate ),
                value(forAttribute: resultFood.nf_dietary_fiber ),
                value(forAttribute: resultFood.nf_sugars ),
                value(forAttribute: resultFood.nf_protein ),
                value(forAttribute: resultFood.nf_potassium )
            ]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let cellNib = UINib(nibName: "detailsCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "detailsCell")
    }
    
    
    @IBAction func addItem() {
        let newFoodEntity = FoodEntity(context: self.context)
        newFoodEntity.addedDate = date
        newFoodEntity.food_name = name

        
        do {
            try self.context.save()
        } catch {
            print("error saving data")
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func done() {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func getNutrition(searchText: String, completion: @escaping ((FoodNutrition?)-> Void)) {
        let encodedText = searchText.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://trackapi.nutritionix.com/v2/natural/nutrients?")
        
        guard let requestUrl = url else { fatalError() }
        
        //URl request and method
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "x-app-id": "8ac6d63e",
            "x-app-key":"4d354d9e35c0c833e88fbbfc37d43515",
            "x-remote-user-id": "0"
        ]
        request.httpBody = "query=\(encodedText)".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            var foodResult: FoodNutrition?
            do {
                let decoder = JSONDecoder()
                let decoderResponse = try decoder.decode(FoodNutrition.self, from: data)
                foodResult = decoderResponse
                DispatchQueue.main.async {
                    completion(foodResult)
                }
            }
            catch {
                print("failed to convert \(error)")
            }
        }.resume()
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultFood == nil ? 0 : 13
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cellIdentifier = "imageCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! imageCell
            let imageData = try? Data(contentsOf: URL(string: (resultFood?.photo?.thumb)!)!)
            cell.foodImage.image = UIImage(data: imageData!)
            return cell
        } else {
            let cellIdentifier = "nutritionCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! nutritionCell
            guard let values = values else {
                return cell
            }
            cell.nutritionLabel.text = keys[indexPath.row - 1]
            cell.valueLabel.text = values[indexPath.row - 1]
            return cell
        }
    }
    
}
