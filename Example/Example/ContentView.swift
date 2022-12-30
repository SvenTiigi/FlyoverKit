import FlyoverKit
import MapKit
import SwiftUI

// MARK: - ContentView

/// The ContentView
struct ContentView {
    
    /// Bool value whether Flyover is currently started or stopped
    @State
    private var isStarted = true
    
    /// Bool value if options are visible
    @State
    private var isOptionsVisible = true
    
    /// The location
    @State
    private var location: Location = .applePark
    
    /// The altitude above the ground, measured in meters
    @State
    private var altitude: Double = 2000
    
    /// The viewing angle of the camera, measured in degrees
    @State
    private var pitch: Double = 50
    
    /// The heading step of the camera
    @State
    private var headingStep: Double = 1.5
    
    /// The map type
    @State
    private var mapType: MKMapType = .standard
    
}

// MARK: - View

extension ContentView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        ZStack {
            FlyoverMap(
                isStarted: self.isStarted,
                coordinate: self.location.coordinate,
                configuration: .init(
                    altitude: .init(self.altitude),
                    pitch: .init(self.pitch),
                    heading: .increment(by: self.headingStep)
                ),
                mapType: self.mapType
            )
            .ignoresSafeArea()
            self.actionButtons
            VStack {
                Spacer()
                if self.isOptionsVisible {
                    self.options
                        .transition(
                            .opacity.combined(with: .move(edge: .bottom))
                        )
                }
            }
            .padding(.bottom, 35)
            self.statusBarOverlay
        }
        .animation(
            .spring(),
            value: self.isOptionsVisible
        )
    }
    
}

// MARK: - StatusBar Overlay

private extension ContentView {
    
    /// A statusbar overlay View
    var statusBarOverlay: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .background(.regularMaterial)
                .frame(height: geometry.safeAreaInsets.top)
                .ignoresSafeArea()
        }
    }
    
}

// MARK: - Action Buttons

private extension ContentView {
    
    /// The action buttons View
    var actionButtons: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Button {
                        self.isStarted.toggle()
                    } label: {
                        Image(
                            systemName: self.isStarted ? "pause.circle" : "play.circle"
                        )
                        .symbolRenderingMode(.hierarchical)
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .padding(5)
                        .background(.regularMaterial)
                        .cornerRadius(8)
                        .shadow(radius: 0.5)
                    }
                    Button {
                        self.isOptionsVisible.toggle()
                    } label: {
                        Image(
                            systemName: self.isOptionsVisible ? "gear.circle.fill" : "gear.circle"
                        )
                        .symbolRenderingMode(.hierarchical)
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .padding(5)
                        .background(.regularMaterial)
                        .cornerRadius(8)
                        .shadow(radius: 0.5)
                    }
                }
            }
            Spacer()
        }
        .padding(.trailing, 8)
        .padding(.top, 10)
    }
    
}

// MARK: - Options

private extension ContentView {
    
    /// An options View
    var options: some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            HStack {
                self.optionsCell(
                    title: "Map Type",
                    content: Picker(
                        "Map Type",
                        selection: self.$mapType
                    ) {
                        Text(
                            verbatim: "Standard"
                        )
                        .tag(MKMapType.standard)
                        Text(
                            verbatim: "Satellite"
                        )
                        .tag(MKMapType.satellite)
                        Text(
                            verbatim: "Hybrid"
                        )
                        .tag(MKMapType.hybrid)
                    }
                    .pickerStyle(.menu)
                )
                self.optionsCell(
                    title: "Location",
                    content: Picker(
                        "Location",
                        selection: self.$location
                    ) {
                        ForEach(
                            Location.all,
                            id: \.self
                        ) { location in
                            Text(
                                verbatim: location.name
                            )
                            .tag(location)
                        }
                    }
                    .pickerStyle(.menu)
                )
                self.optionsCell(
                    title: "Altitude",
                    content: Slider(
                        value: self.$altitude,
                        in: 0...5000,
                        label: { EmptyView() },
                        minimumValueLabel: { Text(verbatim: "") },
                        maximumValueLabel: {
                            Text(
                                verbatim: "\(Int(self.altitude))m"
                            )
                            .font(.subheadline.monospaced())
                        }
                    )
                    .frame(width: 250)
                )
                self.optionsCell(
                    title: "Pitch",
                    content: Slider(
                        value: self.$pitch,
                        in: 0...90,
                        label: { EmptyView() },
                        minimumValueLabel: { Text(verbatim: "") },
                        maximumValueLabel: {
                            Text(
                                verbatim: "\(Int(self.pitch))"
                            )
                            .font(.subheadline.monospaced())
                        }
                    )
                    .frame(width: 200)
                )
                self.optionsCell(
                    title: "Heading Step",
                    content: Slider(
                        value: self.$headingStep,
                        in: 1...10,
                        label: { EmptyView() },
                        minimumValueLabel: { Text(verbatim: "") },
                        maximumValueLabel: {
                            Text(
                                verbatim: "\(Int(self.headingStep))"
                            )
                            .font(.subheadline.monospaced())
                        }
                    )
                    .frame(width: 200)
                )
            }
            .padding(.horizontal)
        }
    }
    
    /// Options cell View
    /// - Parameters:
    ///   - title: The title
    ///   - content: The Content
    func optionsCell<Content: View>(
        title: String,
        content: Content
    ) -> some View {
        VStack(alignment: .leading) {
            Text(
                verbatim: title
            )
            .font(.title3.weight(.semibold))
            content
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(12)
        .shadow(radius: 0.5)
    }
    
}
