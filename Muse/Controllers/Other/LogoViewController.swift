//
//  LogoViewController.swift
//  Muse
//
//  Created by Michel Maalouli on 8/15/22.
//

import UIKit

class LogoViewController: UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = .black
        let imgView = UIImageView()
        let logoGif = UIImage.gifImageWithName("logo")
        imgView.frame = CGRect(x: self.view.center.x - 132, y: self.view.center.y - 132, width: 264, height: 264)
        imgView.image = logoGif//Assign image to ImageView
        self.view.addSubview(imgView)//Add image to our view
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if AuthManager.shared.isSignedIn {
                let mainAppTabBarVC = TabBarViewController()
                mainAppTabBarVC.modalPresentationStyle = .fullScreen
                self.present(mainAppTabBarVC, animated: true)
            } else {
                let navVC = UINavigationController(rootViewController: WelcomeViewController())
                navVC.navigationBar.prefersLargeTitles = true
                navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            }
        }
        
    }
}
