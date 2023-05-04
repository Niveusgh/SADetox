//
//  Constants.swift
//  OCKSample
//
//  Created by Corey Baker on 11/27/20.
//  Copyright © 2020 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKit
import CareKitStore
import ParseSwift

/**
 Set to **true** to sync with ParseServer, *false** to sync with iOS/watchOS.
 */
let isSyncingWithCloud = true
/**
 Set to **true** to use WCSession to notify watchOS about updates, **false** to not notify.
 A change in watchOS 9 removes the ability to use Websockets on real Apple Watches,
 preventing auto updates from the Parse Server. See the link for
 details: https://developer.apple.com/forums/thread/715024
 */
let isSendingPushUpdatesToWatch = true

enum AppError: Error {
    case couldntCast
    case couldntBeUnwrapped
    case valueNotFoundInUserInfo
    case remoteClockIDNotAvailable
    case emptyTaskEvents
    case invalidIndexPath(_ indexPath: IndexPath)
    case noOutcomeValueForEvent(_ event: OCKAnyEvent, index: Int)
    case cannotMakeOutcomeFor(_ event: OCKAnyEvent)
    case parseError(_ error: ParseError)
    case error(_ error: Error)
    case errorString(_ string: String)
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .couldntCast:
            return NSLocalizedString("OCKSampleError: Could not cast to required type.",
                                     comment: "Casting error")
        case .couldntBeUnwrapped:
            return NSLocalizedString("OCKSampleError: Could not unwrap a required type.",
                                     comment: "Unwrapping error")
        case .valueNotFoundInUserInfo:
            return NSLocalizedString("OCKSampleError: Could not find the required value in userInfo.",
                                     comment: "Value not found error")
        case .remoteClockIDNotAvailable:
            return NSLocalizedString("OCKSampleError: Could not get remote clock ID.",
                                     comment: "Value not available error")
        case .emptyTaskEvents: return "Task events is empty"
        case let .noOutcomeValueForEvent(event, index): return "Event has no outcome value at index \(index): \(event)"
        case .invalidIndexPath(let indexPath): return "Invalid index path \(indexPath)"
        case .cannotMakeOutcomeFor(let event): return "Cannot make outcome for event: \(event)"
        case .parseError(let error): return "\(error)"
        case .error(let error): return "\(error)"
        case .errorString(let string): return string
        }
    }
}

enum Constants {
    static let parseConfigFileName = "ParseCareKit"
    static let iOSParseCareStoreName = "iOSParseStore"
    static let iOSLocalCareStoreName = "iOSLocalStore"
    static let watchOSParseCareStoreName = "watchOSParseStore"
    static let watchOSLocalCareStoreName = "watchOSLocalStore"
    static let noCareStoreName = "none"
    static let parseUserSessionTokenKey = "requestParseSessionToken"
    static let requestSync = "requestSync"
    static let progressUpdate = "progressUpdate"
    static let finishedAskingForPermission = "finishedAskingForPermission"
    static let shouldRefreshView = "shouldRefreshView"
    static let userLoggedIn = "userLoggedIn"
    static let storeInitialized = "storeInitialized"
    static let userTypeKey = "userType"
    static let foodTypeKey = "foodType"
    static let card = "card"
    static let survey = "survey"
    static var dietSetupCompleted = false
}

enum MainViewPath {
    case tabs
}

enum CareKitCard: String, CaseIterable, Identifiable {
    var id: Self { self }
    case button = "Button"
    case checklist = "Checklist"
    case featured = "Featured"
    case grid = "Grid"
    case instruction = "Instruction"
    case labeledValue = "Labeled Value"
    case link = "Link"
    case numericProgress = "Numeric Progress"
    case simple = "Simple"
    case survey = "Survey"
    case custom = "Custom"
}

enum CarePlanID: String, CaseIterable, Identifiable {
    var id: Self { self }
    case health // Add custom id's for your Care Plans, these are examples
    case checkIn
    case veganD
    case wfpbD
    case nutritarianD
}

enum TaskID {
    static let lunch = "lunch"
    static let dinner = "dinner"
    static let sleep = "sleep"
    static let water = "water"
    // new added
    static let recovery = "recovery"
    static let rest = "rest"
    static let snack = "snack"
    static let fasting = "fasting"
    static let onboarding = "onboarding"
    static let checkIn = "checkIn"
    static let mealLinks = "mealLinks"
    static let vitamins = "vitamins"
    static let workoutLinks = "workoutLinks"

    static var ordered: [String] {
        [Self.checkIn,
         Self.snack,
         Self.recovery,
         Self.rest,
         Self.water,
         Self.sleep,
         Self.fasting,
         Self.mealLinks,
         Self.workoutLinks,
         Self.lunch]
    }
}

enum UserType: String, Codable {
    case patient                           = "Patient"
    case none                              = "None"

    // Return all types as an array, make sure to maintain order above
    func allTypesAsArray() -> [String] {
        return [UserType.patient.rawValue,
                UserType.none.rawValue]
    }
}

enum FoodType: String, Codable {
    case fruit
    case veggies
    case mushroom

    func allTypesAsArray() -> [String] {
        return [FoodType.fruit.rawValue,
                FoodType.veggies.rawValue,
                FoodType.mushroom.rawValue]
    }
}

enum InstallationChannel: String {
    case global
}

enum TaskType: String, CaseIterable, Identifiable {
    case task, healthKitTask
    var id: String { self.rawValue }
}

enum Month: Int, CaseIterable, Identifiable {
    case january = 1
    case february = 2
    case march = 3
    case april = 4
    case may = 5
    case june = 6
    case july = 7
    case august = 8
    case september = 9
    case october = 10
    case november = 11
    case december = 12

    var id: Int { self.rawValue }
}

enum MonthSchedules {
    private static let calendar = Calendar(identifier: .gregorian)
    private static var schedules: [OCKSchedule] = []

    static func generateSchedules() {
        for month in Month.allCases {
            let monthComponents = DateComponents(month: month.rawValue)
            if let nextDate = calendar.nextDate(after: Date(),
                                                matching: monthComponents,
                                                matchingPolicy: .nextTimePreservingSmallerComponents) {
                let yearlyElement = OCKScheduleElement(start: nextDate,
                                                       end: nil,
                                                       interval: DateComponents(year: 1))
                let schedule = OCKSchedule(composing: [yearlyElement])
                schedules.append(schedule)
            }
        }
    }

    static func getSchedule(forMonth month: Month) -> OCKSchedule? {
        return schedules[month.rawValue - 1]
    }
}
