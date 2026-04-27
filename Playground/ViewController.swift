//
//  ViewController.swift
//  Playground
//
//  Created by Aditya Patole on 07/08/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var aoubfao: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button = GradientButton(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
            view.addSubview(button)
    }


}

