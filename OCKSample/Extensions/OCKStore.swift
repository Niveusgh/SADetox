//
//  OCKStore.swift
//  OCKSample
//
//  Created by Corey Baker on 1/5/22.
//  Copyright © 2022 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitStore
import Contacts
import os.log
import ParseSwift
import ParseCareKit

extension OCKStore {

    func addTasksIfNotPresent(_ tasks: [OCKTask]) async throws {
        let taskIdsToAdd = tasks.compactMap { $0.id }

        // Prepare query to see if tasks are already added
        var query = OCKTaskQuery(for: Date())
        query.ids = taskIdsToAdd

        let foundTasks = try await fetchTasks(query: query)
        var tasksNotInStore = [OCKTask]()

        // Check results to see if there's a missing task
        tasks.forEach { potentialTask in
            if foundTasks.first(where: { $0.id == potentialTask.id }) == nil {
                tasksNotInStore.append(potentialTask)
            }
        }

        // Only add if there's a new task
        if tasksNotInStore.count > 0 {
            do {
                _ = try await addTasks(tasksNotInStore)
                Logger.ockStore.info("Added tasks into OCKStore!")
            } catch {
                Logger.ockStore.error("Error adding tasks: \(error)")
            }
        }
    }

    func addContactsIfNotPresent(_ contacts: [OCKContact]) async throws {
        let contactIdsToAdd = contacts.compactMap { $0.id }

        // Prepare query to see if contacts are already added
        var query = OCKContactQuery(for: Date())
        query.ids = contactIdsToAdd

        let foundContacts = try await fetchContacts(query: query)
        var contactsNotInStore = [OCKContact]()

        // Check results to see if there's a missing task
        contacts.forEach { potential in
            if foundContacts.first(where: { $0.id == potential.id }) == nil {
                contactsNotInStore.append(potential)
            }
        }

        // Only add if there's a new task
        if contactsNotInStore.count > 0 {
            do {
                _ = try await addContacts(contactsNotInStore)
                Logger.ockStore.info("Added contacts into OCKStore!")
            } catch {
                Logger.ockStore.error("Error adding contacts: \(error)")
            }
        }
    }

    // new 05/03
    func populateCarePlans(patientUUID: UUID? = nil) async throws {
        let checkInCarePlan = OCKCarePlan(id: CarePlanID.checkIn.rawValue,
                                          title: "Check in Care Plan",
                                          patientUUID: patientUUID)
        let veganDCarePlan = OCKCarePlan(id: CarePlanID.veganD.rawValue,
                                          title: "Vegan Diet Care Plan",
                                          patientUUID: patientUUID)
        let wfpbDCarePlan = OCKCarePlan(id: CarePlanID.wfpbD.rawValue,
                                          title: "Whole Food Plant Based Diet Care Plan",
                                          patientUUID: patientUUID)
        let nutritarianDDCarePlan = OCKCarePlan(id: CarePlanID.nutritarianD.rawValue,
                                          title: "Nutritarian Diet Care Plan",
                                          patientUUID: patientUUID)
        try await AppDelegateKey
            .defaultValue?
            .storeManager
            .addCarePlansIfNotPresent([checkInCarePlan,
                                       veganDCarePlan,
                                       wfpbDCarePlan,
                                       nutritarianDDCarePlan],
                                      patientUUID: patientUUID)
    }

    @MainActor
    class func getCarePlanUUIDs() async throws -> [CarePlanID: UUID] {
        var results = [CarePlanID: UUID]()

        guard let store = AppDelegateKey.defaultValue?.store else {
            return results
        }

        var query = OCKCarePlanQuery(for: Date())
        query.ids = [CarePlanID.health.rawValue,
                     CarePlanID.checkIn.rawValue]

        let foundCarePlans = try await store.fetchCarePlans(query: query)
        // Populate the dictionary for all CarePlan's
        CarePlanID.allCases.forEach { carePlanID in
            results[carePlanID] = foundCarePlans
                .first(where: { $0.id == carePlanID.rawValue })?.uuid
        }
        return results
    }

    func addOnboardTask(_ carePlanUUID: UUID? = nil) async throws {
        let onboardSchedule = OCKSchedule.dailyAtTime(
                    hour: 0, minutes: 0,
                    start: Date(), end: nil,
                    text: "Task Due!",
                    duration: .allDay
        )

        var onboardTask = OCKTask(
            id: Onboard.identifier(),
            title: "Onboard",
            carePlanUUID: carePlanUUID,
            schedule: onboardSchedule
        )
        onboardTask.instructions = "You'll need to agree to some terms and conditions before we get started!"
        onboardTask.impactsAdherence = false
        onboardTask.card = .survey
        onboardTask.survey = .onboard

        try await addTasksIfNotPresent([onboardTask])
    }

    func addSurveyTasks(_ carePlanUUID: UUID? = nil) async throws {
        let checkInSchedule = OCKSchedule.dailyAtTime(
            hour: 8, minutes: 0,
            start: Date(), end: nil,
            text: nil
        )

        var checkInTask = OCKTask(
            id: CheckIn.identifier(),
            title: "Check In",
            carePlanUUID: carePlanUUID,
            schedule: checkInSchedule
        )
        checkInTask.card = .survey
        checkInTask.survey = .checkIn

        let thisMorning = Calendar.current.startOfDay(for: Date())

        let nextWeek = Calendar.current.date(
            byAdding: .weekOfYear,
            value: 1,
            to: Date()
        )!

        let nextMonth = Calendar.current.date(
            byAdding: .month,
            value: 1,
            to: thisMorning
        )

        let dailyElement = OCKScheduleElement(
            start: thisMorning,
            end: nextWeek,
            interval: DateComponents(day: 1),
            text: nil,
            targetValues: [],
            duration: .allDay
        )

        let weeklyElement = OCKScheduleElement(
            start: nextWeek,
            end: nextMonth,
            interval: DateComponents(weekOfYear: 1),
            text: nil,
            targetValues: [],
            duration: .allDay
        )

        let rangeOfMotionCheckSchedule = OCKSchedule(
            composing: [dailyElement, weeklyElement]
        )

        var rangeOfMotionTask = OCKTask(
            id: RangeOfMotion.identifier(),
            title: "Range Of Motion",
            carePlanUUID: carePlanUUID,
            schedule: rangeOfMotionCheckSchedule
        )
        rangeOfMotionTask.card = .survey
        rangeOfMotionTask.survey = .rangeOfMotion

        try await addTasksIfNotPresent([checkInTask, rangeOfMotionTask])
    }

    func fruit(carePlanUUIDs: [CarePlanID: UUID]) -> [OCKTask] {
        var cards: [OCKTask] = []

        MonthSchedules.generateSchedules()

        // January
        var januaryPlan = OCKTask(id: "January Plan",
                                  title: "January Plan",
                                  carePlanUUID: carePlanUUIDs[.veganD],
                                  schedule: MonthSchedules.getSchedule(forMonth: .january)!) // Use lowercase "january"
        januaryPlan.instructions = "4x6 @ 72.5%"
        januaryPlan.asset = "figure.strengthtraining.traditional"
        januaryPlan.card = .custom
        cards.append(januaryPlan)

        // April
        var aprilPlan = OCKTask(id: "April Plan",
                                title: "April Plan",
                                carePlanUUID: carePlanUUIDs[.veganD],
                                schedule: MonthSchedules.getSchedule(forMonth: .april)!) // Use lowercase "april"
        aprilPlan.instructions = "3x15"
        aprilPlan.asset = "figure.strengthtraining.traditional"
        aprilPlan.card = .custom
        cards.append(aprilPlan)

        // July
        var julyPlan = OCKTask(id: "July Plan",
                               title: "July Plan",
                               carePlanUUID: carePlanUUIDs[.veganD],
                               schedule: MonthSchedules.getSchedule(forMonth: .july)!) // Use lowercase "july"
        julyPlan.instructions = "5x3 @ 80%"
        julyPlan.asset = "figure.strengthtraining.traditional"
        julyPlan.card = .custom
        cards.append(julyPlan)

        // October
        var octoberPlan = OCKTask(id: "October Plan",
                                  title: "October Plan",
                                  carePlanUUID: carePlanUUIDs[.veganD],
                                  schedule: MonthSchedules.getSchedule(forMonth: .october)!) // Use lowercase "october"
        octoberPlan.instructions = "4x6"
        octoberPlan.asset = "figure.strengthtraining.traditional"
        octoberPlan.card = .custom
        cards.append(octoberPlan)

        return cards

    }

    func wfpb(carePlanUUIDs: [CarePlanID: UUID]) -> [OCKTask] {
        var cards: [OCKTask] = []

        MonthSchedules.generateSchedules()

        // January
        var januaryPlan = OCKTask(id: "January Plan",
                                  title: "January Plan",
                                  carePlanUUID: carePlanUUIDs[.veganD],
                                  schedule: MonthSchedules.getSchedule(forMonth: .january)!) // Use lowercase "january"
        januaryPlan.instructions = "4x6 @ 72.5%"
        januaryPlan.asset = "figure.strengthtraining.traditional"
        januaryPlan.card = .custom
        cards.append(januaryPlan)

        // April
        var aprilPlan = OCKTask(id: "April Plan",
                                title: "April Plan",
                                carePlanUUID: carePlanUUIDs[.veganD],
                                schedule: MonthSchedules.getSchedule(forMonth: .april)!) // Use lowercase "april"
        aprilPlan.instructions = "3x15"
        aprilPlan.asset = "figure.strengthtraining.traditional"
        aprilPlan.card = .custom
        cards.append(aprilPlan)

        // July
        var julyPlan = OCKTask(id: "July Plan",
                               title: "July Plan",
                               carePlanUUID: carePlanUUIDs[.veganD],
                               schedule: MonthSchedules.getSchedule(forMonth: .july)!) // Use lowercase "july"
        julyPlan.instructions = "5x3 @ 80%"
        julyPlan.asset = "figure.strengthtraining.traditional"
        julyPlan.card = .custom
        cards.append(julyPlan)

        // October
        var octoberPlan = OCKTask(id: "October Plan",
                                  title: "October Plan",
                                  carePlanUUID: carePlanUUIDs[.veganD],
                                  schedule: MonthSchedules.getSchedule(forMonth: .october)!) // Use lowercase "october"
        octoberPlan.instructions = "4x6"
        octoberPlan.asset = "figure.strengthtraining.traditional"
        octoberPlan.card = .custom
        cards.append(octoberPlan)

        return cards
    }

    func nutritarian(carePlanUUIDs: [CarePlanID: UUID]) -> [OCKTask] {
        var cards: [OCKTask] = []

        MonthSchedules.generateSchedules()

        // January
        var januaryPlan = OCKTask(id: "January Plan",
                                  title: "January Plan",
                                  carePlanUUID: carePlanUUIDs[.veganD],
                                  schedule: MonthSchedules.getSchedule(forMonth: .january)!) // Use lowercase "january"
        januaryPlan.instructions = "4x6 @ 72.5%"
        januaryPlan.asset = "figure.strengthtraining.traditional"
        januaryPlan.card = .custom
        cards.append(januaryPlan)

        // April
        var aprilPlan = OCKTask(id: "April Plan",
                                title: "April Plan",
                                carePlanUUID: carePlanUUIDs[.veganD],
                                schedule: MonthSchedules.getSchedule(forMonth: .april)!) // Use lowercase "april"
        aprilPlan.instructions = "3x15"
        aprilPlan.asset = "figure.strengthtraining.traditional"
        aprilPlan.card = .custom
        cards.append(aprilPlan)

        // July
        var julyPlan = OCKTask(id: "July Plan",
                               title: "July Plan",
                               carePlanUUID: carePlanUUIDs[.veganD],
                               schedule: MonthSchedules.getSchedule(forMonth: .july)!) // Use lowercase "july"
        julyPlan.instructions = "5x3 @ 80%"
        julyPlan.asset = "figure.strengthtraining.traditional"
        julyPlan.card = .custom
        cards.append(julyPlan)

        // October
        var octoberPlan = OCKTask(id: "October Plan",
                                  title: "October Plan",
                                  carePlanUUID: carePlanUUIDs[.veganD],
                                  schedule: MonthSchedules.getSchedule(forMonth: .october)!) // Use lowercase "october"
        octoberPlan.instructions = "4x6"
        octoberPlan.asset = "figure.strengthtraining.traditional"
        octoberPlan.card = .custom
        cards.append(octoberPlan)

        return cards
    }

    func snack(
        carePlanUUIDs: [CarePlanID: UUID],
        thisMorning: Date,
        aFewDaysAgo: Date,
        beforeBreakfast: Date
    ) -> OCKTask {
        let bar = OCKScheduleElement(
            start: beforeBreakfast,
            end: nil,
            interval: DateComponents(day: 1),
            text: "Low Intensity Cardio",
            duration: .minutes(5)
        )
        let soda = OCKScheduleElement(
            start: beforeBreakfast,
            end: nil,
            interval: DateComponents(day: 1),
            text: "Foam Roll",
            duration: .minutes(3)
        )

        let snackSchedule = OCKSchedule(composing: [bar, soda])
        var snack = OCKTask(
            id: TaskID.snack,
            title: "snack",
            carePlanUUID: nil,
            schedule: snackSchedule
        )
        snack.impactsAdherence = true
        snack.asset = "figure.rolling"
        snack.card = .checklist

        return snack
    }

    // Adds tasks and contacts into the store
    func populateSampleData(_ patientUUID: UUID? = nil) async throws {

        try await populateCarePlans(patientUUID: patientUUID)
        let carePlanUUIDs = try await Self.getCarePlanUUIDs()

        let thisMorning = Calendar.current.startOfDay(for: Date())
        let aFewDaysAgo = Calendar.current.date(byAdding: .day, value: -4, to: thisMorning)!
        let beforeBreakfast = Calendar.current.date(byAdding: .hour, value: 8, to: aFewDaysAgo)!
        let afterLunch = Calendar.current.date(byAdding: .hour, value: 14, to: aFewDaysAgo)!

        let schedule = OCKSchedule(composing: [
            OCKScheduleElement(start: beforeBreakfast,
                               end: nil,
                               interval: DateComponents(day: 1)),

            OCKScheduleElement(start: afterLunch,
                               end: nil,
                               interval: DateComponents(day: 2))
        ])

        let wfpb = wfpb(carePlanUUIDs: carePlanUUIDs)
        let snack = snack(carePlanUUIDs: carePlanUUIDs,
                            thisMorning: thisMorning,
                            aFewDaysAgo: aFewDaysAgo,
                            beforeBreakfast: beforeBreakfast)

        var tasksToAdd: [OCKTask] = []
        tasksToAdd.append(snack)
        for task in wfpb {
            tasksToAdd.append(task)
        }
        var dinner = OCKTask(id: TaskID.dinner,
                                 title: "Take dinner",
                                 carePlanUUID: nil,
                                 schedule: schedule)
        dinner.instructions = "Take 25mg (or less) dinner when you experience lunch."
        dinner.asset = "pills.fill"
        dinner.card = .button

        let lunchSchedule = OCKSchedule(composing: [
            OCKScheduleElement(start: beforeBreakfast,
                               end: nil,
                               interval: DateComponents(day: 1),
                               text: "Anytime throughout the day",
                               targetValues: [], duration: .allDay)
            ])

        var lunch = OCKTask(id: TaskID.recovery,
                             title: "Track your lunch",
                             carePlanUUID: nil,
                             schedule: lunchSchedule)
        lunch.impactsAdherence = false
        lunch.instructions = "Tap the button below anytime you experience lunch."
        lunch.asset = "bed.double"

        let waterElement = OCKScheduleElement(start: beforeBreakfast,
                                              end: nil,
                                              interval: DateComponents(day: 2))
        let waterSchedule = OCKSchedule(composing: [waterElement])
        var water = OCKTask(id: TaskID.water,
                             title: "Water intake",
                             carePlanUUID: nil,
                             schedule: waterSchedule)
        water.impactsAdherence = true
        water.instructions = "drink water"

        let sleepElement = OCKScheduleElement(start: beforeBreakfast,
                                                end: nil,
                                                interval: DateComponents(day: 1))
        let sleepSchedule = OCKSchedule(composing: [sleepElement])
        var sleep = OCKTask(id: TaskID.sleep,
                              title: "sleep",
                              carePlanUUID: nil,
                              schedule: sleepSchedule)
        sleep.impactsAdherence = true
        sleep.asset = "figure.walk"

        try await addTasksIfNotPresent([lunch, dinner, water, sleep])
        try await addOnboardTask(carePlanUUIDs[.health])
        try await addSurveyTasks(carePlanUUIDs[.checkIn])

        var contact1 = OCKContact(id: "jane",
                                  givenName: "Jane",
                                  familyName: "Daniels",
                                  carePlanUUID: nil)
        contact1.asset = "JaneDaniels"
        contact1.title = "Family Practice Doctor"
        contact1.role = "Dr. Daniels is a family practice doctor with 8 years of experience."
        contact1.emailAddresses = [OCKLabeledValue(label: CNLabelEmailiCloud, value: "janedaniels@uky.edu")]
        contact1.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(859) 257-2000")]
        contact1.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(859) 357-2040")]

        contact1.address = {
            let address = OCKPostalAddress()
            address.street = "2195 Harrodsburg Rd"
            address.city = "Lexington"
            address.state = "KY"
            address.postalCode = "40504"
            return address
        }()

        var contact2 = OCKContact(id: "matthew", givenName: "Matthew",
                                  familyName: "Reiff", carePlanUUID: nil)
        contact2.asset = "MatthewReiff"
        contact2.title = "OBGYN"
        contact2.role = "Dr. Reiff is an OBGYN with 13 years of experience."
        contact2.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(859) 257-1000")]
        contact2.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(859) 257-1234")]
        contact2.address = {
            let address = OCKPostalAddress()
            address.street = "1000 S Limestone"
            address.city = "Lexington"
            address.state = "KY"
            address.postalCode = "40536"
            return address
        }()

        try await addContactsIfNotPresent([contact1, contact2])
    }
}
