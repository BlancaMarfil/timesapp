//
//  ListRowView.swift
//  Timer
//
//  Created by Blanca Serrano Marfil on 7/12/21.
//

import SwiftUI
import CoreData

struct ListRowView: View {
    
    let timer: TimerEntity
    
    @ObservedObject var timerViewModel = TimerViewModel()
    @State var isButtonPressed: Bool = false
    
    var body: some View {
        
        HStack {
            NavigationLink {
                TimerView(timerName: timer.name ?? "",
                          timerValue: timer.value)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            } label: {
                HStack {
                    Text("\(timer.name ?? "")")
                    Spacer()
                    Text("\(timerViewModel.getTimeString(value: timer.value))")
                        .foregroundColor(Color(.systemGray))
                }
            }
            
            
            Spacer()
            
            //We add the navigation link and the button separately because we have two navigation links in the same row
//            NavigationLink {
//                AddTimerView()
//            } label: {
//                Image(systemName: "pencil.circle.fill")
//                    .resizable()
//                    .frame(width: 25, height: 25)
//                    .foregroundColor(Color("Mint"))
//                    .padding(.leading)
//            }

//            NavigationLink("", isActive: $isButtonPressed) {
//                AddTimerView()
//            }
//
//            Button {
//                isButtonPressed.toggle()
//            } label: {
//                Image(systemName: "pencil.circle.fill")
//                    .resizable()
//                    .frame(width: 25, height: 25)
//                    .foregroundColor(Color("Mint"))
//                    .padding(.leading)
//            }
        }
        .zIndex(1)
        .font(.system(size: 17, weight: .regular))
        .padding(.vertical, 8)
        .onAppear {
            isButtonPressed = false
        }
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var viewContext = CoreDataManager.instance.container.viewContext

    static var previews: some View {
        let timer1 = TimerEntity(context: viewContext)
        timer1.name = "Chachehuito's Bread"
        timer1.value = 130
        return ListRowView(timer: timer1)
            .previewLayout(.sizeThatFits)
    }
}
