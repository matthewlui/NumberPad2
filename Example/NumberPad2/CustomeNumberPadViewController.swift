//
//  CustomeNumberPadViewController.swift
//  NumberPad2_Example
//
//  Created by Matthew Lui on 9/9/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import NumberPad2

enum CustomePadItem: String, PadItem {
    case randomCustom = "Random"
    case plus = "+"
    case multiply = "x"
    case subtract = "-"
}

struct CustomPadData: PadData {
    var items: [[PadItem]] = [[CustomePadItem.randomCustom, CustomePadItem.plus, CustomePadItem.multiply, CustomePadItem.subtract], [NumberPatItem.d1, NumberPatItem.d2]]
}

struct RandomPadItem: PadItem {

    var rawValue: String

    init() {
        rawValue = "R \(arc4random() % 1000)"
    }
}

struct RandomPadData: PadData {

    var items: [[PadItem]]

    init() {
        items = [[CustomePadItem.randomCustom]]
        let row = arc4random() % 4
        let rows = stride(from: 0, to: row, by: 1).map {_ -> [PadItem] in
            let randCol = arc4random() % 3 + 1
            let rowItems = stride(from: 0, to: randCol, by: 1).map {_ in
                return RandomPadItem()
            }
            return rowItems
        }
        items.append(contentsOf: rows)
    }
}

class CustomeNumberPadViewController: UIViewController {

    override func viewDidLoad() {
        let numberPad = NumberPad(frame: view.bounds.insetBy(dx: 64, dy: 128))
        numberPad.config(data: CustomPadData())
        numberPad.onButtonPressed = { item in
            switch item {
            case CustomePadItem.randomCustom:
                numberPad.config(data: RandomPadData())
                let style = NumberPadStyle.roundedCorner(CGFloat(arc4random() % 64))
                numberPad.style = style
                break
            default:
                break
            }
        }
        view.addSubview(numberPad)
    }
}
