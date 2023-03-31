//
//  CustomCardViewModel.swift
//  OCKSample
//
//  Created by Thea He on 3/30/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

//
import CareKit
import CareKitStore
import Foundation

class CustomCardViewModel: CardViewModel {
    /*
     xTODO: Place any additional properties needed for your custom Card.
     Be sure to @Published them if they update your view
     */

    /// Example value
    @Published var RPE: Int = 5
    @Published var weight: Int = 0

    let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        return formatter
    }()

//    var valueForButton: String {
//
//        return "\(Int(intValue))"
//    }

    private(set) var action: (Int) async -> Void = { _ in }

    convenience init(taskID: String,
                     eventQuery: OCKEventQuery,
                     storeManager: OCKSynchronizedStoreManager) {
        self.init(storeManager: storeManager)
        setQuery(.taskIDs([taskID], eventQuery))
        self.query?.perform(using: self)
    }

    convenience init(task: OCKAnyTask,
                     eventQuery: OCKEventQuery,
                     storeManager: OCKSynchronizedStoreManager) {
        self.init(storeManager: storeManager)
        setQuery(.tasks([task], eventQuery))
        self.action = { _ in
//            do {
//                if self.taskEvents.firstEventOutcomeValues != nil {
//                    _ = try await self.appendOutcomeValue(value: value,
//                                                          at: .init(row: 0, section: 0))
//                } else {
//                    _ = try await self.saveOutcomesForEvent(atIndexPath: .init(row: 0, section: 0),
//                                                            values: [.init(value)])
//                }
//            } catch {
//                self.actionError = error
//            }
        }
        self.query?.perform(using: self)
    }

    @MainActor
    func checkIfValueShouldUpdate(_ updatedEvents: OCKTaskEvents) {

//        if let changedValue = updatedEvents.firstEventOutcomeValueInt,
//            self.RPE != changedValue {
//            self.RPE = changedValue
//        }
    }
}
