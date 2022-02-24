//
//  AddTimerView.swift
//  Timer
//
//  Created by Blanca Serrano Marfil on 16/12/21.
//

import SwiftUI

struct AddTimerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var timerViewModel: TimerViewModel
    
    var timerPassed: TimerEntity?
    
    @State var hoursSelected: String = ""
    @State var minutesSelected: String = ""
    @State var secondsSelected: String = ""
    
    @State var timerName: String = ""
    @State var categoryName: String = ""
    @State var newCategoryName: String = ""
    @State var showNewCategory: Bool = false
    
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    
    var isEditMode: Bool
    
    init(timerViewModel: TimerViewModel, timerPassed: TimerEntity?, isEditMode: Bool = false) {
        self.timerViewModel = timerViewModel
        self.timerPassed = timerPassed
        self.isEditMode = isEditMode
    }
        
    var body: some View {
        
        VStack {
            
            if isEditMode {
                HStack {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .font(.system(size: 20))
                    
                    Spacer()
                }
            }
            
            SetTimerValuesView(hoursSelected: $hoursSelected,
                               minutesSelected: $minutesSelected,
                               secondsSelected: $secondsSelected)
                .padding(30)
            
            TextFieldName(nameText: "Name", timerName: $timerName)
            
            categoryTitle
            
            if !showNewCategory {
                if !timerViewModel.timerCategories.isEmpty {
                    pickerSelection
                }
            } else {
                newCategorySection
            }
            
            Spacer()
            
            Button {
                saveTimer()
            } label: {
                Text("Save")
                    .font(.system(size: 24, weight: .medium))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 320, height: 55)
                    .background(
                        Capsule()
                            .fill(Color("Mint"))
                    )
            }
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertTitle))
        })
        .navigationTitle("New Timer")
        .onAppear() {
            if let timerToEdit = timerPassed {
                let timerDictionary = timerViewModel.getTimerValuesArray(timer: timerToEdit)
                hoursSelected = timerDictionary["h"] ?? ""
                minutesSelected = timerDictionary["m"] ?? ""
                secondsSelected = timerDictionary["s"] ?? ""
                
                timerName = timerToEdit.name ?? ""
                categoryName = timerToEdit.category?.name ?? ""
            }
        }
    }
    
    var categoryTitle: some View {
        HStack {
            Text("Category")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            
            if !isEditMode {
                Button {
                    showNewCategory.toggle()
                    newCategoryName = ""
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 50, height: 50)
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(Color("Mint"))
                }
            }
        }
        .zIndex(1)
        .padding(.horizontal, 34)
        .padding(.vertical)
    }
    
    //The picker seclection and the items iterated must have the same type.
    var pickerSelection: some View {
        Picker("Category", selection: $categoryName) {
            ForEach(timerViewModel.getCategoriesNames(), id: \.self) { category in
                Text(category)
                    .tag(category)
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, -50)
        .pickerStyle(.wheel)
    }
    
    var newCategorySection: some View {
        VStack {
            TextFieldName(nameText: "New Category", timerName: $newCategoryName)
                .padding(.bottom)
            
            HStack {
                Spacer()
                ButtonCategory(showNewCategory: $showNewCategory,
                               action: "Cancel",
                               color: "Pink")
//                ButtonCategory(showNewCategory: $showNewCategory,
//                               action: "Add",
//                               color: "LightBlue")
            }
            .padding(.horizontal, 40)
        }
    }
    
    func getTimerValue() -> Double {
        let hours = Double(hoursSelected) ?? 0
        let minutes = Double(minutesSelected) ?? 0
        let seconds = Double(secondsSelected) ?? 0
        return hours * 3600 + minutes * 60 + seconds
    }
    
    func textIsAppropiate() -> Bool {
        if getTimerValue() == 0 {
            alertTitle = "You need to set a value for the timer"
        } else if timerName == "" || timerName.count < 3 {
            alertTitle = "The timer must have a 3 characters name"
        } else if showNewCategory && (newCategoryName == "" || newCategoryName.count < 3) {
            alertTitle = "The new category must have a 3 characters name"
        } else {
            return true
        }
        
        showAlert = true
        return false
    }
    
    func saveTimer() {
        if textIsAppropiate() {
            if isEditMode {
                if let timerToEdit = timerPassed {
                    timerViewModel.deleteTimer(timer: timerToEdit)
                }
            }
            timerViewModel.addTimer(
                name: timerName,
                value: getTimerValue(),
                category: showNewCategory ? newCategoryName : categoryName
            )
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct TextFieldName: View {
    
    var nameText: String
    @Binding var timerName: String
    
    var body: some View {
        TextField(nameText, text: $timerName)
            .padding(.horizontal)
            .frame(width: 316, height: 50)
            .background(Color(.systemGray5))
            .cornerRadius(15)
            .foregroundColor(Color(.systemGray))
            .font(.title2)
    }
}

struct ButtonCategory: View {
    
    @Binding var showNewCategory: Bool
    var action: String
    var color: String
    
    var body: some View {
        Button {
            showNewCategory.toggle()
        } label: {
            Text(action)
                .font(.system(size: 20, weight: .medium))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 100, height: 40)
                .background(
                    Capsule()
                        .fill(Color(color)))
        }
    }
}

struct AddTimerView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            //AddTimerView(timerPassed: nil, isEditMode: true)
        }
    }
}
