//
//  MultiSegmentPickerDemo.swift
//  MultiSegmentDemo
//
//  Created by Yonat Sharon on 17/09/2019.
//  Copyright © 2019 Yonat Sharon. All rights reserved.
//

#if canImport(SwiftUI)
import MultiSelectSegmentedControl
import SwiftUI

@available(iOS 13.0, *)
struct MultiSegmentPickerDemo: View {
    @State private var selectedSegmentIndexes: IndexSet = []

    var body: some View {
        VStack(alignment: .center) {
            MultiSegmentPicker(
                selectedSegmentIndexes: $selectedSegmentIndexes,
                items: ["First", "Second", "Third", "Done"]
            )
            .fixedSize(horizontal: false, vertical: true)

            Spacer()

            MultiSegmentPicker(
                selectedSegmentIndexes: $selectedSegmentIndexes,
                // swiftlint:disable force_unwrapping
                items: [
                    [UIImage(systemName: "suit.club.fill")!, "Club"],
                    [UIImage(systemName: "suit.diamond.fill")!, "Diamond"],
                    [UIImage(systemName: "suit.heart.fill")!, "Heart"],
                    [UIImage(systemName: "suit.spade.fill")!, "Spade"],
                ]
                // swiftlint:enable force_unwrapping
            )
            .isVerticalSegmentContents(true)
            .accentColor(.purple)
            .fixedSize()

            Spacer()

            HStack {
                MultiSegmentPicker(
                    selectedSegmentIndexes: $selectedSegmentIndexes,
                    items: ["אחת", "שתיים", "ו-ש-לוש", "הסוף!"]
                )
                .isVertical(true)
                .accentColor(.green)
                .padding()

                Spacer()

                MultiSegmentPicker(
                    selectedSegmentIndexes: $selectedSegmentIndexes,
                    items: ["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing elit"]
                )
                .isVertical(true)
                .selectedBackgroundColor(.systemIndigo)
                .accentColor(.red)
                .padding()
            }
            .fixedSize()
        }
        .padding()
    }
}

#endif
