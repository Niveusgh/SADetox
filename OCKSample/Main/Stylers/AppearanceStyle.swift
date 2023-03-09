//
//  AppearanceStyle.swift
//  OCKSample
//
//  Created by Thea He on 3/9/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitUI
import UIKit

struct AppearanceStyle: OCKAppearanceStyler {
    #if os(iOS)
    var label: UIColor {
        FontColorKey.defaultValue
    }
    var cornerRadius1: CGFloat { 5 }
    var cornerRadius2: CGFloat { 2 }

    var borderWidth1: CGFloat { 8 }

    #endif
}
