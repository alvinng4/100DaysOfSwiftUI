import SwiftUI

struct ContentView: View
{
    var body: some View
    {
        VStack
        {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .prominentTitleStyle()
    }
}

struct prominentTitle: ViewModifier
{
    func body(content: Content) -> some View
    {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}

extension View
{
    func prominentTitleStyle() -> some View
    {
        modifier(prominentTitle())
    }
}

#Preview
{
    ContentView()
}
