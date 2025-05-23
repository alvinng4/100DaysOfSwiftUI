import SwiftUI

// Project 3 Challenge 2
struct FlagImage: View
{
    let country: String
    var body: some View
    {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct GuessTheFlagView: View
{
    @State private var countries: [String] = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer: Int = Int.random(in: 0...2)

    @State private var showingAlert: Bool = false
    @State private var alertMessage: String? = nil
    @State private var scoreTitle: String = ""
    @State private var score: Int = 0
    @State private var numQuestionsShowed: Int = 0

    var body: some View {
        ZStack
        {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()

            VStack
            {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                VStack(spacing: 15)
                {
                    VStack
                    {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3)
                    { idx in
                        Button
                        {
                            flagTapped(idx)
                        }
                        label:
                        {
                            FlagImage(country: countries[idx])
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
        .alert(scoreTitle, isPresented: $showingAlert)
        {
            if (numQuestionsShowed < 8)
            {
                Button("Continue", action: askQuestion)
            }
            else
            {
                Button("Restart", action: restart)
            }
        }
        message:
        {
            if (numQuestionsShowed < 8)
            {
                if (alertMessage != nil)
                {
                    Text(alertMessage!)
                }
            }
            else
            {
                Text("Your final score is \(score).")
            }
        }
    }

    func flagTapped(_ idx: Int)
    {
        if (idx == correctAnswer)
        {
            scoreTitle = "Correct"
            alertMessage = nil
            score += 1
        }
        else
        {
            scoreTitle = "Wrong"
            alertMessage = "That's the flag of \(countries[idx])"
            score -= 1
        }
        showingAlert = true
        numQuestionsShowed += 1
    }

    func askQuestion()
    {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restart()
    {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        score = 0
        numQuestionsShowed = 0
    }
}

#Preview
{
    GuessTheFlagView()
}
