//
//  APODMainMenuSwiftUIView.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-04-14.
//

import SwiftUI

struct APODMainMenuSwiftUIView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var selectedDay: Date = .now
    @State var selectedMonth: Date = .now
    @State var titleScale: CGFloat = 1.02
    
    var didTapButton: ((Int, Date?) -> ())
    
    let button1Text = "Ten random articles"
    let dateRangeForDaySelection: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 1995, month: 6, day: 16)
        let endDate: Date = {
            let time = Calendar.current.component(.hour, from: Date())
            if time > 7 {
                return Date()
            } else {
                return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            }
        }()
        return calendar.date(from:startComponents)!
        ...
        endDate
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("APOD")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Astronomy Picture of the Day")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .scaleEffect(titleScale)
            .onAppear{
                withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: true)) {
                    titleScale = 0.98
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 4)
            )
            .background(.black.opacity(0.5))
            .cornerRadius(10)
            
            
            Spacer()
            
            Button(button1Text) {
                didTapButton(1, nil)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(DefaultButtonStyle())
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
            )
            .background(.black.opacity(0.9))
            .cornerRadius(10)
            
            
            HStack(spacing: 0) {
                VStack{
                    Button("Article from selected day:") {
                        didTapButton(2, selectedDay)
                    }
                    .buttonStyle(DefaultButtonStyle())
                    DatePicker(
                        "Select day/month",
                        selection: $selectedDay,
                        in: dateRangeForDaySelection,
                        displayedComponents: [.date]
                    )
                    .applyTextColor(.white)
                    .tint(colorScheme == .light ? .blue : .yellow)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
            )
            .background(.black.opacity(0.9))
            .cornerRadius(10)
            
                VStack{
                    Button("Article from selected month:") {
                        didTapButton(3, selectedMonth)
                    }
                    .buttonStyle(DefaultButtonStyle())
                    DatePicker(
                        "Select day/month",
                        selection: $selectedMonth,
                        in: dateRangeForDaySelection,
                        displayedComponents: [.date]
                    )
                    .applyTextColor(.white)
                    .tint(colorScheme == .light ? .blue : .yellow)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .frame(maxWidth: .infinity)
                }
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
            )
            .background(.black.opacity(0.9))
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.black, .blue.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                APODStarsBackgroundView()
                    .opacity(0.8)
            }
        )
    }
    
}



struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.all, 8)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

