//
//  RouteRecommendationViewController.swift
//  Jeera
//
//  Created by Qhansa D. Bayu on 21/11/22.
//

import UIKit
import CoreLocation

class RouteRecommendationViewController: UIViewController {
    
    // Initialize the Codable Result Model as the Global Property
    var cagesJSONResult: CagesJSONResult?
    var animalsJSONResult: AnimalsJSONResult?
    
    // Initialized Global Variables for the RagunanZooAnimals JSON
    var totalAnimals: Int = 143
    let pickAnimals: [String] = ["Merak Hijau", "Siamang", "Flamingo Eropa", "Ular Koros", "Ular Sanca Kembang", "Merak Biru", "Gagak", "Orangutan Kalimantan"]
    
    // Initialized Global Variables for Temporary Animals + Cages to Hold the GeoJSON Data
    var tempAnimalsIdName: [String] = []
    var tempAnimalsCage: [String] = []
    var tempAnimalsLong: [Double] = []
    var tempAnimalsLat: [Double] = []
    
    // Initialized Global Variables for Sorting the Picked Animals
    var sortedAnimalsCage: [String] = []
    var sortedAnimalsIdName: [String] = []
    var sortedAnimalsLong: [Double] = []
    var sortedAnimalsLat: [Double] = []
    
    // Initialized Global Variables for Picked Animals
    var pickAnimalsCage: [String] = []
    var pickAnimalsIdName: [String] = []
    var pickAnimalsLong: [Double] = []
    var pickAnimalsLat: [Double] = []
    
    // Initiate The Core Location Manager
    let locationManager = CLLocationManager()
    
    // Initialize the User's Current Location Longitude & Latitude
    var currentLocationLong: Double = 0.0
    var currentLocationLat: Double = 0.0
    
    // Initialized Global Variables for Temporary Animal Cages to Hold the GeoJSON Data
    var tempCagesIdName: [String] = []
    var tempCagesLong: [Double] = []
    var tempCagesLat: [Double] = []
    
    // Initialized Global Variables for New Animal Cages After The Nearest Orangutan Kalimantan Cage is Chosen
    var newCagesIdName: [String] = []
    var newCagesLong: [Double] = []
    var newCagesLat: [Double] = []
    
    // Initialized Global Variables for Calculating the Distance
    var distanceResult: Double = 0.0
    var sortedCagesDistance: [Double] = []
    var sortedCagesIdName: [String] = []
    var sortedCagesID: [Int] = []
    var sortedCagesLong: [Double] = []
    var sortedCagesLat: [Double] = []
    var nearestDistance: Double = 0.0
    var nearestCageID: Int = 0
    var nearestCageIdName: String = ""
    var nearestCageLong: Double = 0.0
    var nearestCageLat: Double = 0.0
    var passedCageID: [Int] = []
    var passedCageIdName: [String] = []
    var passedCageLong: [Double] = []
    var passedCageLat: [Double] = []
    var totalCages: Int = 28
    var currentLocationDict: [Double] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
        
        // Pick the Chosen Animals to be Searched in the Multi Route Recommendation Feature
        chooseTheAnimals()
        
        // Print the User's Current Location Longitude & Latitude
        locationManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        
        locationManager.startUpdatingLocation()
        
        // Get the User's Current Location Longitude & Latitude if they have given the location permission before with Always
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLocation = locationManager.location
            currentLocationLong = currentLocation.coordinate.longitude
            currentLocationDict.append(currentLocationLong)
            currentLocationLat = currentLocation.coordinate.latitude
            currentLocationDict.append(currentLocationLat)
        }
        
        // Call the ParseJSON Function for the "RagunanZooCages.geojson"
        parseJSON()
        
        // Create a Temporary Animal Cages Array
        createTempCagesPicked()
        
        // Calculate the Nearest Cage Based on the User's Current Location (Based on pickAnimals & pickAnimalsCage)
        var newCurrentLocationDict: [Double] = []
        
        // Check if the "Orangutan Kalimantan" Cage is in the pickAnimalsCage Array
        if pickAnimalsCage.contains("Orangutan Kalimantan") {
            // If yes, Find the Nearest "Orangutan Kalimantan" Cage and Remove the Rest of the Farther Cages
            chooseTheNearestOrangutanKalimantan()
            
            // Use the findNearestCagePickedNew Function to Get the Multi Route Recommendations
            for _ in 0...(newCagesIdName.count - 1) {
                newCurrentLocationDict = findNearestCagePickedNew(currentLocationDict: currentLocationDict)
            }
        } else {
            
            // Use the findNearestCagePickedTemp Function to Get the Multi Route Recommendations
            for _ in 0...(tempCagesIdName.count - 1) {
                newCurrentLocationDict = findNearestCagePickedTemp(currentLocationDict: currentLocationDict)
            }
        }
        
        print("=======================================")
        print(" THE MULTI ROUTE RECOMMENDATION RESULT ")
        print("=======================================")
        print("Nama Kandang: \(passedCageIdName)")
        print("Longitude: \(passedCageLong)")
        print("Latitude: \(passedCageLat)")
        print("Jumlah Kandang: \(passedCageIdName.count)")
        print("")
        
    }
    
    // MARK: - PICK THE CHOSEN ANIMALS (DETAILED) AND CONVERT TO THE ANIMAL CAGES ARRAY
    func chooseTheAnimals() {
        // Parse the "RagunanZooAnimals" JSON
        guard let animalsPath = Bundle.main.path(forResource: "RagunanZooAnimals", ofType: "geojson")
        else {
            return
        }
        // Add the URL to the file
        let animalsURL = URL(fileURLWithPath: animalsPath)
        
        // Create a Data Advert using Throw (Do-Catch)
        do {
            let animalsJSONData = try Data(contentsOf: animalsURL)
            
            // Parse the jsonData with Codable Model "animalsJSONResult"
            animalsJSONResult = try JSONDecoder().decode(AnimalsJSONResult.self, from: animalsJSONData)
            
        }
        catch {
            print("ERROR: \(error)")
        }
        
        // Create a Temporary Animal Array from the Picked Animals by the User's
        print("")
        print("The Picked Animals: \(pickAnimals)")
        print("The Picked Animals.count: \(pickAnimals.count)")
        print("")
        
        // Get the Data from the RagunanZooAnimals GeoJSON File and Add to the Temporary Animals Array
        for nPickedAnimals in pickAnimals {
            for ii in 0...(totalAnimals - 1){
                if nPickedAnimals == animalsJSONResult?.features[ii].properties.idName {
                    tempAnimalsIdName.append(animalsJSONResult?.features[ii].properties.idName ?? "animalsJSONResult?.features[\(ii)].properties.idName Gak Keluar")
                    tempAnimalsCage.append(animalsJSONResult?.features[ii].properties.cage ?? "animalsJSONResult?.features[\(ii)].properties.cage Gak Keluar")
                    tempAnimalsLong.append(animalsJSONResult?.features[ii].geometry.coordinates[0] ?? 0.0)
                    tempAnimalsLat.append(animalsJSONResult?.features[ii].geometry.coordinates[1] ?? 0.0)
                    
                    // Sort the Temporary Animals that are in the Same Cage
                    if !sortedAnimalsIdName.contains(animalsJSONResult?.features[ii].properties.idName ?? "animalsJSONResult?.features[\(ii)].properties.idName Gak Keluar") {
                        sortedAnimalsCage.append(animalsJSONResult?.features[ii].properties.cage ?? "animalsJSONResult?.features[\(ii)].properties.cage Gak Keluar")
                        sortedAnimalsIdName.append(animalsJSONResult?.features[ii].properties.idName ?? "animalsJSONResult?.features[\(ii)].properties.idName Gak Keluar")
                        sortedAnimalsLong.append(animalsJSONResult?.features[ii].geometry.coordinates[0] ?? 0.0)
                        sortedAnimalsLat.append(animalsJSONResult?.features[ii].geometry.coordinates[1] ?? 0.0)
                    } else {
                        sortedAnimalsCage.insert(animalsJSONResult?.features[ii].properties.cage ?? "animalsJSONResult?.features[\(ii)].properties.cage Gak Keluar", at: 0)
                        sortedAnimalsIdName.insert(animalsJSONResult?.features[ii].properties.idName ?? "animalsJSONResult?.features[\(ii)].properties.idName Gak Keluar", at: 0)
                        sortedAnimalsLong.insert(animalsJSONResult?.features[ii].geometry.coordinates[0] ?? 0.0, at: 0)
                        sortedAnimalsLat.insert(animalsJSONResult?.features[ii].geometry.coordinates[1] ?? 0.0, at: 0)
                    }
                }
            }
        }
        
        // DEBUGGING: PRINT THE TEMPORARY ANIMALS ARRAY
        print("-------------------------------------------------------")
        print("   FIND THE AVAILABLE CAGES FOR THE SPECIFIC ANIMALS   ")
        print("-------------------------------------------------------")
        print("tempAnimalsIdName: \(tempAnimalsIdName)")
        print("tempAnimalsCage: \(tempAnimalsCage)")
        print("tempAnimalsLong: \(tempAnimalsLong)")
        print("tempAnimalsLat: \(tempAnimalsLat)")
        print("tempAnimalsIdName.count: \(tempAnimalsIdName.count)")
        print("")
        
        // DEBUGGING: PRINT THE SORTED ANIMALS ARRAY
        print("------------------------------------------------------------------------------")
        print("   SORT THE ANIMAL ARRAY BASED ON WHICH CAGES THAT HAS MORE DETAILED ANIMALS  ")
        print("------------------------------------------------------------------------------")
        print("sortedAnimalsCage: \(sortedAnimalsCage)")
        print("sortedAnimalsIdName: \(sortedAnimalsIdName)")
        print("sortedAnimalsLong: \(sortedAnimalsLong)")
        print("sortedAnimalsLat: \(sortedAnimalsLat)")
        print("sortedAnimalsIdName.count: \(sortedAnimalsIdName.count)")
        print("")
        
        // Merge the Picked Animals that are in the Same Cage to pickAnimalsCage
        for nAnimal in sortedAnimalsIdName {
            for ii in 0...(sortedAnimalsIdName.count - 1) {
                if nAnimal == sortedAnimalsIdName[ii] {
                    // Check if the Cage Name is Not Already Added in the pickAnimalsCage Array
                    if !pickAnimalsCage.contains(sortedAnimalsCage[ii]) {
                        // Check if the Animal Name is Already Added in the pickAnimalsIdName Array
                        if !pickAnimalsIdName.contains(sortedAnimalsIdName[ii]) {
                            pickAnimalsCage.append(sortedAnimalsCage[ii])
                            pickAnimalsIdName.append(sortedAnimalsIdName[ii])
                            pickAnimalsLong.append(sortedAnimalsLong[ii])
                            pickAnimalsLat.append(sortedAnimalsLat[ii])
                        }
                    }
                }
            }
        }
        
        // DEBUGGING: PRINT THE PICKED ANIMALS CAGE ARRAY BEFORE RUNNING IT ON THE GREEDY ALGORITHMS
        print("--------------------------------------------------------------")
        print("   THE FINAL CAGE LIST BEFORE RUNNING THE GREEDY ALGORITHMS   ")
        print("--------------------------------------------------------------")
        print("pickAnimalsCage: \(pickAnimalsCage)")
        print("pickAnimalsCage.count: \(pickAnimalsCage.count)")
        print("")
        
    }
    
    // MARK: - PARSE THE "RAGUNAN ZOO CAGES" JSON FUNCTION
    // Source: www.youtube.com/watch?v=g0kOJk4hTnY
    private func parseJSON() {
        // Get the path to the JSON file at this Project
        guard let path = Bundle.main.path(forResource: "RagunanZooCages", ofType: "geojson")
        else {
            return
        }
        // Add the URL to the file
        let url = URL(fileURLWithPath: path)
        
        // Create a Data Advert using Throw (Do-Catch)
        do {
            let jsonData = try Data(contentsOf: url)
            
            // Parse the jsonData with Codable Model "Result"
            cagesJSONResult = try JSONDecoder().decode(CagesJSONResult.self, from: jsonData)
        }
        catch {
            print("ERROR: \(error)")
        }
    }
    
    // MARK: - CREATE A TEMPORARY ANIMAL CAGES ARRAY (PICKED ANIMALS)
    func createTempCagesPicked() {
        // Get the Data from the GeoJSON File and Add to the Temporary Cages Array with Picked Animals
        for nPickedAnimalsCage in pickAnimalsCage {
            for ii in 0...(totalCages - 1){
                if nPickedAnimalsCage == cagesJSONResult?.features[ii].properties.idName ?? "cagesJSONResult?.features[\(ii)].properties.idName Gak Keluar" {
                    tempCagesIdName.append(cagesJSONResult?.features[ii].properties.idName ?? "cagesJSONResult?.features[\(ii)].properties.idName Gak Keluar")
                    tempCagesLong.append(cagesJSONResult?.features[ii].geometry.coordinates[0] ?? 0.0)
                    tempCagesLat.append(cagesJSONResult?.features[ii].geometry.coordinates[1] ?? 0.0)
                }
            }
        }
    }
    
    // MARK: - FIND THE NEAREST ORANGUTAN KALIMANTAN CAGE AND REMOVE THE REST
    func chooseTheNearestOrangutanKalimantan() {
        // Initialize the Local Variables
        var tempOrangutanKalimantanDistance: Double = 0.0
        var sortedOrangutanKalimantanDistance: [Double] = []
        var sortedOrangutanKalimantanID: [Int] = []
        var sortedOrangutanKalimantanIdName: [String] = []
        var sortedOrangutanKalimantanLong: [Double] = []
        var sortedOrangutanKalimantanLat: [Double] = []
        var nearestOrangutanKalimantanCageID: Int = 0
        var nearestOrangutanKalimantanDistance: Double = 0.0
        var nearestOrangutanKalimantanCageIdName: String = ""
        var nearestOrangutanKalimantanCageLong: Double = 0.0
        var nearestOrangutanKalimantanCageLat: Double = 0.0
        
        for ii in 0...(tempCagesIdName.count - 1){
            // Check if we find the Orangutan Kalimantan Cage in the Cages Array
            if tempCagesIdName[ii] == "Orangutan Kalimantan" {
                // Calculate the Distance between the User's Current Location with the Orangutan Kalimantan Cage
                tempOrangutanKalimantanDistance = sqrt(pow((currentLocationLong - tempCagesLong[ii]), 2) + pow((currentLocationLat - tempCagesLat[ii]), 2))*1000
                
                // Sort the Nearest Orangutan Kalimantan Cage with the User's Current Location
                if tempOrangutanKalimantanDistance < sortedOrangutanKalimantanDistance.first ?? 0.0 {
                    sortedOrangutanKalimantanID.insert(ii, at: 0)
                    sortedOrangutanKalimantanIdName.insert(tempCagesIdName[ii], at: 0)
                    sortedOrangutanKalimantanDistance.insert(tempOrangutanKalimantanDistance, at: 0)
                    sortedOrangutanKalimantanLong.insert(tempCagesLong[ii], at: 0)
                    sortedOrangutanKalimantanLat.insert(tempCagesLat[ii], at: 0)
                } else if tempOrangutanKalimantanDistance > sortedOrangutanKalimantanDistance.last ?? 0.0 {
                    sortedOrangutanKalimantanID.append(ii)
                    sortedOrangutanKalimantanIdName.append(tempCagesIdName[ii])
                    sortedOrangutanKalimantanDistance.append(tempOrangutanKalimantanDistance)
                    sortedOrangutanKalimantanLong.append(tempCagesLong[ii])
                    sortedOrangutanKalimantanLat.append(tempCagesLat[ii])
                } else {
                    for jj in 0...sortedOrangutanKalimantanDistance.count {
                        if sortedOrangutanKalimantanDistance[jj] > tempOrangutanKalimantanDistance {
                            sortedOrangutanKalimantanID.insert(ii, at: jj)
                            sortedOrangutanKalimantanIdName.insert(tempCagesIdName[ii], at: jj)
                            sortedOrangutanKalimantanDistance.insert(tempOrangutanKalimantanDistance, at: jj)
                            sortedOrangutanKalimantanLong.insert(tempCagesLong[ii], at: jj)
                            sortedOrangutanKalimantanLat.insert(tempCagesLat[ii], at: jj)
                            break
                        }
                    }
                }
                
                // Save the Nearest Cage to some Variables
                nearestOrangutanKalimantanCageID = sortedOrangutanKalimantanID[0]
                nearestOrangutanKalimantanDistance = sortedOrangutanKalimantanDistance[0]
                nearestOrangutanKalimantanCageIdName = sortedOrangutanKalimantanIdName[0]
                nearestOrangutanKalimantanCageLong = sortedOrangutanKalimantanLong[0]
                nearestOrangutanKalimantanCageLat = sortedOrangutanKalimantanLat[0]

            } else {
                newCagesIdName.append(tempCagesIdName[ii])
                newCagesLong.append(tempCagesLong[ii])
                newCagesLat.append(tempCagesLat[ii])
            }
        }
        
        // Add the Nearest Orangutan Kalimantan Cage to the New Animal Cages Array
        newCagesIdName.append(nearestOrangutanKalimantanCageIdName)
        newCagesLong.append(nearestOrangutanKalimantanCageLong)
        newCagesLat.append(nearestOrangutanKalimantanCageLat)
        
    }
    
    // MARK: - FIND NEARST CAGE FUNCTION USING THE NEW ANIMAL CAGES ARRAY (PICKED + TEMP)
    // Calculate the Distance Between the User's Current Location to the Picked Cages (No Orangutan Kalimantan Filter)
    func findNearestCagePickedTemp(currentLocationDict: [Double]) -> [Double] {
        sortedCagesID.removeAll()
        sortedCagesIdName.removeAll()
        sortedCagesDistance.removeAll()
        sortedCagesLong.removeAll()
        sortedCagesLat.removeAll()
        
        for ii in 0...(tempCagesIdName.count - 1){
            // Make sure the newCagesIdName.count != 0
            if tempCagesIdName.count != 0 {
                // Use the Temporary Cages Array
                distanceResult = sqrt(pow((currentLocationLong - tempCagesLong[ii]), 2) + pow((currentLocationLat - tempCagesLat[ii]), 2))*1000
                
                // Sort the Distance from Nearest to Farthest from the User's Current Location in an Array
                if distanceResult < sortedCagesDistance.first ?? 0.0 {
                    sortedCagesID.insert(ii, at: 0)
                    sortedCagesIdName.insert(tempCagesIdName[ii], at: 0)
                    sortedCagesDistance.insert(distanceResult, at: 0)
                    sortedCagesLong.insert(tempCagesLong[ii], at: 0)
                    sortedCagesLat.insert(tempCagesLat[ii], at: 0)
                } else if distanceResult > sortedCagesDistance.last ?? 0.0 {
                    sortedCagesID.append(ii)
                    sortedCagesIdName.append(tempCagesIdName[ii])
                    sortedCagesDistance.append(distanceResult)
                    sortedCagesLong.append(tempCagesLong[ii])
                    sortedCagesLat.append(tempCagesLat[ii])
                } else {
                    for jj in 0...sortedCagesDistance.count {
                        if sortedCagesDistance[jj] > distanceResult {
                            sortedCagesID.insert(ii, at: jj)
                            sortedCagesIdName.insert(tempCagesIdName[ii], at: jj)
                            sortedCagesDistance.insert(distanceResult, at: jj)
                            sortedCagesLong.insert(tempCagesLong[ii], at: jj)
                            sortedCagesLat.insert(tempCagesLat[ii], at: jj)
                            break
                        }
                    }
                }
            }
        }
        
        // Save the Nearest Cage to some Variables
        nearestCageID = sortedCagesID[0]
        nearestDistance = sortedCagesDistance[0]
        nearestCageIdName = sortedCagesIdName[0]
        nearestCageLong = sortedCagesLong[0]
        nearestCageLat = sortedCagesLat[0]
        
        // Update the Current Location Longitude & Latitude with the Last Visited Cage
        currentLocationLong = tempCagesLong[nearestCageID]
        currentLocationLat = tempCagesLat[nearestCageID]
        self.currentLocationDict.removeAll()
        self.currentLocationDict.append(currentLocationLong)
        self.currentLocationDict.append(currentLocationLat)
        
        // Save the Passed Cages ID, IdName, Longitude, and Latitude
        passedCageIdName.append(nearestCageIdName)
        passedCageLong.append(nearestCageLong)
        passedCageLat.append(nearestCageLat)
        
        // Remove the Nearest Cage from the Temporary Cages Array (Old)
        tempCagesIdName.remove(at: nearestCageID)
        tempCagesLong.remove(at: nearestCageID)
        tempCagesLat.remove(at: nearestCageID)
        
        return self.currentLocationDict
    }
    
    // MARK: - FIND NEARST CAGE FUNCTION USING THE NEW ANIMAL CAGES ARRAY (PICKED + NEW)
    // Calculate the Distance Between the User's Current Location to the Picked Cages (After Orangutan Kalimantan Filter)
    func findNearestCagePickedNew(currentLocationDict: [Double]) -> [Double] {
        sortedCagesID.removeAll()
        sortedCagesIdName.removeAll()
        sortedCagesDistance.removeAll()
        sortedCagesLong.removeAll()
        sortedCagesLat.removeAll()
        
        for ii in 0...(newCagesIdName.count - 1){
            // Make sure the newCagesIdName.count != 0
            if newCagesIdName.count != 0 {
                // Use the New Temporary Cages Array
                distanceResult = sqrt(pow((currentLocationLong - newCagesLong[ii]), 2) + pow((currentLocationLat - newCagesLat[ii]), 2))*1000
                
                // Sort the Distance from Nearest to Farthest from the User's Current Location in an Array
                if distanceResult < sortedCagesDistance.first ?? 0.0 {
                    sortedCagesID.insert(ii, at: 0)
                    sortedCagesIdName.insert(newCagesIdName[ii], at: 0)
                    sortedCagesDistance.insert(distanceResult, at: 0)
                    sortedCagesLong.insert(newCagesLong[ii], at: 0)
                    sortedCagesLat.insert(newCagesLat[ii], at: 0)
                } else if distanceResult > sortedCagesDistance.last ?? 0.0 {
                    sortedCagesID.append(ii)
                    sortedCagesIdName.append(newCagesIdName[ii])
                    sortedCagesDistance.append(distanceResult)
                    sortedCagesLong.append(newCagesLong[ii])
                    sortedCagesLat.append(newCagesLat[ii])
                } else {
                    for jj in 0...sortedCagesDistance.count {
                        if sortedCagesDistance[jj] > distanceResult {
                            sortedCagesID.insert(ii, at: jj)
                            sortedCagesIdName.insert(newCagesIdName[ii], at: jj)
                            sortedCagesDistance.insert(distanceResult, at: jj)
                            sortedCagesLong.insert(newCagesLong[ii], at: jj)
                            sortedCagesLat.insert(newCagesLat[ii], at: jj)
                            break
                        }
                    }
                }
            }
        }
        
        // Save the Nearest Cage to some Variables
        nearestCageID = sortedCagesID[0]
        nearestDistance = sortedCagesDistance[0]
        nearestCageIdName = sortedCagesIdName[0]
        nearestCageLong = sortedCagesLong[0]
        nearestCageLat = sortedCagesLat[0]
        
        // Update the Current Location Longitude & Latitude with the Last Visited Cage
        currentLocationLong = newCagesLong[nearestCageID]
        currentLocationLat = newCagesLat[nearestCageID]
        self.currentLocationDict.removeAll()
        self.currentLocationDict.append(currentLocationLong)
        self.currentLocationDict.append(currentLocationLat)
        
        // Save the Passed Cages ID, IdName, Longitude, and Latitude
        passedCageIdName.append(nearestCageIdName)
        passedCageLong.append(nearestCageLong)
        passedCageLat.append(nearestCageLat)
        
        // Remove the Nearest Cage from the New Temporary Cages Array (New)
        newCagesIdName.remove(at: nearestCageID)
        newCagesLong.remove(at: nearestCageID)
        newCagesLat.remove(at: nearestCageID)
        
        return self.currentLocationDict
    }
}

// MARK: - Create a Model that represents whatever the structure of the "RagunanZooAnimals" JSON File (Array of Objects)
// RagunanZooAnimals JSON
struct AnimalsJSONResult: Codable {
    let features: [AnimalsJSONResultItem]
    let type: String
}

// RagunanZooAnimals Feature
struct AnimalsJSONResultItem: Codable {
    let type: String
    let properties: AnimalsProperties
    let geometry: Geometry
    let id: String
}

// RagunanZooAnimals Properties
struct AnimalsProperties: Codable {
    let enName, idName, latinName: String
    let cage: String
}

// MARK: - Create a Model that represents whatever the structure of the "RagunanZooCages" JSON File (Array of Objects)
// RagunanZooCages JSON
struct CagesJSONResult: Codable {
    let features: [CagesJSONResultItem]
    let type: String
}

// RagunanZooCages Feature
struct CagesJSONResultItem: Codable {
    let type: String
    let properties: CagesProperties
    let geometry: Geometry
    let id: String
}

// RagunanZooCages Properties
struct CagesProperties: Codable {
    let idName, enName: String
    let type: String
    let clusterName: String
}

// Geometry
struct Geometry: Codable {
    let coordinates: [Double]
    let type: String
}
