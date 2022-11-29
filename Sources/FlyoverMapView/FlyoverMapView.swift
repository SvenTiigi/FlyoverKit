import MapKit

// MARK: - FlyoverMapView

/// A Flyover capable `MKMapView`
open class FlyoverMapView: MKMapView {
    
    // MARK: Properties
    
    /// The Flyover
    public private(set) lazy var flyover = Flyover(mapView: self)
    
    /// The type of data displayed by the map view.s
    open override var mapType: MKMapType {
        get {
            super.mapType
        }
        set {
            super.mapType = {
                switch newValue {
                case .satellite:
                    return .satelliteFlyover
                case .hybrid:
                    return .hybridFlyover
                default:
                    return newValue
                }
            }()
        }
    }
    
    // MARK: Initializer
    
    /// Creates a new instance of `FlyoverMapView`
    /// - Parameter frame: The frame rectangle for the view, measured in points
    public override init(
        frame: CGRect
    ) {
        super.init(frame: frame)
        #if !os(tvOS)
        self.showsCompass = false
        self.isPitchEnabled = false
        self.isRotateEnabled = false
        #endif
        self.pointOfInterestFilter = .excludingAll
        self.showsBuildings = true
        self.showsScale = false
        self.isZoomEnabled = false
        self.isScrollEnabled = false
    }
    
    /// Initializer with NSCoder is unavailable
    @available(*, unavailable, message: "Initializer with NSCoder is unavailable")
    public required init?(coder: NSCoder) { nil }
    
}

// MARK: - FlyoverMapView+init(mapType:)

public extension FlyoverMapView {
    
    /// Creates a new instance of `FlyoverMapView`
    /// - Parameter flyoverMapType: The FlyoverMapType
    convenience init(
        mapType: MKMapType
    ) {
        self.init(frame: .zero)
        self.mapType = mapType
    }
    
}

// MARK: - Is Flyover Started

public extension FlyoverMapView {
    
    /// Bool value whether Flyover is currently started or stopped
    var isFlyoverStarted: Bool {
        self.flyover.isStarted
    }
    
}

// MARK: - Start Flyover

public extension FlyoverMapView {
    
    /// Start Flyover
    /// - Parameters:
    ///   - coordinate: The Coordinate
    ///   - configuration: The Flyover Configuration. Default value `.default`
    @discardableResult
    func startFlyover(
        at coordinate: CLLocationCoordinate2D,
        configuration: Flyover.Configuration = .default
    ) -> Bool {
        self.flyover.start(
            at: coordinate,
            configuration: configuration
        )
    }
    
}

// MARK: - Resume Flyover

public extension FlyoverMapView {
    
    /// Resume Flyover with the latest coordiante and configuration, if available
    /// - Returns: A Bool value if the Flyover could be resumed
    @discardableResult
    func resumeFlyover() -> Bool {
        self.flyover.resume()
    }
    
}

// MARK: - Stop Flyover

public extension FlyoverMapView {
    
    /// Stop Flyover
    func stopFlyover() {
        self.flyover.stop()
    }
    
}
