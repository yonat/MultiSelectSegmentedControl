//
//  ViewController.swift
//  MultiSegmentDemo
//
//  Created by Yonat Sharon on 19/08/2019.
//  Copyright © 2019 Yonat Sharon. All rights reserved.
//

import MultiSelectSegmentedControl
import UIKit

class ViewController: UIViewController {
    @IBOutlet var weekControl: MultiSelectSegmentedControl!
    @IBOutlet var verticalTextControl: MultiSelectSegmentedControl!
    @IBOutlet var imagesControl: MultiSelectSegmentedControl!
    @IBOutlet var mixedControl: MultiSelectSegmentedControl!
    @IBOutlet var segmentIndexField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        weekControl.items = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        verticalTextControl.items = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
        imagesControl.items = [#imageLiteral(resourceName: "dove.png"), #imageLiteral(resourceName: "flamingo.png"), #imageLiteral(resourceName: "flying-duck.png"), #imageLiteral(resourceName: "hummingbird.png"), #imageLiteral(resourceName: "owl.png")].map { $0.withRenderingMode(.alwaysTemplate) }
        mixedControl.items = [#imageLiteral(resourceName: "european-dragon.png"), #imageLiteral(resourceName: "fenix.png"), #imageLiteral(resourceName: "swan.png"), #imageLiteral(resourceName: "budgie.png"), #imageLiteral(resourceName: "butterfly.png")].enumerated().map { [$1, $0] }

        weekControl.selectedSegmentIndexes = [4, 5, 6]

        imagesControl.selectedSegmentIndex = 3
        imagesControl.delegate = self

        mixedControl.addTarget(self, action: #selector(mixedChanged), for: .valueChanged)
    }

    @IBAction func addSegment() {
        guard let indexText = segmentIndexField.text, let index = Int(indexText) else { return }
        verticalTextControl.insertSegment(withTitle: indexText, at: index, animated: true)
    }

    @IBAction func removeSegment() {
        guard let indexText = segmentIndexField.text, let index = Int(indexText) else { return }
        verticalTextControl.removeSegment(at: index, animated: true)
    }

    @objc func mixedChanged(multiSelectSegmentedControl: MultiSelectSegmentedControl) {
        print(multiSelectSegmentedControl.selectedSegmentTitles)
    }
}

extension ViewController: MultiSelectSegmentedControlDelegate {
    func multiSelect(_ multiSelectSegmentedControl: MultiSelectSegmentedControl, didChange value: Bool, at index: Int) {
        print("\(value) at \(index)")
    }
}
