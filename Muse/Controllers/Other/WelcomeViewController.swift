//
//  WelcomeViewController.swift
//  Muse
//
//  Created by Michel Maalouli on 8/13/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let gradient = CAGradientLayer()
    
    
    private let welcomeMessage: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .center
        label.text = "Ready to Swing? A playlist for now."
        label.font = UIFont(name: "Avenir-Heavy", size: 30)
        label.textColor = .systemGray6
        return label
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("   Sign in with Spotify", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        button.setImage(UIImage(named: "spotify_icon"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Muse"
        
        // fill whole view
        self.gradient.frame = self.view.bounds
        self.gradient.colors = [UIColor.systemCyan.cgColor, UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        self.gradient.startPoint = CGPoint(x: 0, y: 0)
        self.gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.gradient.locations = [0,0]
        self.view.layer.addSublayer(self.gradient)
        animationOfView()
        
        self.welcomeMessage.alpha = 0
        self.signInButton.alpha = 0
        
        view.addSubview(welcomeMessage)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        UIView.animate(withDuration: 2.0, animations: {
            self.welcomeMessage.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 2.0) {
                self.signInButton.alpha = 1.0
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        welcomeMessage.frame = CGRect(x: 0, y: 0, width: 300, height: 500)
        welcomeMessage.center = CGPoint(x: view.center.x, y: view.height - 500)
        signInButton.frame = CGRect(x: 35,
                                    y: view.height - 200 - view.safeAreaInsets.bottom,
                                    width: view.width - 70,
                                    height: 60)
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            self?.handleSignIn(success: success)
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        // Log user in or throw error
        guard success else {
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong when signing in!",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
    
    private func animationOfView() {
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [-0.5, 0, 0.5]
        gradientAnimation.toValue = [0.5, 1, 1.5]
        gradientAnimation.duration = 5
        gradientAnimation.autoreverses = true
        gradientAnimation.repeatCount = Float.infinity
        self.gradient.add(gradientAnimation, forKey: nil)
    }

}
