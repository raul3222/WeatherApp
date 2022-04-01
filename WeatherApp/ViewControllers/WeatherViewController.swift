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
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var imagePhoto: UIImageView!
    @IBOutlet weak var chooseCityLabel: UILabel!
    
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
        link = "https://api.weatherapi.com/v1/current.json?key=284d7d06687e411e9dd211536211812&q=\(city)&aqi=no"
        hideLabels()
        requestWeather()
        fetchCitiesFromCoreData()
    }
}

extension WeatherViewController: CurrentCityDelegate {
    func saveCity(city: String) {
        self.city = city
        UserDefaults.standard.set(city, forKey: "LastCity")
        guard let lastCity = UserDefaults.standard.string(forKey: "LastCity") else {return}
        print(lastCity)
    }
}

//:MARK Network
extension WeatherViewController {
    private func fetchAlamofire() {
        activityIndicator?.startAnimating()
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
//        if weather[0].current.condition.text == "Overcast" {
//            print("overcast")
//            activityIndicator?.startAnimating()
//            NetworkManager.shared.fetchImage(from: "https://oboi.ringtonz.ru/uploads/posts/2020-04/1585949618_oblaka_nebo_chb_151987_1440x2560.jpg") { result in
//                switch result {
//                case .success(let imageData):
//                    self.imagePhoto.image = UIImage(data: imageData)
//                    self.imagePhoto.layer.opacity = 0.6
//                    self.imagePhoto.sizeToFit()
//                    self.activityIndicator?.stopAnimating()
//                    print("photo loaded")
//                case .failure(_):
//                    print("error")
//                }
//            }
//
//        }
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
        chooseCityLabel.isHidden = false
    }
    private func showLabels() {
        cityName.isHidden = false
        temperatureLabel.isHidden = false
        conditionTextLabel.isHidden = false
        windSpeedLabel.isHidden = false
        weatherLogo.isHidden = false
        chooseCityLabel.isHidden = true
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
