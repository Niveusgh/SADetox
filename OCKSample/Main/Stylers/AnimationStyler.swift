//
//  AnimationStyler.swift
//  OCKSample
//
//  Created by Thea He on 3/9/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitUI
import UIKit

struct AnimationStyler: OCKAnimationStyler {
    #if os(iOS)
    var stateChangeDuration: Double { 0.8 }

    #endif
}
