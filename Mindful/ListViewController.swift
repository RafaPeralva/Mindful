//
//  ListViewController.swift
//  Mindful
//
//  Created by Rafaela Peralva on 12/1/21.
//


import UIKit
import CoreData

class FoodItem {
    var foodName = ""
}

class ListViewController: UITableViewController {
    var items = [FoodEntity]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 5.0, delay: 0.3, options: [ .curveEaseIn], animations: {
        }, completion: nil)
        fetchFood()
    }
    
    func fetchFood(){
        do {
            self.items = try context.fetch(FoodEntity.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        let foodRemove = self.items[indexPath.row]
        self.context.delete(foodRemove)
        items.remove(at: indexPath.row)
        do{
            try self.context.save()
        }
        catch{
            print("failed to remove")
        }
        self.fetchFood()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodData = self.items[indexPath.row]
        
        guard let foodName = foodData.food_name else {return}
        let detailView = storyboard?.instantiateViewController(withIdentifier: "FoodDetailViewController") as? FoodDetailViewController
        detailView?.name = foodName
        detailView?.typeFunc = "not add"
        self.navigationController?.pushViewController(detailView!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table View Data Source
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "listItem",
            for: indexPath)
        let foodData = self.items[indexPath.row]
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = foodData.food_name
        return cell
        
    }
}
