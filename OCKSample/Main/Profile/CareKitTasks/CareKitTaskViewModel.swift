//
//  CareKitTaskViewModel.swift
//  OCKSample
//
//  Created by Thea He on 3/30/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitStore
import os.log

class CareKitTaskViewModel: ObservableObject {
    @Published var title = ""
    @Published var instructions = ""
    @Published var selectedCard: CareKitCard = .button
    @Published var error: AppError? {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }

    // MARK: Intents
    func addTask() async {
        guard let appDelegate = AppDelegateKey.defaultValue else {
            error = AppError.couldntBeUnwrapped
            return
        }
        let uniqueId = UUID().uuidString // Create a unique id for each task
        var task = OCKTask(id: uniqueId,
                           title: title,
                           carePlanUUID: nil,
                           schedule: .dailyAtTime(hour: 0,
                                                  minutes: 0,
                                                  start: Date(),
                                                  end: nil,
                                                  text: nil))
        task.instructions = instructions
        task.card = selectedCard
        do {
            try await appDelegate.storeManager.addTasksIfNotPresent([task])
            Logger.careKitTask.info("Saved task: \(task.id, privacy: .private)")
            // Notify views they should refresh tasks if needed
            NotificationCenter.default.post(.init(name: Notification.Name(rawValue: Constants.shouldRefreshView)))
        } catch {
            self.error = AppError.errorString("Could not add task: \(error.localizedDescription)")
        }
    }

    func addHealthKitTask() async {
        guard let appDelegate = AppDelegateKey.defaultValue else {
            error = AppError.couldntBeUnwrapped
            return
        }
        let uniqueId = UUID().uuidString // Create a unique id for each task
        var healthKitTask = OCKHealthKitTask(id: uniqueId,
                                             title: title,
                                             carePlanUUID: nil,
                                             schedule: .dailyAtTime(hour: 0,
                                                                    minutes: 0,
                                                                    start: Date(),
                                                                    end: nil,
                                                                    text: nil),
                                             healthKitLinkage: .init(quantityIdentifier: .electrodermalActivity,
                                                                     quantityType: .discrete,
                                                                     unit: .count()))
        healthKitTask.instructions = instructions
        healthKitTask.card = selectedCard
        do {
            try await appDelegate.storeManager.addTasksIfNotPresent([healthKitTask])
            Logger.careKitTask.info("Saved HealthKitTask: \(healthKitTask.id, privacy: .private)")
            // Notify views they should refresh tasks if needed
            NotificationCenter.default.post(.init(name: Notification.Name(rawValue: Constants.shouldRefreshView)))
            // Ask HealthKit store for permissions after each new task
            Utility.requestHealthKitPermissions()
        } catch {
            self.error = AppError.errorString("Could not add task: \(error.localizedDescription)")
        }
    }
}
