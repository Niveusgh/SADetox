//
//  CustomCardView.swift
//  OCKSample
//
//  Created by Thea He on 3/30/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.

import SwiftUI
import CareKitUI
import CareKitStore

struct CustomCardView: View {
    @Environment(\.careKitStyle) var style
    @StateObject var viewModel: CustomCardViewModel
    @State var completedButtonLabel = "Mark as Completed"
    @State var completedButtonBackground: Color = .secondary

    var body: some View {
        CardView {
            VStack(alignment: .leading,
                   spacing: style.dimension.directionalInsets1.top) {
                VStack(alignment: .leading, spacing: style.dimension.directionalInsets1.top / 4.0) {
                    Text(viewModel.taskEvents.firstEventTitle)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(viewModel.taskEvents.firstTaskInstructions ?? "")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundColor(Color.primary)

                Divider()

                VStack {
                    HStack {
                        Text("Weight: ")
                            .font(Font.headline)
                    }
                    // swiftlint:disable multiple_closures_with_trailing_closure
                    HStack(alignment: .center,
                           spacing: style.dimension.directionalInsets2.trailing) {
                        Stepper(value: $viewModel.RPE,
                                in: 1...10,
                                step: 1) {
                            HStack {
                                Text("RPE: ")
                                    .font(Font.headline)
                                Text("\(viewModel.RPE)")
                                    .font(Font.title.weight(.bold))
                                    .onTapGesture {
                                        viewModel.RPE += 1
                                    }
                            }
                        }
                    }
                }
                Button(action: {
                    if completedButtonLabel == "Mark as Completed" {
                        completedButtonLabel = "Completed"
                    } else {
                        completedButtonLabel = "Mark as Completed"
                    }
                    if completedButtonBackground == .secondary {
                        completedButtonBackground = .accentColor
                    } else {
                        completedButtonBackground = .secondary
                    }

                }) {
                    Text(completedButtonLabel)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: style.appearance.cornerRadius2,
                                                     style: .continuous)
                            .fill(completedButtonBackground))
                }
            }
            .padding()
        }
        .onReceive(viewModel.$taskEvents) { taskEvents in
            viewModel.checkIfValueShouldUpdate(taskEvents)
        }
    }
}
// swiftlint:enable multiple_closures_with_trailing_closure

struct CustomCardView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCardView(viewModel: .init(storeManager: .init(wrapping: OCKStore(name: Constants.noCareStoreName,
                                                                               type: .inMemory))))
    }
}
