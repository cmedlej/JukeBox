//
//  ViewController.swift
//  Muse
//
//  Created by Michel Maalouli on 8/13/22.
//
//
//  ViewController.swift
//  Muse
//
//  Created by Michel Maalouli on 8/13/22.
//

import UIKit
import AVFoundation
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseFirestore

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let map = MKMapView()
    var curr = MKPointAnnotation()
    
    //sample coords
//    let coordinate1 = CLLocationCoordinate2D(latitude: 40.728, longitude:-73.9) //NYC
//    let coordinate2 = CLLocationCoordinate2D(latitude: 33.7756, longitude:-84.3963) //GT
//    let coordinate3 = CLLocationCoordinate2D(latitude: 33.9480, longitude:-83.3773) //EMORY
//    let coordinate4 = CLLocationCoordinate2D(latitude: 33.7971, longitude:-84.3222) // UGA

    var player = AVAudioPlayer()
    //dealing with coords
    let locationManager = CLLocationManager()
    var cord = CLLocationCoordinate2D(latitude: 33.7856, longitude:-84.3963)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //LOC
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }


        title = "Map"
        //MAP
        
        map.frame = view.bounds
        
        
        map.delegate = self
        //Just for visual purposes
//        addCustomPin(coordinate1)
//        addCustomPin(coordinate2)
//        addCustomPin(coordinate3)
//        addCustomPin(coordinate4)
        view.addSubview(map)
//        //BUTTON
//        let button = UIButton(type: .system)
//        button.frame = CGRect(x: 100,y: 100,width: 200,height: 60)
//        button.setTitle("Add Your Juke",for: .normal)
//        button.setTitleColor(.systemBlue,for: .normal)
//        button.backgroundColor = UIColor.black
//        button.addTarget(self,action: #selector(buttonAction(_:)),for: .touchUpInside)
        
        
        
        
        view.backgroundColor = .systemBackground
        //ADD
        let imgView = UIImageView()
        
      
        let addButton = UIImage(named: "newjuke.png")
        imgView.frame = CGRect(x: view.center.x - 75  , y: view.height - 228, width: 171, height: 63) //fix this
        imgView.image = addButton//Assign image to ImageView

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureRecognizer)
        
//        imgView.layer.shadowOffset = .init(width: 5, height: 5)
//        imgView.layer.shadowColor = UIColor.black.cgColor
//        imgView.layer.shadowRadius = 3
//        imgView.layer.shadowOpacity = 1
//        imgView.layer.shadowPath = UIBezierPath(ovalIn: CGRect(x: imgView.bounds.minX - 7, y: imgView.bounds.minY - 7, width: imgView.bounds.width + 5, height: imgView.bounds.height + 5)).cgPath
        view.addSubview(imgView)//Add image to our view
        
        
        
        //REMOVE

        
        
        
        let imgView2 = UIImageView()
        
        let remButton = UIImage(named: "deljuke.png")
        imgView2.frame = CGRect(x: view.center.x - 63, y: view.height - 150, width: 145, height: 57) //fix this
        imgView2.image = remButton//Assign image to ImageView
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3(tapGestureRecognizer:)))
        imgView2.isUserInteractionEnabled = true
        imgView2.addGestureRecognizer(tapGestureRecognizer3)
        
//        imgView.layer.shadowOffset = .init(width: 5, height: 5)
//        imgView.layer.shadowColor = UIColor.black.cgColor
//        imgView.layer.shadowRadius = 3
//        imgView.layer.shadowOpacity = 1
//        imgView.layer.shadowPath = UIBezierPath(ovalIn: CGRect(x: imgView.bounds.minX - 7, y: imgView.bounds.minY - 7, width: imgView.bounds.width + 5, height: imgView.bounds.height + 5)).cgPath
        view.addSubview(imgView2)//Add image to our view
        
        
    }
    
    
    
   
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        if let location = locations.first {
            cord = location.coordinate
            map.setRegion(MKCoordinateRegion(center: cord, span:MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
        }
    }
    private func addCustomPin(_ coordinate: CLLocationCoordinate2D){
            let pin = MKPointAnnotation()
            curr = pin
            pin.coordinate = coordinate
            pin.title = "Your Juke is Here"
            pin.subtitle = "Tune in!"
            map.addAnnotation(pin)
            map.setRegion(MKCoordinateRegion(center: coordinate, span:MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
    }
    // Map
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
        annotationView?.image = UIImage(named: "PinJukebox") //figure out how to make this do something on click
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
        annotationView?.isUserInteractionEnabled = true
        annotationView?.addGestureRecognizer(tapGestureRecognizer2)
        return annotationView
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.alpha = 0.5
        
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))

        // Your action
        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
        impactHeavy.impactOccurred()
        var detect = false
        var loc = GeoPoint(latitude: self.cord.latitude, longitude: self.cord.longitude)
        let db = Firestore.firestore()
        db.collection("JukeBox").getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for document in (snapshot?.documents)! {
                    let id = document.data()["LocationCreated"] as? GeoPoint
                    if  id == loc {
                        print(document.data()["JukeBoxID"] as! String)
                        detect = true
                    }
                }
                var uid = UUID().uuidString
                if detect == false {
                    db.collection("JukeBox/").addDocument(data: [
                        "JukeBoxID": uid,
                        "LocationCreated": loc,
                        "TimeCreated": time,
                        "userID": "@3",
                        "userName": "cd",
                        "playlistName": "sd"
                    ])
                }
            }
        }
        
        addCustomPin(cord)
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
//        // create a sound ID, in this case its the tweet sound.
//        let systemSoundID: SystemSoundID = 1050
//        // to play sound
//        AudioServicesPlaySystemSound(systemSoundID)
        print("giftapped")
    }


    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer)
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
        let JukeVC = UINavigationController(rootViewController: NewJukeViewController())
        JukeVC.modalPresentationStyle = .popover
        self.present(JukeVC, animated: true, completion: nil)
    //        // create a sound ID, in this case its the tweet sound.
    //        let systemSoundID: SystemSoundID = 1050
    //        // to play sound
    //        AudioServicesPlaySystemSound(systemSoundID)
        
    }
    
    @objc func imageTapped3(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.alpha = 0.5

        // Your action
        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
        impactHeavy.impactOccurred()
        
        var detect = false
        var loc = GeoPoint(latitude: self.cord.latitude, longitude: self.cord.longitude)
        let db = Firestore.firestore()
        db.collection("JukeBox").getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for document in (snapshot?.documents)! {
                    let id = document.data()["LocationCreated"] as? GeoPoint
                    if  id == loc {
                       //db.collection("JukeBox/").delete(document)
                        print(document.data())
                        detect = true
                    }
                }
                if detect == false {
                    print("no item")
                }
            }
        }

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
        print("hey tapped")
        map.removeAnnotation(curr)
    //        // create a sound ID, in this case its the tweet sound.
    //        let systemSoundID: SystemSoundID = 1050
    //        // to play sound
    //        AudioServicesPlaySystemSound(systemSoundID)
        
    }

}



//import UIKit
//import AVFoundation
//
//class HomeViewController: UIViewController {
//
//    var player = AVAudioPlayer()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Home"
//        view.backgroundColor = .systemBackground
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
//        let imgView = UIImageView()
//
//        let buttonGif = UIImage.gifImageWithName("button2")
//        imgView.frame = CGRect(x: view.center.x - 50, y: view.height - 240, width: 100, height: 100)
//        imgView.image = buttonGif//Assign image to ImageView
//
//        imgView.layer.shadowOffset = .init(width: 5, height: 5)
//        imgView.layer.shadowColor = UIColor.black.cgColor
//        imgView.layer.shadowRadius = 3
//        imgView.layer.shadowOpacity = 1
//        imgView.layer.shadowPath = UIBezierPath(ovalIn: CGRect(x: imgView.bounds.minX - 7, y: imgView.bounds.minY - 7, width: imgView.bounds.width + 5, height: imgView.bounds.height + 5)).cgPath
//        view.addSubview(imgView)//Add image to our view
//
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        imgView.isUserInteractionEnabled = true
//        imgView.addGestureRecognizer(tapGestureRecognizer)
//
//    }
//
//    @objc func didTapSettings() {
//        let vc = ProfileViewController()
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
//    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
//        tappedImage.alpha = 0.5
//
//        // Your action
//        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
//        impactHeavy.impactOccurred()
//
//        let audioPath = Bundle.main.path(forResource: "buttonPressed", ofType: "mp3")
//        do {
//            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
//            player.play()
//        } catch {
//            print("did not play sound")
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            tappedImage.alpha = 1
//        }
////        // create a sound ID, in this case its the tweet sound.
////        let systemSoundID: SystemSoundID = 1050
////        // to play sound
////        AudioServicesPlaySystemSound(systemSoundID)
//        print("giftapped")
//        let newJukeVC = UINavigationController(rootViewController: NewJukeViewController())
//        newJukeVC.modalPresentationStyle = .popover
//        self.present(newJukeVC, animated: true, completion: nil)
//    }
//
//}

