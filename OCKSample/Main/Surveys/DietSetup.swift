//
//  DietSetup.swift
//  OCKSample
//
//  Created by Thea  on 12/9/22.
//  Copyright © 2022 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitStore
#if canImport(ResearchKit)
import ResearchKit
#endif

struct DietSetup: Surveyable {
    static var surveyType: Survey {
        Survey.dietSetup
    }

    static var dietTypeIdentifier: String {
        "\(Self.identifier()).dietPlanStep"
    }

    static var maxFormIdentifier: String {
        "\(Self.identifier()).form.max"
    }

    static var greensMaxIdentifier: String {
        "\(Self.identifier()).greensMax"
    }

    static var fruitMaxIdentifier: String {
        "\(Self.identifier()).fruitMax"
    }

    static var beansMaxIdentifier: String {
        "\(Self.identifier()).beansMax"
    }

}

#if canImport(ResearchKit)
extension DietSetup {
    // Select diet Plan Step
    func createSurvey() -> ORKTask {
        let textChoices = [
                    ORKTextChoice(text: "Vegan", value: "Vegan" as NSString),
                    ORKTextChoice(text: "wfpb", value: "wfpb" as NSString),
                    ORKTextChoice(text: "nutriarian", value: "nutriarian" as NSString)
                ]

        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)

        let dietPlanStep = ORKQuestionStep(
            identifier: Self.dietTypeIdentifier,
            title: "diet Type",
            question: "What type of diets will you be doing?",
            answer: answerFormat
        )

        dietPlanStep.isOptional = false

        // Enter maxes
        let maxAnswerFormat = ORKAnswerFormat.integerAnswerFormat(withUnit: "lbs")

        let greensMax = ORKFormItem(identifier: Self.greensMaxIdentifier,
                                   text: "What is your greens max?",
                                   answerFormat: maxAnswerFormat,
                                   optional: false)

        let beansMax = ORKFormItem(identifier: Self.beansMaxIdentifier,
                                   text: "What is your beans max?",
                                   answerFormat: maxAnswerFormat,
                                   optional: false)

        let fruitMax = ORKFormItem(identifier: Self.fruitMaxIdentifier,
                                   text: "What is your fruit max?",
                                   answerFormat: maxAnswerFormat,
                                   optional: false)

        let maxFormStep = ORKFormStep(
            identifier: Self.maxFormIdentifier,
            title: "Maxes",
            text: "Please input your maxes."
        )

        maxFormStep.formItems = [greensMax, beansMax, fruitMax]
        maxFormStep.isOptional = false

        let surveyTask = ORKOrderedTask(
            identifier: identifier(),
            steps: [
                dietPlanStep,
                maxFormStep
            ]
        )
        return surveyTask

    }

    func extractAnswers(_ result: ORKTaskResult) -> [OCKOutcomeValue]? {
        guard
            let typeResponse = result.results?
                .compactMap({ $0 as? ORKStepResult })
                .first(where: { $0.identifier == Self.dietTypeIdentifier }),

            let typeResults = typeResponse
                .results?.compactMap({ $0 as? ORKChoiceQuestionResult })
                .first?
                .choiceAnswers?
                .first as? String,

            let maxResponses = result.results?
                .compactMap({ $0 as? ORKStepResult })
                .first(where: { $0.identifier == Self.maxFormIdentifier }),

            let scaleResults = maxResponses
                .results?.compactMap({ $0 as? ORKNumericQuestionResult }),

            let greensMaxAnswer = scaleResults
                .first(where: { $0.identifier == Self.greensMaxIdentifier })?
                .numericAnswer,

            let beansMaxAnswer = scaleResults
                .first(where: { $0.identifier == Self.beansMaxIdentifier })?
                .numericAnswer,

            let fruitMaxAnswer = scaleResults
                .first(where: { $0.identifier == Self.fruitMaxIdentifier })?
                .numericAnswer

        else {
            assertionFailure("Failed to extract answers from check in survey!")
            return nil
        }

        var type = OCKOutcomeValue(typeResults)
        type.kind = Self.dietTypeIdentifier

        var greensMax = OCKOutcomeValue(Double(truncating: greensMaxAnswer))
        greensMax.kind = Self.greensMaxIdentifier

        var beansMax = OCKOutcomeValue(Double(truncating: beansMaxAnswer))
        beansMax.kind = Self.beansMaxIdentifier

        var fruitMax = OCKOutcomeValue(Double(truncating: fruitMaxAnswer))
        fruitMax.kind = Self.fruitMaxIdentifier

        Constants.dietSetupCompleted = true

        return [type, greensMax, beansMax, fruitMax]
    }

}
#endif
