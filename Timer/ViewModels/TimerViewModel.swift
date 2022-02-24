//
//  TimerViewModel.swift
//  Timer
//
//  Created by Blanca Serrano Marfil on 8/12/21.
//

import Foundation
import CoreData
import SwiftUI

class TimerViewModel: ObservableObject {
    
    let manager = CoreDataManager.instance
    
    @Published var timerCategories: [CategoryEntity] = []
    
    init() {
        getCategories()
    }
    
    func getCategories() {
        let request = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
        
        let sort = NSSortDescriptor(keyPath: \CategoryEntity.name, ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            timerCategories = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching timer categories. \(error.localizedDescription)")
        }
    }
    
    func save() {
        manager.save()
        getCategories()
    }
    
    //MARK: - Category Functions
    
    func getTimersArray(fromCategory category: CategoryEntity) -> [TimerEntity] {
        var timers = category.timers?.allObjects as? [TimerEntity] ?? []
        timers.sort { $0.name ?? "" < $1.name ?? "" }
        return timers
    }
    
    func addCategory(for name: String) {
        let category = CategoryEntity(context: manager.context)
        category.name = name
        save()
    }
    
    func getCategory(categoryName: String) -> CategoryEntity? {
        for category in timerCategories {
            if category.name == categoryName {
                return category
            }
        }
        return nil
    }
    
    func getCategoriesNames() -> [String] {
        var categoriesNames: [String] = []
        for category in timerCategories {
            categoriesNames.append(category.name ?? "")
        }
        return categoriesNames
    }
    
    func deleteCategory(offset: IndexSet) {
        let categoryToDelete = timerCategories[offset.first!]
        deleteCategory(category: categoryToDelete)
    }
    
    func deleteCategory(category: CategoryEntity) {
        manager.context.delete(category)
        save()
    }
    
    
    //MARK: - Timer Functions
    
//    func initNilTimer() -> TimerEntity {
//
//        let timerEntity = TimerEntity(context: manager.context)
//        timerEntity.name = ""
//        timerEntity.value = 0
//
//        let categoryEntity = CategoryEntity(context: manager.context)
//        categoryEntity.name = ""
//        timerEntity.category = categoryEntity
//
//        return timerEntity
//    }
    
    func addTimer(name: String, value: Double, category: String) {
        
        let timerEntity = TimerEntity(context: manager.context)
        timerEntity.name = name
        timerEntity.value = value
        
        if let categoryFound = getCategory(categoryName: category) {
            timerEntity.category = categoryFound
        } else {
            let categoryEntity = CategoryEntity(context: manager.context)
            categoryEntity.name = category
            timerEntity.category = categoryEntity
        }
        
        save()
    }
    
    func deleteTimer(category: CategoryEntity, timerIndex: IndexSet) {
        let timersArray = getTimersArray(fromCategory: category)
        let timerToDelete = timersArray[timerIndex.first!]
        deleteTimer(timer: timerToDelete)
        
        checkSizeCategory(category: category)
    }
    
    func checkSizeCategory(category: CategoryEntity?) {
        if let categoryExpected = category {
            if getTimersArray(fromCategory: categoryExpected).count == 1 {
                deleteCategory(category: categoryExpected)
            }
        }
    }
    
    func deleteTimer(timer: TimerEntity) {
        checkSizeCategory(category: timer.category)
        manager.context.delete(timer)
        
        
//        let timerEntity = TimerEntity(context: manager.context)
//        timerEntity.name = "Prueba"
//        timerEntity.value = 32
//        let categoryEntity = CategoryEntity(context: manager.context)
//        categoryEntity.name = "CatPruieba"
//        categoryEntity.timers = [timerEntity]
//        timerCategories.append(categoryEntity)
        
        
        save()
    }
    
    func getTimerFormatter() -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }
    
    func getPaddingString(stringValue: String) -> String {
        return String(String(stringValue.reversed()).padding(toLength: 2, withPad: "0", startingAt: 0).reversed())
    }
    
    func getTimerValuesArray(timer: TimerEntity) -> [String: String] {
        var returnDictionary: [String: String] = [:]
        
        let formatter = getTimerFormatter()
        formatter.zeroFormattingBehavior = .pad
        let timerString = formatter.string(from: timer.value) ?? "00:00:00"
        
        let array = timerString.split(separator: " ").map { String($0) }
        returnDictionary["h"] = getPaddingString(stringValue: array[0].replacingOccurrences(of: "h", with: ""))
        returnDictionary["m"] = getPaddingString(stringValue: array[1].replacingOccurrences(of: "m", with: ""))
        returnDictionary["s"] = getPaddingString(stringValue: array[2].replacingOccurrences(of: "s", with: ""))
        return returnDictionary

    }
    
    func getTimeString(value: Double) -> String {
        let formatter = getTimerFormatter()
        return formatter.string(from: value) ?? "00:00:00"
    }
}

