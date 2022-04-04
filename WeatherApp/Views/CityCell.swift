//
//  CityCell.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 03.04.2022.
//

import UIKit

class CityCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherLogo: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    
    private var link = ""
    
    func configure(with city: City) {
        self.cityName.text = city.cityName
        guard let city = city.cityName else { return }
        link =  "https://api.weatherapi.com/v1/current.json?key=284d7d06687e411e9dd211536211812&q=\(city)&aqi=no"
        NetworkManager.shared.fetchData(from: link) { result in
            switch result {
            case .success(let weather):
                //self.cityName.text = city.cityName
                self.temperature.text = "\(weather[0].current.temp_c)  °"
                var logoUrl = weather[0].current.condition.icon
                logoUrl = "https:\(logoUrl)"
                self.fetchLogo(from: logoUrl)
            case .failure(let error):
                print(error)
            }
        }
       // var content = defaultContentConfiguration()
      //  content.text = city.cityName
        //content.image = UIImage(named: "car")
       // contentConfiguration = content
    }
    private func fetchLogo(from url: String) {
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let imageData):
                self.weatherLogo.image = UIImage(data: imageData)
            case .failure(_):
                print("error")
            }
        }
    }

    
//    content.text =
//    guard let imageData = courseCellViewModel.imageData else { return }
//    content.image = UIImage(data: imageData)
//    contentConfiguration = content
    
}
