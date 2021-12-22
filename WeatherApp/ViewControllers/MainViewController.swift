//
//  ViewController.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 18.12.2021.
//

import UIKit
import Alamofire

protocol CurrentCityDelegate {
    func saveCity(city: String)
}

class MainViewController: UIViewController {
    @IBOutlet var cityName: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var conditionTextLabel: UILabel!

    @IBOutlet var weatherLogo: UIImageView!
    var cities: [String] = []
    var citiesFromApi: [Cities] = []
     var city = ""
     lazy var link = "https://api.weatherapi.com/v1/current.json?key=284d7d06687e411e9dd211536211812&q=\(city)&aqi=no"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentCity = UserDefaults.standard.string(forKey: "City") {
            city = currentCity
            if !cities.contains(city) {
            cities.append(city)
            }
        }
       // fetchCities()
        hideLabels()
        requestWeather()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! UINavigationController
        let cityChooseVC = destVC.topViewController as! CityChooseViewController
        cityChooseVC.delegate = self
        if !cities.isEmpty {
            cityChooseVC.cities = [city]
        }
        if let citiesArr = UserDefaults.standard.array(forKey: "cities") as? [String]{
                cityChooseVC.cities = citiesArr
          
        }
    }
     
    // Временный костыль
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentCity = UserDefaults.standard.string(forKey: "City") {
            if city != currentCity && !city.isEmpty{
                cities.append(city)
                UserDefaults.standard.set(cities, forKey: "cities")
                UserDefaults.standard.set(city, forKey: "City")
                print("Fetch")
                link = "https://api.weatherapi.com/v1/current.json?key=284d7d06687e411e9dd211536211812&q=\(city)&aqi=no"
                hideLabels()
                requestWeather()
            }
        }
    }
}

extension MainViewController: CurrentCityDelegate {
    func saveCity(city: String) {
        self.city = city
    }
}

//:MARK Network
extension MainViewController {
    private func fetchAlamofire() {
        NetworkManager.shared.fetchData(from: link) { result in
            switch result {

            case .success(let weather):
                self.cityName.text = weather[0].location.name
                self.temperatureLabel.text = String(weather[0].current.temp_c)  + "°"
                self.conditionTextLabel.text = weather[0].current.condition.text
                self.showLabels()
                var logoUrl = weather[0].current.condition.icon
                logoUrl = "https:\(logoUrl)"
                NetworkManager.shared.fetchImage(from: logoUrl) { result in
                    switch result {

                    case .success(let imageData):
                        self.weatherLogo.image = UIImage(data: imageData)
                    case .failure(_):
                        print("error")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchCities() {
        NetworkManager.shared.fetchCities(from: "https://countriesnow.space/api/v0.1/countries/population/cities") { result in
            switch result {

            case .success(let cities):
                self.citiesFromApi = cities
                print(self.citiesFromApi)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func requestWeather() {
        if !city.isEmpty{
        fetchAlamofire()
        } else {
            print("choose city")
        }
    }
    private func hideLabels() {
        cityName.isHidden = true
        temperatureLabel.isHidden = true
        conditionTextLabel.isHidden = true
    }
    private func showLabels() {
        cityName.isHidden = false
        temperatureLabel.isHidden = false
        conditionTextLabel.isHidden = false
    }
}



