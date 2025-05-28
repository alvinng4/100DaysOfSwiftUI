import SwiftUI

struct ContentView: View
{
    @State private var showGrid: Bool = true
    
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    var body: some View
    {
        NavigationStack
        {
            Group
            {
                if (showGrid)
                {
                    MissionGridView(astronauts: astronauts, missions: missions)
                }
                else
                {
                    MissionListView(astronauts: astronauts, missions: missions)
                }
            }
            .toolbar
            {
                Button
                {
                    showGrid.toggle()
                }
                label:
                {
                    Group
                    {
                        if (!showGrid)
                        {
                            Image(systemName: "square.grid.3x3")
                        }
                        else
                        {
                            Image(systemName: "list.bullet")
                        }
                    }.foregroundStyle(.white)
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}

struct MissionGridView: View
{
    let astronauts: [String: Astronaut]
    let missions: [Mission]
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View
    {
        ScrollView
        {
            LazyVGrid(columns: columns)
            {
                ForEach(missions)
                { mission in
                    NavigationLink
                    {
                        MissionView(mission: mission, astronauts: astronauts)
                    }
                label:
                    {
                        VStack
                        {
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                            
                            VStack
                            {
                                Text(mission.displayName)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                
                                Text(mission.formattedLaunchDate)
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.lightBackground)
                        }
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightBackground)
                        )
                    }
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct MissionListView: View
{
    let astronauts: [String: Astronaut]
    let missions: [Mission]
    
    var body: some View
    {
        ScrollView
        {
            LazyVStack
            {
                ForEach(missions)
                { mission in
                    NavigationLink
                    {
                        MissionView(mission: mission, astronauts: astronauts)
                    }
                label:
                    {
                        HStack
                        {
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                            
                            VStack
                            {
                                Text(mission.displayName)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                
                                Text(mission.formattedLaunchDate)
                                    .font(.headline)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.lightBackground)
                        }
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightBackground)
                        )
                    }
                }
            }
        }
    }
}
#Preview
{
    ContentView()
}
