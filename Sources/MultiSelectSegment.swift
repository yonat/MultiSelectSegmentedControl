//
//  MultiSelectSegment.swift
//  MultiSelectSegmentedControl
//
//  Created by Yonat Sharon on 2019-08-19.
//

import SweeterSwift
import UIKit

public class MultiSelectSegment: UIView {
    weak var parent: MultiSelectSegmentedControl?

    public var contents: [Any] {
        get {
            return stackView.arrangedSubviews.compactMap {
                ($0 as? UIImageView)?.image ?? ($0 as? UILabel)?.text
            }
        }
        set {
            stackView.removeAllArrangedSubviewsCompletely()
            for contentItem in newValue {
                if let image = contentItem as? UIImage {
                    let imageView = UIImageView(image: image)
                    if #available(iOS 11.0, *) {
                        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
                    }
                    stackView.addArrangedSubview(imageView)
                } else {
                    accessibilityLabel = "\(contentItem)"
                    stackView.addArrangedSubview(UILabel(centeredText: accessibilityLabel))
                }
            }
        }
    }

    public var isSelected: Bool = false {
        didSet {
            updateColors()
            updateTitleAttributes()
            if isSelected {
                accessibilityTraits.insert(.selected)
            } else {
                accessibilityTraits.remove(.selected)
            }
        }
    }

    public var isEnabled: Bool {
        get {
            return isUserInteractionEnabled
        }
        set {
            isUserInteractionEnabled = newValue
            stackView.alpha = newValue ? 1 : 1 / 3
            updateTitleAttributes()
        }
    }

    public var image: UIImage? {
        get {
            return imageView?.image
        }
        set {
            if let imageView = imageView {
                imageView.image = newValue
            } else {
                stackView.insertArrangedSubview(UIImageView(image: newValue), at: 0)
            }
        }
    }

    public var title: String? {
        get {
            return label?.text
        }
        set {
            if let label = label {
                label.text = newValue
            } else {
                stackView.addArrangedSubview(UILabel(centeredText: newValue))
            }
            accessibilityLabel = newValue
        }
    }

    public var imageView: UIImageView? {
        return stackView.arrangedSubviews.first { $0 is UIImageView } as? UIImageView
    }

    public var label: UILabel? {
        return stackView.arrangedSubviews.first { $0 is UILabel } as? UILabel
    }

    convenience init(contents: [Any], parent: MultiSelectSegmentedControl) {
        self.init(frame: .zero)
        self.parent = parent
        self.contents = contents
        updateContentsAxis()
        updateTitleAttributes()
    }

    func updateContentsAxis() {
        stackView.axis = parent?.isVerticalSegmentContents ?? false ? .vertical : .horizontal
    }

    // MARK: - Overrides

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        updateColors()
    }

    // MARK: - Internals

    let stackView = UIStackView()

    private func setup() {
        addConstrainedSubview(stackView, constrain: .topMargin, .bottomMargin, .leftMargin, .rightMargin)
        layoutMargins = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        stackView.spacing = layoutMargins.left
        stackView.isUserInteractionEnabled = false
        stackView.alignment = .center
        isAccessibilityElement = true
        accessibilityTraits = [.button]
        accessibilityIdentifier = "MultiSelectSegment"
    }

    func updateColors() {
        let realSelectedBackgroundColor = parent?.selectedBackgroundColor ?? actualTintColor
        backgroundColor = isSelected ? realSelectedBackgroundColor : .clear
        let foregroundColor: UIColor = isSelected ? parent?.backgroundBehind ?? .background : actualTintColor
        for contentView in stackView.arrangedSubviews {
            if let label = contentView as? UILabel {
                label.textColor = foregroundColor
            } else {
                contentView.tintColor = foregroundColor
            }
        }
    }

    func updateTitleAttributes() {
        guard let titleTextAttributes = parent?.titleTextAttributes, !titleTextAttributes.isEmpty else { return }
        for label in stackView.arrangedSubviews.compactMap({ $0 as? UILabel }) {
            guard let text = label.text else { continue }
            var attributes = titleTextAttributes[.normal] ?? [:]
            if !isEnabled {
                attributes.merge(titleTextAttributes[.disabled] ?? [:]) { _, new in new }
            }
            if isSelected {
                attributes.merge(titleTextAttributes[.selected] ?? [:]) { _, new in new }
            }
            label.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
}

extension UILabel {
    convenience init(centeredText: String?) {
        self.init()
        text = centeredText
        textAlignment = .center
        font = .preferredFont(forTextStyle: .footnote)
        if #available(iOS 10.0, *) {
            adjustsFontForContentSizeCategory = true
        }
    }
}

extension UIColor {
    class var background: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
}

extension UIView {
    var backgroundBehind: UIColor? {
        if let backgroundColor = backgroundColor, backgroundColor != .clear { return backgroundColor }
        var viewBehind = superview
        while let currentViewBehind = viewBehind {
            if let coloredBackground = currentViewBehind.backgroundColor, coloredBackground != .clear {
                return coloredBackground
            }
            viewBehind = currentViewBehind.superview
        }
        return nil
    }
}
