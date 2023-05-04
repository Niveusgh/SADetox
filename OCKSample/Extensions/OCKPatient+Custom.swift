//
//  OCKPatient+Custom.swift
//  OCKSample
//
//  Created by Thea  on 12/11/22.
//  Copyright © 2022 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitStore
import ParseSwift

extension OCKPatient {
    var foodType: FoodType? {
        get {
            guard let typeString = userInfo?[Constants.foodTypeKey],
                  let type = FoodType(rawValue: typeString) else {
                return nil
            }
            return type
        }
        set {
            guard let type = newValue else {
                userInfo?.removeValue(forKey: Constants.foodTypeKey)
                return
            }
            if userInfo != nil {
                userInfo?[Constants.foodTypeKey] = type.rawValue
            } else {
                userInfo = [Constants.foodTypeKey: type.rawValue]
            }
        }
    }
}
