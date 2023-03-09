//
//  DimensionStyler.swift
//  OCKSample
//
//  Created by Thea He on 3/9/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

import Foundation

import CareKitUI
import UIKit

struct DimensionStyler: OCKDimensionStyler {
    #if os(iOS)
    var symbolPointSize3: CGFloat { 12 }
    var symbolPointSize2: CGFloat { 22 }
    var symbolPointSize1: CGFloat { 20 }

    #endif
}
