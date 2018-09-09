//
//  ViewController.swift
//  NumberPad2
//
//  Created by matthewlui on 09/08/2018.
//  Copyright (c) 2018 matthewlui. All rights reserved.
//

import UIKit
import NumberPad2

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarItem = UIBarButtonItem(title: "Custome", style: .plain, target: self, action: #selector(showCustomeNumberPadViewController))
        navigationItem.rightBarButtonItem = rightBarItem
        // Do any additional setup after loading the view, typically from a nib.
        let numberPad = NumberPad(frame: view.bounds.insetBy(dx: 32, dy: 128))
        numberPad.onButtonPressed = { padItem in
            switch padItem {
            case NumberPatItem.d1:
                debugPrint("D1 is pressed!")
            default:
                break
            }

        }
        view.addSubview(numberPad)
    }

    @objc
    func showCustomeNumberPadViewController() {
        let customeViewController = CustomeNumberPadViewController()
        navigationController?.pushViewController(customeViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

