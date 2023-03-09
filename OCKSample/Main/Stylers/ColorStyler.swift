//
//  ColorStyler.swift
//  OCKSample
//
//  Created by Corey Baker on 10/16/21.
//  Copyright © 2021 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitUI
import UIKit

struct ColorStyler: OCKColorStyler {
    #if os(iOS)
    var label: UIColor {
        FontColorKey.defaultValue
    }

    var white: UIColor { .blue }
    var black: UIColor { .red }
    var clear: UIColor { .cyan }
    #endif
}
