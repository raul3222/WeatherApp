//
//  ViewController.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 18.12.2021.
//

import UIKit

protocol CurrentCityDelegate {
    func saveCity(city: String)
}

class WeatherViewController: UIViewController {
    @IBOutlet var cityName: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var conditionTextLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet var weatherLogo: UIImageView!
    private var activityIndicator: UIActivityIndicatorView?
    var cities: [City] = []
    var citiesFromApi: [Cities] = []
    var city = ""
    lazy var link = "https://api.weatherapi.com/v1/current.json?key=284d7d06687e411e9dd211536211812&q=\(city)&aqi=no"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = showActivityIndicator(in: view)
        if let currentCity = UserDefaults.standard.string(forKey: "LastCity") {
                  city = currentCity
              }
        fetchCitiesFromCoreData()
        hideLabels()
        requestWeather()
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(citiesFromApi.count)
        let destVC = segue.destination as! UINavigationController
        let cityChooseVC = destVC.topViewController as! CityChooseViewController
        cityChooseVC.delegate = self
        if !cities.isEmpty {
            print(cities.count)
            cityChooseVC.cities = cities
        }
    }
        
    // Временный костыль
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.set(city, forKey: "LastCity")
        guard let lastCity = UserDefaults.standard.string(forKey: "LastCity") else {return}
        print(lastCity)
        activityIndicator?.startAnimating()
        link = "https://api.weatherapi.com/v1/current.json?key=284d7d06687e411e9dd211536211812&q=\(city)&aqi=no"
        hideLabels()
        requestWeather()
        fetchCitiesFromCoreData()
    }
}

extension WeatherViewController: CurrentCityDelegate {
    func saveCity(city: String) {
        self.city = city
    }
}

//:MARK Network
extension WeatherViewController {
    private func fetchAlamofire() {
        NetworkManager.shared.fetchData(from: link) { result in
            switch result {
            case .success(let weather):
                self.configureUI(with: weather)
            case .failure(let error):
                print(error)
            }
        }
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
    
    private func configureUI(with weather: [Weather]) {
        cityName.text = weather[0].location.name
        temperatureLabel.text = String(weather[0].current.temp_c)  + "°"
        conditionTextLabel.text = weather[0].current.condition.text
        windSpeedLabel.text = String(weather[0].current.wind) + " kph"
        self.activityIndicator?.stopAnimating()
        showLabels()
        var logoUrl = weather[0].current.condition.icon
        logoUrl = "https:\(logoUrl)"
        fetchLogo(from: logoUrl)
        
       
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
        windSpeedLabel.isHidden = true
        weatherLogo.isHidden = true
    }
    private func showLabels() {
        cityName.isHidden = false
        temperatureLabel.isHidden = false
        conditionTextLabel.isHidden = false
        windSpeedLabel.isHidden = false
        weatherLogo.isHidden = false
    }
}

extension WeatherViewController {
    
    private func fetchCitiesFromCoreData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let cities):
                self.cities = cities
            case .failure(_):
                print("Error")
            }
        }
    }
    
    private func save(city cityName: String) {
        StorageManager.shared.save(cityName) { city in
            print("saved")
        }
    }
}

extension WeatherViewController {
    private func showActivityIndicator(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
}
