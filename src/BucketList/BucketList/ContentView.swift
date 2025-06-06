import MapKit
import SwiftUI

struct ContentView: View
{
    @State private var viewModel = ViewModel()

    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )

    var body: some View
    {
        if (viewModel.isUnlocked)
        {
            MapReader
            { proxy in
                VStack
                {
                    Map(initialPosition: startPosition)
                    {
                        ForEach(viewModel.locations)
                        { location in
                            Annotation(location.name, coordinate: location.coordinate)
                            {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture(minimumDuration: 0.2)
                                    {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(viewModel.mapStyleIsStandard ? .standard : .hybrid)
                    .onTapGesture
                    { position in
                        if let coordinate = proxy.convert(position, from: .local)
                        {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace)
                    { place in
                        EditView(location: place)
                        {
                            viewModel.update(location: $0)
                        }
                    }
                    
                    Button("Switch to \(viewModel.mapStyleIsStandard ? "hybrid" : "standard")")
                    {
                        viewModel.changeMapStyle()
                    }
                }
            }
        }
        else
        {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
                .alert(isPresented: $viewModel.showAlert)
                {
                    Alert(
                        title: Text("Authentication error"),
                        message: Text(viewModel.alertMsg)
                    )
                }
        }
    }
}

#Preview
{
    ContentView()
}
