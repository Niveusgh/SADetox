//
//  ProfileView.swift
//  OCKSample
//
//  Created by Corey Baker on 11/24/20.
//  Copyright © 2020 Network Reconnaissance Lab. All rights reserved.
//

import SwiftUI
import CareKitUI
import CareKitStore
import CareKit
import os.log

struct ProfileView: View {
    @EnvironmentObject private var appDelegate: AppDelegate
    @StateObject var viewModel = ProfileViewModel()
    @ObservedObject var loginViewModel: LoginViewModel
    @State var firstName = ""
    @State var lastName = ""
    @State var birthday = Date()
    @State var isPresentingAddTask = true

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    TextField("First Name", text: $firstName)
                        .padding()
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)

                    TextField("Last Name", text: $lastName)
                        .padding()
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)

                    DatePicker("Birthday", selection: $birthday, displayedComponents: [DatePickerComponents.date])
                        .padding()
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }

                Button(action: {
                    Task {
                        do {
                            try await viewModel.saveProfile(firstName,
                                                            last: lastName,
                                                            birth: birthday)
                        } catch {
                            Logger.profile.error("Error saving profile: \(error)")
                        }
                    }
                }, label: {
                    Text("Save Profile")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                })
                .background(Color(.magenta))
                .cornerRadius(15)

                Button(action: {
                    Task {
                        await loginViewModel.logout()
                    }
                }, label: {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                })
                .background(Color(.cyan))
                .cornerRadius(15)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        viewModel.isPresentingAddTask = true
//                    }, label: {
//                        Text("My Contact")
//                    })
                }
                ToolbarItemGroup {
                    Button(action: {
                        viewModel.showAddTaskView = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                    Button(action: {
                        viewModel.showDeleteTaskView = true
                    }, label: {
                        Image(systemName: "trash.fill")
                    })
                }
            }
            .onReceive(viewModel.$patient) { patient in
                if let currentFirstName = patient?.name.givenName {
                    firstName = currentFirstName
                }
                if let currentLastName = patient?.name.familyName {
                    lastName = currentLastName
                }
                if let currentBirthday = patient?.birthday {
                    birthday = currentBirthday
                }
            }.onReceive(appDelegate.$storeManager) { newStoreManager in
                viewModel.updateStoreManager(newStoreManager)
            }.onReceive(appDelegate.$isFirstTimeLogin) { _ in
                viewModel.updateStoreManager()
            }.overlay(DeleteTaskView(showDeleteTaskView: self.$viewModel.showDeleteTaskView))
                .overlay(AddTaskView(showAddTaskView: self.$viewModel.showAddTaskView))
        }

    }
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView(viewModel: .init(storeManager: Utility.createPreviewStoreManager()),
                        loginViewModel: .init())
            .accentColor(Color(TintColorKey.defaultValue))
        }
    }
}
