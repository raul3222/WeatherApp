//
//  CityChooseViewController.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 20.12.2021.
//

import UIKit

class CityChooseViewController: UIViewController {
    
 
    @IBOutlet weak var tableView: UITableView!
    var delegate: CurrentCityDelegate!
    var cities: [City]!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cityChooseTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        guard let citiesArr = cities else { return 1 }
        return citiesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citiesCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = cities[indexPath.row].cityName
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
}
