//
//  TimerListView.swift
//  Timer
//
//  Created by Blanca Serrano Marfil on 22/11/21.
//

import SwiftUI

struct TimerListView: View {
    
    @ObservedObject var timerViewModel = TimerViewModel()
    
    @State var isEditButtonPressed: Bool = true
    @State var isLastItem: Bool = false
    
    var body: some View {
        
        ZStack {
            if timerViewModel.timerCategories.isEmpty || isLastItem {
                VStack {
                    Spacer()
                    Text("There are not timers yet!")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(Color("Mint"))
                    Image("no_timers")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                    Spacer()
                }
            } else {
                List {
                    ForEach(timerViewModel.timerCategories, id:\.self) { category in
                        SectionView(category: category, isEditButtonPressed: $isEditButtonPressed, isLastItem: $isLastItem)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle(Text("Timers"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:
                NavigationLink {
                    AddTimerView(timerViewModel: timerViewModel, timerPassed: nil)
                } label: {
                    Image(systemName: "plus")
                    .foregroundColor(Color("Mint"))
                }
            )
        .onAppear{
            isEditButtonPressed = false
        }
    }
}

struct TimerListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TimerListView()
        }
    }
}

//It is necessary to extract subviews for the sections and rows so the binding variables work and are updated when a new timer is added.
struct SectionView: View {
    
    @ObservedObject var category: CategoryEntity
    @ObservedObject var timerViewModel = TimerViewModel()
    @Binding var isEditButtonPressed: Bool
    
    @Binding var isLastItem: Bool
    
    var body: some View {
        Section(
            header: Text("\(category.name ?? "")")
                .font(.title2)
                .foregroundColor(Color("Mint"))
        ) {
            ForEach(timerViewModel.getTimersArray(fromCategory: category), id:\.self) { timer in
                SectionListView(timer: timer, isEditButtonPressed: $isEditButtonPressed, isLastItem: $isLastItem)
            }
            
//            .onDelete { row in
//                timerViewModel.deleteTimer(category: category, timerIndex: row)
//            }
        }
    }
}

struct SectionListView: View {
    
    @ObservedObject var timer: TimerEntity
    @ObservedObject var timerViewModel = TimerViewModel()
    @Binding var isEditButtonPressed: Bool
    
    @Binding var isLastItem: Bool
    
    
    var body: some View {
        ListRowView(timer: timer)
            .swipeActions {
                
                Button {
                    isEditButtonPressed = true
                } label: {
                    Text("Edit")
                }
                .tint(Color("Mint"))
                
                Button(role: .destructive) {
                    withAnimation {
                        timerViewModel.deleteTimer(timer: timer)
                        if timerViewModel.timerCategories.isEmpty {
                            isLastItem = true
                        }
                    }
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
            }
            .sheet(isPresented: $isEditButtonPressed, content: {
                AddTimerView(timerViewModel: timerViewModel, timerPassed: timer, isEditMode: true)
            })
    }
}
