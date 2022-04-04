//
//  StorageManager.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 26.12.2021.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    
    // MARK: - Core Data stack
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CitiesList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    private func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(_ cityName: String, completion: (City) -> Void) {
        let city = City(context: viewContext)
        city.cityName = cityName
        completion(city)
        saveContext()
    }
    func saveLastCity(_ lastCityName: String, completion: (LastCity) -> Void) {
        let cityName = LastCity(context: viewContext)
        cityName.lastCityName = lastCityName
        completion(cityName)
        saveContext()
    }
    
    func fetchData(completion: (Result<[City], Error>) -> Void) {
        let fetchRequest = City.fetchRequest()
        do {
            let cities = try viewContext.fetch(fetchRequest)
            completion(.success(cities))
            if cities.isEmpty {
                self.save("Moscow") { city in
            }
            }
        } catch let error{
            completion(.failure(error))
        }
    }
    func delete(_ city: City) {
        viewContext.delete(city)
        saveContext()
    }
}
    
