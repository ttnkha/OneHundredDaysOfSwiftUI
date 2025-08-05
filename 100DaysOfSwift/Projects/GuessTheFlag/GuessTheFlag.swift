    //
    //  GuesstheFlag.swift
    //  100DaysOfSwift
    //
    //  Created by Kha, Tran Thuy Nha on 1/7/25.
    //

import SwiftUI

struct FlagImage: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct GuessTheFlag: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var questionNumber = 1
    private let totalQuestions = 8
    
    @State private var scoreTitle = ""
    @State private var showingScore = false
    @State private var showingFinalScore = false
    
    @State private var rotationAmount = 0.0
    @State private var selectedFlag: Int? = nil
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    Text("\(questionNumber) / \(totalQuestions)")
                    
                    Text("Tap the flag of")
                        .foregroundStyle(.secondary)
                        .font(.subheadline.weight(.heavy))
                    
                    Text(countries[correctAnswer])
                        .font(.largeTitle.weight(.semibold))
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(imageName: countries[number])
                                .rotation3DEffect(.degrees(rotationAmount), axis: (x: 0, y: 1, z: 0))
                                .opacity(selectedFlag == nil || selectedFlag == number ? 1 : 0.25)
                                .scaleEffect(selectedFlag == nil || selectedFlag == number ? 1 : 0.5)
                                .animation(.default, value: selectedFlag)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("You final score is \(score)", isPresented: $showingFinalScore) {
            Button("Restart", action: resetGame)
        }
        .onAppear {
            askQuestion()
        }
    }
    
    func flagTapped(_ number: Int) {
        rotationAmount += 360
        selectedFlag = number
        
        if number == correctAnswer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                score += 1
                askQuestion()
            }
        } else {
            showingScore = true
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
        }
    }
    
    func askQuestion() {
        guard questionNumber < totalQuestions else {
            showingFinalScore = true
            return
        }
        
        selectedFlag = nil
        questionNumber += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    private func resetGame() {
        selectedFlag = nil
        score = 0
        questionNumber = 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    GuessTheFlag()
}
