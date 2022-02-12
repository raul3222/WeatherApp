//
//  CityChooseViewController.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 20.12.2021.
//

import UIKit

class CityChooseViewController: UIViewController {
    
 
    @IBOutlet weak var tableView: UITableView!
    //    var cities: [String] = []
  //  var citiesFromApi: [Cities]!
    var delegate: CurrentCityDelegate!
    var cities: [City]!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cityChooseTF: UITextField!
    
//    private var filteredCities = [Cities]()
//    let searchController = UISearchController(searchResultsController: nil)
//    private var searchBarIsEmpty: Bool {
//        guard let text = searchController.searchBar.text else { return false }
//        return text.isEmpty
//    }
//    private var isFiltering: Bool {
//        return searchController.isActive && !searchBarIsEmpty
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchCities()
        
        //Setup the search controller
        
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
        
        tableView.delegate = self
        title = "Weather"
        cityChooseTF.delegate = self
    }
    
  
  
   
    @IBAction func doneButton(_ sender: Any) {
        var isExist = false
        view.endEditing(true)
        guard let text = cityChooseTF.text else { return }
        delegate.saveCity(city: text)
        if !text.isEmpty {
            StorageManager.shared.fetchData { result in
                switch result{
                case .success(let cities):
                    for city in cities {
                        if city.cityName == text {
                            print("already exist")
                            isExist = true
                            dismiss(animated: true)
                        }
                    }
                case .failure(_):
                    print("Error")
                }
            }
            if !isExist {
                StorageManager.shared.save(text) { city in
                    print("saved")
                }
            }
        }
        dismiss(animated: true)
    }
}


extension CityChooseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if isFiltering {
//            return filteredCities.count
//        }
        if let citiesArr = cities {
            return citiesArr.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citiesCell", for: indexPath)
        
       // var city: Cities
        
//        if isFiltering {
//            city = filteredCities[indexPath.row]
//        } else {
//            print(citiesFromApi.count)
//            city = citiesFromApi[indexPath.row]
//        }
        
        var content = cell.defaultContentConfiguration()
        content.text = cities[indexPath.row].cityName
        //content.text = city.city
        cell.contentConfiguration = content
        return cell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteCity(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func deleteCity(at index: Int) {
        let taskToDelete = cities[index]
        cities.remove(at: index)
        StorageManager.shared.delete(taskToDelete)
    }
}

extension CityChooseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row].cityName
        tableView.deselectRow(at: indexPath, animated: true)
        delegate.saveCity(city: city ?? "")
        dismiss(animated: true)
    }
}

extension CityChooseViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//    }
}

/*extension CityChooseViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCities = citiesFromApi.filter({ (city: Cities) -> Bool in
            return city.city?.lowercased().contains(searchText.lowercased()) ?? true
            
        })
        
        tableView.reloadData()
    }
}*/
