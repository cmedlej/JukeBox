//
//  SearchViewController.swift
//  Muse
//
//  Created by Michel Maalouli on 8/13/22.
//
//
//  SearchViewController.swift
//  Muse
//
//  Created by Michel Maalouli on 8/13/22.
//

//
//  ViewController.swift
//  SearchBar
//
//  Created by Stephen Dowless on 6/25/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import FirebaseFirestore

class SearchViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var cities = [Cities]()
    let searchBar = UISearchBar()
    let map = MKMapView()
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        convertCSVIntoArray(&cities)
        configureUI()
        map.frame = view.bounds
        map.delegate = self
        view.addSubview(map)
        populateMap()
        
        func populateMap() {
            let db = Firestore.firestore()
            db.collection("JukeBox").getDocuments { (snapshot, error) in
                if error != nil {
                    print(error)
                } else {
                    for document in (snapshot?.documents)! {
                        let id = document.data()["LocationCreated"] as? GeoPoint
                        let loc = CLLocationCoordinate2D(latitude: id?.latitude ?? 33.7856, longitude: id?.longitude ?? -84.3963)
                        print(loc)
                        self.addCustomPin(loc)
                        
                        
                    }
                }
            }
        }
    }
    private func addCustomPin(_ coordinate: CLLocationCoordinate2D){
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            map.addAnnotation(pin)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)-> MKAnnotationView?{
        guard !(annotation is MKUserLocation) else{
            return nil
        }
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        if annotationView == nil{
            //Create the view
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "PinJukebox")
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(imageTapped4(tapGestureRecognizer:)))
        annotationView?.isUserInteractionEnabled = true
        annotationView?.addGestureRecognizer(tapGestureRecognizer4)
        return annotationView
    }


@objc func imageTapped4(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! MKAnnotationView
        tappedImage.alpha = 0.5
        
        // Your action
        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
        impactHeavy.impactOccurred()
        
        
        //HERE YOU SWITCH THE VIEWS :)))))
        //        let audioPath = Bundle.main.path(forResource: "buttonPressed", ofType: "mp3")
        //        do {
        //            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        //            player.play()
        //        } catch {
        //            print("did not play sound")
        //        }
        //
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            tappedImage.alpha = 1
        }
        print("tapped")
        let JukeVC2 = UINavigationController(rootViewController: JukeViewController())
        JukeVC2.modalPresentationStyle = .popover
        self.present(JukeVC2, animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    
    @objc func handleShowSearchBar() {
        searchBar.becomeFirstResponder()
        search(shouldShow: true)
    }

    // MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .purple
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255,
                                                 blue: 250/255, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Search for JukeBoxes"
        showSearchBarButton(shouldShow: true)
    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                target: self,
                                                                action: #selector(handleShowSearchBar))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did begin..")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did end..")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text is \(searchText)")
        for city in cities{
//            print(city.city.dropFirst().dropLast())
//            print(searchText.lowercased() == city.city.dropFirst().dropLast().lowercased())
            if searchText.lowercased() == city.city.dropFirst().dropLast().lowercased(){
                print("hey")
                print(city.lat.dropFirst().dropLast())
                print(city.lng.dropFirst().dropLast())
                map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(city.lat.dropFirst().dropLast()) ?? 40.728, longitude: Double(city.lng.dropFirst().dropLast()) ?? -73.9), span:MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
            }
        }
//        if searchText.lowercased() == "NewYork".lowercased(){
//            map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.728, longitude:-73.9), span:MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
//        }
    }
}
func convertCSVIntoArray(_ cities: inout [Cities]) {
    
    //locate the file you want to use
    guard let filepath = Bundle.main.path(forResource: "data", ofType: "csv") else {
        return
    }
    
    //convert that file into one long string
    var data = ""
    do {
        data = try String(contentsOfFile: filepath)
    } catch {
        print(error)
        return
    }
    
    //now split that string into an array of "rows" of data.  Each row is a string.
    var rows = data.components(separatedBy: "\n")
    
    //if you have a header row, remove it here
    rows.removeFirst()
    
    //now loop around each row, and split it into each of its columns
    for row in rows {
        let columns = row.components(separatedBy: ",")
        
        //check that we have enough columns
        if columns.count == 11 {
            let cityname = columns[0]
            let city_ascii = columns[1]
            let lat = columns[2]
            let lng = columns[3]
            let country = columns[4]
            let iso2 = columns[5]
            let iso3 = columns[6]
            let admin_name = columns[7]
            let capital = columns[8]
            let population = columns[9]
            let id = columns[10]
            
            let city = Cities(city: cityname, city_ascii: city_ascii, lat: String(lat), lng: String(lng), country: country, iso2: iso2, iso3: iso3, admin_name: admin_name, capital: capital, population: population, id: id)
            cities.append(city)
        }
    }

}

//import UIKit
//
//class SearchViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "Add song"
//
//        view.backgroundColor = .systemBackground
//    }
//
//}
