//
//  NewJukeViewController.swift
//  Muse
//
//  Created by Michel Maalouli on 10/22/22.
//

import Foundation
import UIKit

class NewJukeViewController: UIViewController {
    // Create UITextField
    let myTextField: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300.00, height: 30.00))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        myTextField.center = self.view.center
        myTextField.placeholder = "JukeBox Name"
        myTextField.text = "My JukeBox"
        myTextField.backgroundColor = UIColor.white
        myTextField.textColor = UIColor.black
        myTextField.font = UIFont(name: "Avenir-Heavy", size: 25)
        self.view.addSubview(myTextField)
        
        let lineView = UIView(frame: CGRect(x: self.view.center.x - 160, y: self.view.center.y + 20, width: 320, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView)
        
        let createMessage = UILabel(frame: CGRect(x: self.view.center.x - 150, y: self.view.center.y - 200, width: 300, height: 50))
        createMessage.numberOfLines = 3
        createMessage.textAlignment = .center
        createMessage.text = "Create Your Jukebox!"
        createMessage.font = UIFont(name: "Avenir-Heavy", size: 25)
        createMessage.textColor = .black
        
        self.view.addSubview(createMessage)
        
        let button = UIButton(frame: CGRect(x: self.view.center.x - 150, y: self.view.center.y + 100, width: 300, height: 50))
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 25
        button.setTitle("Create", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        self.view.addSubview(button)
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        guard let playlistName = self.myTextField.text, !playlistName.isEmpty else {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        print(playlistName)
        print("Button tapped")
        
//        APICaller.shared.createPlaylist(with: playlistName) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let model):
//                    self?.tracks = model.tracks.items.compactMap({ $0.track })
//                    print("MODELL\n")
//                    print(model)
//                    self?.viewModels = model.tracks.items.compactMap({
//                        RecommendedTrackCellViewModel(
//                            name: $0.track.name,
//                            artistName: $0.track.artists.first?.name ?? "-",
//                            artworkURL: URL(string: $0.track.album?.images.first?.url ?? "")
//                        )
//                    })
//                    self?.collectionView.reloadData()
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }

        APICaller.shared.createPlaylist(with: playlistName) { [weak self] success in
            if success {
                //HapticsManager.shared.vibrate(for: .success)
                // Refresh list of playlists
                //self?.fetchData()
                print("success")
            }
            else {
                // HapticsManager.shared.vibrate(for: .error)
                print("Failed to create playlist")
            }
        }
//        let jukeVC = JukeBoxViewController()
//        jukeVC.modalPresentationStyle = .
//        navigationController?.pushViewController(jukeVC, animated: true)
        let jukeVC = JukeBoxViewController()
        let navigationController = UINavigationController(rootViewController: jukeVC)
        navigationController.modalPresentationStyle = .popover
        present(navigationController, animated: true)
    }
}
