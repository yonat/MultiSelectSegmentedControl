//
//  MultiSegmentPicker.swift
//
//  Created by Yonat Sharon on 16/09/2019.
//

#if canImport(SwiftUI)

import SweeterSwift
import SwiftUI

/// Segmented Picker remake that supports selecting multiple segments.
@available(iOS 13.0, *) public struct MultiSegmentPicker: UIViewRepresentable {
    public typealias UIViewType = MultiSelectSegmentedControl
    private let uiView: MultiSelectSegmentedControl

    @Binding var selectedSegmentIndexes: IndexSet

    public init(
        selectedSegmentIndexes: Binding<IndexSet>,
        items: [Any],
        allowsMultipleSelection: Bool? = nil,
        borderWidth: CGFloat? = nil,
        borderRadius: CGFloat? = nil,
        isVertical: Bool? = nil,
        isVerticalSegmentContents: Bool? = nil,
        selectedBackgroundColor: UIColor? = nil
    ) {
        _selectedSegmentIndexes = selectedSegmentIndexes
        uiView = MultiSelectSegmentedControl(items: items)
        uiView.translatesAutoresizingMaskIntoConstraints = false

        uiView.allowsMultipleSelection =? allowsMultipleSelection
        uiView.borderWidth =? borderWidth
        uiView.borderRadius =? borderRadius
        uiView.isVertical =? isVertical
        uiView.isVerticalSegmentContents =? isVerticalSegmentContents
        uiView.selectedBackgroundColor =? selectedBackgroundColor
    }

    public func makeUIView(context: UIViewRepresentableContext<MultiSegmentPicker>) -> MultiSelectSegmentedControl {
        uiView.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged), for: .valueChanged)
        return uiView
    }

    public func updateUIView(_ uiView: MultiSelectSegmentedControl, context: UIViewRepresentableContext<MultiSegmentPicker>) {
        uiView.selectedSegmentIndexes = selectedSegmentIndexes
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject {
        let parent: MultiSegmentPicker

        init(_ parent: MultiSegmentPicker) {
            self.parent = parent
        }

        @objc func valueChanged(_ sender: MultiSelectSegmentedControl) {
            parent.selectedSegmentIndexes = sender.selectedSegmentIndexes
        }
    }
}

#endif
