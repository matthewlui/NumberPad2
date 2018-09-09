//
// Created by Matthew Lui on 8/9/2018.
// Copyright (c) 2018 Chatboy.xyz. All rights reserved.
//

import UIKit

public protocol PadItem {
    var rawValue: String { get }
}

public enum NumberPatItem: String, PadItem {
    case d1, d2, d3, d4, d5, d6, d7, d8, d9, d0
}

public protocol PadData {
    var items: [[PadItem]] { get }
}

public struct NumberPadData: PadData {
    public let items: [[PadItem]] = [[NumberPatItem.d1, NumberPatItem.d2, NumberPatItem.d3], [NumberPatItem.d4, NumberPatItem.d5, NumberPatItem.d6], [NumberPatItem.d7, NumberPatItem.d8, NumberPatItem.d9]]
}

public class PadButton: UIButton {

    private(set) var item: PadItem?

    convenience init(item: PadItem, layout: ButtonLayout? = nil) {
        self.init(frame: .zero)
        config(item: item)
        layout.flatMap(config)
    }

    func config(item: PadItem) {
        setTitle(item.rawValue, for: .normal)
        self.item = item
    }

    func config(layout: ButtonLayout) {
        backgroundColor = layout.backgroundColor
        setTitleColor(layout.titleColor, for: .normal)
        titleLabel?.font = layout.font
    }

    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let animation = CABasicAnimation(keyPath: "transform")
        let targetTransform = CATransform3DScale(CATransform3DIdentity, 0.95, 0.95, 1)
        animation.fromValue = CATransform3DIdentity
        animation.toValue = targetTransform
        animation.autoreverses = false
        layer.transform = targetTransform
        layer.add(animation, forKey: "xyz.chatboy.numberpad.2")
        return super.beginTracking(touch, with: event)
    }

    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        layer.transform = CATransform3DIdentity
        super.endTracking(touch, with: event)
    }

}

public struct ButtonLayout {

    var font: UIFont?
    var backgroundColor: UIColor?
    var titleColor: UIColor?

    static var `default`: ButtonLayout {
        return ButtonLayout(font: UIFont.boldSystemFont(ofSize: 24), backgroundColor: .green, titleColor: .white)
    }
}

public enum NumberPadStyle {

    public typealias CornerRadius = CGFloat

    case `default`
    case plain
    case roundedCorner(CornerRadius)
    case customButton(ButtonLayout)
    case fullyCustom(CornerRadius, ButtonLayout)
}

@IBDesignable
public class NumberPad: UIView {

    private(set) var data: PadData?
    private var stackView: UIStackView

    public var onButtonPressed: ((PadItem) -> Void)?

    public var style = NumberPadStyle.default {
        didSet {
            applyStyle()
        }
    }

    override public init(frame: CGRect) {
        stackView = UIStackView(frame: CGRect(origin: .zero, size: frame.size))
        super.init(frame: frame)
        addSubview(stackView)
        config(data: NumberPadData())
    }

    required public init?(coder: NSCoder) {
        stackView = UIStackView(frame: .zero)
        super.init(coder: coder)
        addSubview(stackView)
        config(data: NumberPadData())
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

    public func config(data: PadData) {
        self.data = data
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        data.items.forEach { rowItems in
            let rowButtons = rowItems.map { item -> PadButton in
                let button = PadButton(item: item, layout: nil)
                button.addTarget(self, action: #selector(buttonPresses(button:)), for: .touchUpInside)
                return button
            }
            let rowStack = UIStackView(arrangedSubviews: rowButtons)
            rowStack.distribution = .fillEqually
            stackView.addArrangedSubview(rowStack)
        }

        applyStyle()
    }

    private func applyStyle() {
        var buttonLayout = ButtonLayout.default
        var radius: CGFloat = 16
        switch style {
        case .default:
            break
        case .plain:
            radius = 0
            break
        case let .roundedCorner(aRadius):
            radius = aRadius
        case let .customButton(layout):
            buttonLayout = layout
        case let .fullyCustom(aRadius, layout):
            radius = aRadius
            buttonLayout = layout
        }

        configView(radius: radius)

        stackView.arrangedSubviews
            .flatMap { stackView in
                return stackView.subviews
            }
            .compactMap { button in
                return button as? PadButton
            }
            .forEach { $0.config(layout: buttonLayout) }
    }

    private func configView(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    @objc
    private func buttonPresses(button: PadButton) {
        if let item = button.item {
            onButtonPressed?(item)
        }
    }
}
