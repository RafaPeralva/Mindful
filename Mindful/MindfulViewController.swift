//
//  ViewController.swift
//  Mindful
//
//  Created by Rafaela Peralva on 11/5/21.

import UIKit
import CoreData

class MindfulViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        tableView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        let cellNib = UINib(nibName: "SearchFoodCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SearchFoodCell")
        searchBar.becomeFirstResponder()

    }
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    var listOfFood = [FoodDetail](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.listOfFood.count) foods found!"
            }
        }
    }
    
    var searchResults = [FoodDetail]()

    var hasSearched = false
}

func getData(searchText: String, completion: @escaping ((FoodResponse?)-> Void)) {
        let encodedText = searchText.addingPercentEncoding(
                  withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://trackapi.nutritionix.com/v2/search/instant?query=\(encodedText)")



        guard let requestUrl = url else { fatalError() }

        //URl request and method
        var request = URLRequest(url: requestUrl)
        request.allHTTPHeaderFields = [
        "x-app-id": "8ac6d63e",
        "x-app-key":"4d354d9e35c0c833e88fbbfc37d43515",
    ]
    
    URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in

        guard let data = data, error == nil else{
            print("something went wrong")
            return
    }
        var result: FoodResponse?

        do{
            result = try JSONDecoder().decode(FoodResponse.self, from: data)
            completion(result)
        }
        catch{
            print("failed to convert \(error)")
        }

    }.resume()
}

// MARK: - Search Bar Delegate
extension MindfulViewController: UISearchBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
      return .topAttached
    }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      searchBar.resignFirstResponder()
      hasSearched = true
      searchResults = []

      getData(searchText: searchBar.text!){
          (output) in
          guard let foods = output?.common else {return}
          self.searchResults = foods
          DispatchQueue.main.async {
              self.tableView.reloadData()
          }
          
         
      }
    }
}

// MARK: - Table View Delegate
extension MindfulViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
        if !hasSearched {
            return 0
          } else if searchResults.count == 0 {
            return 1
          } else {
            return searchResults.count
          }
        
    }

    func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cellIdentifier = "SearchFoodCell"
          let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath) as! SearchFoodCell
          if searchResults.count == 0 {
              cell.food_nameLabel.text = "(Nothing found)"
          } else {
            let searchResult = searchResults[indexPath.row]
              cell.food_nameLabel.text = searchResult.food_name
              
          }
        return cell
    }
    
}

extension MindfulViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let foodName = searchResults[indexPath.row].food_name else {return}
        let detailView = storyboard?.instantiateViewController(withIdentifier: "FoodDetailViewController") as? FoodDetailViewController
        detailView?.name = foodName
        detailView?.typeFunc = "add"
        self.navigationController?.pushViewController(detailView!, animated: true)
    }
}
