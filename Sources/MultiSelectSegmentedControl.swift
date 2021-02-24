//
//  MultiSelectSegmentedControl.swift
//  MultiSelectSegmentedControl
//
//  Created by Yonat Sharon on 2019-08-19.
//

import SweeterSwift
import UIKit

@objc public protocol MultiSelectSegmentedControlDelegate {
    func multiSelect(_ multiSelectSegmentedControl: MultiSelectSegmentedControl, didChange value: Bool, at index: Int)
}

@IBDesignable open class MultiSelectSegmentedControl: UIControl {
    @objc public weak var delegate: MultiSelectSegmentedControlDelegate?

    // MARK: - UISegmentedControl Enhancements

    /// Items shown in segments. Each item can be a `String`, a `UIImage`, or an array of strings and images.
    @objc public var items: [Any] {
        get {
            return segments
                .map { $0.contents }
                .map { $0.count == 1 ? $0[0] : $0 }
        }
        set {
            removeAllSegments()
            for item in newValue {
                let arrayItem = item as? [Any] ?? [item]
                insertSegment(contents: arrayItem)
            }
        }
    }

    /// Indexes of selected segments (can be more than one if `allowsMultipleSelection` is `true`.
    @objc public var selectedSegmentIndexes: IndexSet {
        get {
            return IndexSet(segments.enumerated().filter { $1.isSelected }.map { $0.offset })
        }
        set {
            for (i, segment) in segments.enumerated() {
                segment.isSelected = newValue.contains(i)
                showDividersBetweenSelectedSegments()
            }
        }
    }

    @objc public var selectedSegmentTitles: [String] {
        return segments.filter { $0.isSelected }.compactMap { $0.title }
    }

    /// Allow use to select multiple segments (default: `true`).
    @IBInspectable open dynamic var allowsMultipleSelection: Bool = true {
        didSet {
            if !allowsMultipleSelection {
                selectedSegmentIndex = { selectedSegmentIndex }()
            }
        }
    }

    /// Select or deselect all segments
    /// - Parameter selected: `true` to select (default), `false` to deselect.
    @objc public func selectAllSegments(_ selected: Bool = true) {
        selectedSegmentIndexes = selected ? IndexSet(0 ..< segments.count) : []
    }

    /// Add segment to the control.
    /// - Parameter contents: An array of 1 or more strings and images
    /// - Parameter index: Where to insert the segment (default: at the end)
    /// - Parameter animated: Animate the insertion (default: false)
    @objc open func insertSegment(contents: [Any], at index: Int = UISegmentedControl.noSegment, animated: Bool = false) {
        let segment = MultiSelectSegment(contents: contents, parent: self)
        segment.tintColor = tintColor
        segment.isHidden = true
        perform(animated: animated) { [stackView] in
            if index >= 0 && index < stackView.arrangedSubviews.count {
                stackView.insertArrangedSubview(segment, at: index)
                self.removeDivider(at: index - 1)
                self.insertDivider(afterSegment: index - 1)
                self.insertDivider(afterSegment: index)
            } else {
                stackView.addArrangedSubview(segment)
                self.insertDivider(afterSegment: stackView.arrangedSubviews.count - 2)
            }
            segment.isHidden = false
            self.showDividersBetweenSelectedSegments()
            self.invalidateIntrinsicContentSize()
        }
    }

    // MARK: - Appearance

    /// Width of the dividers between segments and the border around the view.
    @IBInspectable open dynamic var borderWidth: CGFloat = 1 {
        didSet {
            stackView.spacing = borderWidth
            borderView.layer.borderWidth = borderWidth
            for divider in dividers {
                constrainDividerToControl(divider: divider)
            }
            constrain(stackView, at: .left, to: borderView, diff: borderWidth)
            constrain(stackView, at: .right, to: borderView, diff: -borderWidth)
            invalidateIntrinsicContentSize()
        }
    }

    /// Corner radius of the view.
    @IBInspectable open dynamic var borderRadius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = borderRadius
            borderView.layer.cornerRadius = borderRadius
        }
    }

    /// Stack the segments vertically. (default: `false`)
    @IBInspectable open dynamic var isVertical: Bool {
        get { return stackView.axis == .vertical }
        set {
            removeAllDividers()
            stackView.axis = newValue ? .vertical : .horizontal
            DispatchQueue.main.async { // wait for new layout to take effect, to prevent auto layout error
                self.addAllDividers()
            }
            invalidateIntrinsicContentSize()
        }
    }

    /// Stack each segment contents vertically when it contains both text and image. (default: `false`)
    @IBInspectable open dynamic var isVerticalSegmentContents: Bool = false {
        didSet {
            segments.forEach { $0.updateContentsAxis() }
            invalidateIntrinsicContentSize()
        }
    }

    public dynamic var titleTextAttributes: [UIControl.State: [NSAttributedString.Key: Any]] = [:] {
        didSet {
            segments.forEach { $0.updateTitleAttributes() }
            invalidateIntrinsicContentSize()
        }
    }

    /// Configure additional properties of segments titles. For example: `multiSegment.titleConfigurationHandler = { $0.numberOfLines = 0 }`
    @objc open dynamic var titleConfigurationHandler: ((UILabel) -> Void)? {
        didSet {
            for segment in segments {
                segment.updateLabelConfiguration()
            }
            invalidateIntrinsicContentSize()
        }
    }

    /// Optional selected background color, if different than tintColor
    @IBInspectable open dynamic var selectedBackgroundColor: UIColor? {
        didSet {
            segments.forEach { $0.updateColors() }
        }
    }

    // MARK: - UISegmentedControl Compatibility

    @objc public convenience init(items: [Any]? = nil) {
        self.init(frame: .zero)
        if let items = items {
            self.items = items
        }
    }

    @objc public var selectedSegmentIndex: Int {
        get {
            return selectedSegmentIndexes.first ?? UISegmentedControl.noSegment
        }
        set {
            selectedSegmentIndexes = newValue >= 0 && newValue < segments.count ? [newValue] : []
        }
    }

    @objc public var numberOfSegments: Int {
        return segments.count
    }

    /// Use different size for each segment, depending on its content size. (default: `false`)
    @IBInspectable public dynamic var apportionsSegmentWidthsByContent: Bool {
        get { return stackView.distribution != .fillEqually }
        set {
            stackView.distribution = newValue ? .fill : .fillEqually
            invalidateIntrinsicContentSize()
        }
    }

    @objc public func setImage(_ image: UIImage?, forSegmentAt index: Int) {
        guard index >= 0 && index < segments.count else { return }
        segments[index].image = image
        invalidateIntrinsicContentSize()
    }

    @objc public func imageForSegment(at index: Int) -> UIImage? {
        guard index >= 0 && index < segments.count else { return nil }
        return segments[index].image
    }

    @objc public func setTitle(_ title: String?, forSegmentAt index: Int) {
        guard index >= 0 && index < segments.count else { return }
        segments[index].title = title
        invalidateIntrinsicContentSize()
    }

    @objc public func titleForSegment(at index: Int) -> String? {
        guard index >= 0 && index < segments.count else { return nil }
        return segments[index].title
    }

    @objc public func setTitleTextAttributes(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) {
        titleTextAttributes[state] = attributes
        invalidateIntrinsicContentSize()
    }

    @objc public func titleTextAttributes(for state: UIControl.State) -> [NSAttributedString.Key: Any]? {
        return titleTextAttributes[state]
    }

    @objc public func insertSegment(with image: UIImage, at index: Int = UISegmentedControl.noSegment, animated: Bool = false) {
        insertSegment(contents: [image], at: index, animated: animated)
    }

    @objc public func insertSegment(withTitle title: String, at index: Int = UISegmentedControl.noSegment, animated: Bool = false) {
        insertSegment(contents: [title], at: index, animated: animated)
    }

    @objc public func removeAllSegments() {
        removeAllDividers()
        stackView.removeAllArrangedSubviewsCompletely()
        invalidateIntrinsicContentSize()
    }

    @objc public func removeSegment(at index: Int, animated: Bool) {
        guard index >= 0 && index < segments.count else { return }
        let segment = segments[index]
        perform(animated: animated) {
            segment.isHidden = true
            self.removeDivider(at: index) // after removed segment
            self.removeDivider(at: index - 1) // before removed segment
        }
        perform(animated: animated) {
            self.stackView.removeArrangedSubviewCompletely(segment)
            self.insertDivider(afterSegment: index - 1) // before removed segment
            self.showDividersBetweenSelectedSegments()
            self.invalidateIntrinsicContentSize()
        }
    }

    @objc public func setEnabled(_ enabled: Bool, forSegmentAt index: Int) {
        guard index >= 0 && index < segments.count else { return }
        segments[index].isEnabled = enabled
    }

    @objc public func isEnabledForSegment(at index: Int) -> Bool {
        guard index >= 0 && index < segments.count else { return false }
        return segments[index].isEnabled
    }

    // MARK: - Overrides

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    open override var backgroundColor: UIColor? {
        didSet {
            segments.forEach { $0.updateColors() }
        }
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        let newTint = actualTintColor
        borderView.layer.borderColor = newTint.cgColor
        dividers.forEach { $0.backgroundColor = newTint }
        segments.forEach { $0.tintColor = tintColor }
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        items = ["Lorem", "Ipsum", "Sit"]
    }

    open override var intrinsicContentSize: CGSize { // to pacify Interface Builder frame calculations
        let stackViewSize = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGRect(origin: .zero, size: stackViewSize).insetBy(dx: -borderWidth, dy: -borderWidth).size
    }

    // MARK: - Internals

    public var segments: [MultiSelectSegment] {
        return stackView.arrangedSubviews.compactMap { $0 as? MultiSelectSegment }
    }

    let stackView = UIStackView()
    let borderView = UIView()
    var dividers: [UIView] = []

    private func setup() {
        addConstrainedSubview(borderView, constrain: .top, .bottom, .left, .right)
        addConstrainedSubview(stackView, constrain: .top, .bottom)
        constrain(stackView, at: .left, to: borderView, diff: 1)
        constrain(stackView, at: .right, to: borderView, diff: -1)
        clipsToBounds = true
        stackView.distribution = .fillEqually
        borderWidth = { borderWidth }()
        borderRadius = { borderRadius }()
        tintColorDidChange()
        borderView.isUserInteractionEnabled = false
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        accessibilityIdentifier = "MultiSelectSegmentedControl"
    }

    @objc open func didTap(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        guard let segment = hitTest(location, with: nil) as? MultiSelectSegment else { return }
        guard let index = segments.firstIndex(of: segment) else { return }
        perform(animated: true) {
            if self.allowsMultipleSelection {
                segment.isSelected.toggle()
                self.showDividersBetweenSelectedSegments()
            } else {
                if segment.isSelected { return }
                self.selectedSegmentIndex = index
            }
            self.sendActions(for: [.valueChanged, .primaryActionTriggered])
            self.delegate?.multiSelect(self, didChange: segment.isSelected, at: index)
        }
    }

    // MARK: - Dividers

    private func showDividersBetweenSelectedSegments() {
        for i in 0 ..< dividers.count {
            let isHidden = segments[i].isSelected && segments[i + 1].isSelected
            dividers[i].alpha = isHidden ? 0 : 1
        }
    }

    private func insertDivider(afterSegment index: Int) {
        guard index >= 0 && index < segments.count - 1 else { return }
        let segment = segments[index]
        let divider = UIView()
        divider.backgroundColor = actualTintColor
        dividers.insert(divider, at: index)
        addConstrainedSubview(divider)
        constrainDividerToControl(divider: divider)
        if isVertical {
            constrain(divider, at: .top, to: segment, at: .bottom)
            constrain(divider, at: .bottom, to: segments[index + 1], at: .top)
        } else {
            constrain(divider, at: .leading, to: segment, at: .trailing)
            constrain(divider, at: .trailing, to: segments[index + 1], at: .leading)
        }
    }

    private func removeDivider(at index: Int) {
        guard index >= 0 && index < dividers.count else { return }
        dividers[index].removeFromSuperview()
        dividers.remove(at: index)
    }

    private func removeAllDividers() {
        dividers.forEach { $0.removeFromSuperview() }
        dividers.removeAll()
    }

    private func addAllDividers() {
        guard dividers.count < segments.count else { return }
        for i in dividers.count ..< segments.count - 1 {
            insertDivider(afterSegment: i)
        }
        showDividersBetweenSelectedSegments()
    }

    private func constrainDividerToControl(divider: UIView) {
        if isVertical {
            constrain(divider, at: .left, diff: borderWidth)
            constrain(divider, at: .right, diff: -borderWidth)
        } else {
            constrain(divider, at: .top, diff: borderWidth)
            constrain(divider, at: .bottom, diff: -borderWidth)
        }
    }
}

extension UIView {
    func perform(animated: Bool, action: @escaping () -> Void) {
        if animated {
            UIView.animate(withDuration: 0.25, animations: action)
        } else {
            action()
        }
    }
}

extension UIControl.State: Hashable {}
