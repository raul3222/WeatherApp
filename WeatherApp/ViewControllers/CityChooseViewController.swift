//
//  CityChooseViewController.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 20.12.2021.
//

import UIKit

class CityChooseViewController: UIViewController {
//    var cities: [String] = []
    
    var delegate: CurrentCityDelegate!
    var cities: [String]!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cityChooseTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather"
        cityChooseTF.delegate = self
    }
  
    @IBAction func doneButton(_ sender: Any) {
        view.endEditing(true)
        guard let text = cityChooseTF.text else { return }
        
        delegate.saveCity(city: text)
        dismiss(animated: true)
    }
    
}


extension CityChooseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let citiesArr = cities {
            return citiesArr.count
        } else {
            return 1
                
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citiesCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = cities[indexPath.row]
        cell.contentConfiguration = content
        return cell
        
    }
    
    
    
}

extension CityChooseViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        //delegate.saveCity(city: text)
        //titleLabel.text = text
    }
}
