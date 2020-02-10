//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Vegesna, Vijay V EX1 on 2/8/20.
//  Copyright © 2020 Vegesna, Vijay V EX1. All rights reserved.
//

import SwiftUI

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
        .clipShape(Capsule()).overlay(Capsule().stroke(Color.black, lineWidth: 1))
        .shadow(color: .black, radius: 2)
    }
}

extension View {
    func setFlagView() -> some View {
        self.modifier(FlagImage())
    }
}

struct ContentView: View {
    
   @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var scoreTitle = ""
    @State private var showingScore = false
    @State private var myScore = 0
    @State private var tappedIndex = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach (0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number]).renderingMode(.original)
                        .setFlagView()
                    }
                    
                }
                HStack {
                    Text("Your Score:")
                        .foregroundColor(.white)
                    Text("\(myScore)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("That's the flag of \(countries[tappedIndex])"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
                })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            myScore += 10
            tappedIndex = correctAnswer
        } else {
            tappedIndex = number
            scoreTitle = "Wrong"
            myScore -= 10
            if myScore < 0 {
                myScore = 0
            }
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
