import SwiftUI

struct WordScrambleView: View
{
    @State private var usedWords: [String] = []
    @State private var rootWord: String = ""
    @State private var newWord: String = ""

    @State private var allWords: [String] = []

    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var showingError: Bool = false

    var body: some View
    {
        NavigationStack
        {
            List {
                Section
                {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }

                Section
                {
                    ForEach(usedWords, id: \.self)
                    { word in
                        HStack
                        {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .toolbar
            {
                Button("New Word")
                {
                    setNewWord()
                    usedWords = []
                }
            }
            .alert(errorTitle, isPresented: $showingError) { }
            message:
            {
                Text(errorMessage)
            }
        }
    }

    func addNewWord()
    {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard answer.count > 0
        else
        {
            return
        }

        guard isOriginal(word: answer)
        else
        {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }

        guard isPossible(word: answer)
        else
        {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer)
        else
        {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isLongEnough(word: answer)
        else
        {
            wordError(title: "Word too short", message: "Your word should have three or more characters!")
            return
        }
        
        guard isNotStartWord(word: answer)
        else
        {
            wordError(title: "Start word detected", message: "Try something else!")
            return
        }

        withAnimation
        {
            usedWords.insert(answer, at: 0)
        }

        newWord = ""
    }

    func startGame()
    {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt")
        {
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8)
            {
                allWords = startWords.components(separatedBy: "\n")
                setNewWord()
                return
            }
        }

        fatalError("Could not load start.txt from bundle.")
    }
    
    func setNewWord()
    {
        rootWord = allWords.randomElement() ?? "silkworm"
        return
    }

    func isOriginal(word: String) -> Bool
    {
        !usedWords.contains(word)
    }

    func isPossible(word: String) -> Bool
    {
        var tempWord = rootWord

        for letter in word
        {
            if let pos = tempWord.firstIndex(of: letter)
            {
                tempWord.remove(at: pos)
            }
            else
            {
                return false
            }
        }

        return true
    }

    func isReal(word: String) -> Bool
    {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isLongEnough(word: String) -> Bool
    {
        if (word.count < 3)
        {
            return false
        }
        return true
    }
    
    func isNotStartWord(word: String) -> Bool
    {
        if (word == rootWord)
        {
            return false
        }
        return true
    }

    func wordError(title: String, message: String)
    {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview
{
    WordScrambleView()
}
