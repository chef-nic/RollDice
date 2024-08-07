//
//  ContentView.swift
//  RollDice
//
//  Created by Nicholas Johnson on 8/6/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var previousRolls: [Roll]
    @State private var result: Int = 0
    @AppStorage("sides") private var sides: Int = 6
    @AppStorage("numberOfDice") private var numberOfDice: Int = 8
    @State private var diceArray: [Int] = [1, 1, 1, 1, 1, 1, 1, 1]
    private var dieOptions: [Int] = [4, 6, 8, 10, 12, 20, 100]
    let columns: [GridItem] = [
        .init(.adaptive(minimum: 60))
    ]
    
    @State private var timer: Timer?
    @State private var timerCount = 5
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section {
                    Stepper("Number of Dice: \(numberOfDice)", value: $numberOfDice, in: 1...100)
                        .onChange(of: numberOfDice) { oldValue, newValue in
                            diceArray = Array(repeating: 1, count: newValue)
                        }
                    
                    Picker("Number of sides:", selection: $sides) {
                        ForEach(dieOptions, id: \.self) {
                            Text("\($0) sides")
                        }
                    }
                } footer: {
                    LazyVGrid(columns: columns) {
                        ForEach(diceArray.indices, id: \.self) { index in
                            Text("\(diceArray[index])")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundStyle(.black)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: 10))
                                .shadow(radius: 3)
                                .font(.title)
                                .padding(5)
                        }
                    }
                }
                
                Text("You rolled: \(result)")

                Button("Roll Dice") {
                    startRolling()
                }
                .sensoryFeedback(.impact, trigger: result)
                
                Section("Previous Rolls") {
                    ForEach(previousRolls.reversed()) { roll in
                        Text("\(roll.result)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Roll Dice")
        }
    }
    
    func startRolling() {
        timerCount = 5
        timer?.invalidate()  // Invalidate any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            if timerCount > 0 {
                rollDice()
                timerCount -= 1
            } else {
                timer?.invalidate()
                saveRoll()
            }
        }
    }
    
    func rollDice() {
        result = 0
        for index in 0..<diceArray.count {
            let roll = Int.random(in: 1...sides)
            diceArray[index] = roll
            result += roll
        }
    }
    
    func saveRoll() {
        let newRoll = Roll(result: result)
        modelContext.insert(newRoll)
        try? modelContext.save()
    }
}

#Preview {
    ContentView()
}
