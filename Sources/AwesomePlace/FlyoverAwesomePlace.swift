//
//  FlyoverAwesomePlace.swift
//  FlyoverKit
//
//  Created by Sven Tiigi on 22.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import CoreLocation

// MARK: - FlyoverAwesomePlace

/// Awesome 360° locations and landmarks like
/// NewYorkStatueOfLiberty, GooglePlex, SydneyOperaHouse and many more.
public enum FlyoverAwesomePlace: String, Equatable, Hashable, CaseIterable {
    // MARK: USA
    /// New York Statue of Liberty
    case newYorkStatueOfLiberty
    /// New York Manhatten
    case newYork
    /// San Francisco Golden Gate Bridge
    case sanFranciscoGoldenGateBridge
    /// New York Central Park
    case centralParkNY
    /// Google Plex
    case googlePlex
    /// Miami Beach
    case miamiBeach
    /// Laguna Beach
    case lagunaBeach
    /// Griffith Observatory
    case griffithObservatory
    /// Luxor Resort Las Vegas
    case luxorResortLasVegas
    /// Apple Headquarter
    case appleHeadquarter
    // MARK: Germany
    /// Berlin Brandenbuger Gate
    case berlinBrandenburgerGate
    /// Hamburg Townhall
    case hamburgTownHall
    /// Cologne Cathedral
    case cologneCathedral
    /// Munic Church
    case munichCurch
    /// Neuschwanstein Castle
    case neuschwansteinCastle
    /// Hamburg Elb-Philharmonic
    case hamburgElbPhilharmonic
    /// Muenster Castle
    case muensterCastle
    // MARK: Italy
    /// Colosseum Rom
    case romeColosseum
    /// Piazza Di Trevi
    case piazzaDiTrevi
    // MARK: Spain
    /// Sagrade Familia Spain
    case sagradaFamiliaSpain
    // MARK: England
    /// London Big Ben
    case londonBigBen
    /// London Eye
    case londonEye
    // MARK: Australia
    /// Opera House Sydney
    case sydneyOperaHouse
    // MARK: France
    /// Paris Eiffel Tower
    case parisEiffelTower
}

// MARK: - FlyoverAwesomePlace Flyover Extension

extension FlyoverAwesomePlace: Flyover {
    
    /// The flyover coordinate
    public var coordinate: CLLocationCoordinate2D {
        switch self {
        case .newYorkStatueOfLiberty:
            return .init(latitude: 40.689249, longitude: -74.044500)
        case .newYork:
            return .init(latitude: 40.702749, longitude: -74.014120)
        case .sanFranciscoGoldenGateBridge:
            return .init(latitude: 37.826040, longitude: -122.479448)
        case .centralParkNY:
            return .init(latitude: 40.779269, longitude: -73.963201)
        case .googlePlex:
            return .init(latitude: 37.422001, longitude: -122.084109)
        case .miamiBeach:
            return .init(latitude: 25.791007, longitude: -80.148082)
        case .lagunaBeach:
            return .init(latitude: 33.543361, longitude: -117.792315)
        case .griffithObservatory:
            return .init(latitude: 34.118536, longitude: -118.300446)
        case .luxorResortLasVegas:
            return .init(latitude: 36.095511, longitude: -115.176072)
        case .appleHeadquarter:
            return .init(latitude: 37.332100, longitude: -122.029642)
        case .berlinBrandenburgerGate:
            return .init(latitude: 52.516275, longitude: 13.377704)
        case .hamburgTownHall:
            return .init(latitude: 53.550416, longitude: 9.992527)
        case .cologneCathedral:
            return .init(latitude: 50.941278, longitude: 6.958281)
        case .munichCurch:
            return .init(latitude: 48.138631, longitude: 11.573625)
        case .neuschwansteinCastle:
            return .init(latitude: 47.557574, longitude: 10.749800)
        case .hamburgElbPhilharmonic:
            return .init(latitude: 53.541227, longitude: 9.984075)
        case .muensterCastle:
            return .init(latitude: 51.963691, longitude: 7.611546)
        case .romeColosseum:
            return .init(latitude: 41.89021, longitude: 12.492231)
        case .piazzaDiTrevi:
            return .init(latitude: 41.900865, longitude: 12.483345)
        case .sagradaFamiliaSpain:
            return .init(latitude: 41.404024, longitude: 2.174370)
        case .londonBigBen:
            return .init(latitude: 51.500729, longitude: -0.124625)
        case .londonEye:
            return .init(latitude: 51.503324, longitude: -0.119543)
        case .sydneyOperaHouse:
            return .init(latitude: -33.857197, longitude: 151.215140)
        case .parisEiffelTower:
            return .init(latitude: 48.85815, longitude: 2.29452)
        }
    }
    
}

// MARK: - FlyoverAwesomePlace iterate

public extension FlyoverAwesomePlace {
    
    /// Iterate through all FlyoverAwesomePlace cases
    ///
    /// - Returns: Iterator of the enumeration
    static func iterate() -> IndexingIterator<[FlyoverAwesomePlace]> {
        return FlyoverAwesomePlace.allCases.makeIterator()
    }
    
}
