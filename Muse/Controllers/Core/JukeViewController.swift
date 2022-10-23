//
//  JukeViewController.swift
//  Muse
//
//  Created by Cynthia Medlej on 22/10/2022.
//

import Foundation
import UIKit
class JukeViewController: UIViewController {
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: view.width + 17, height: view.height - 66)
        let rand = UIImage(named: "randoplaylist.jpg")
        // imgView.frame = CGRect(x: 0  , y: view.height-423*2,  width: 234 , height: 423)
        imgView.image = rand
        view.addSubview(imgView)
            
        }
}
