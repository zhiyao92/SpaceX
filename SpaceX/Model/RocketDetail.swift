
import Foundation

// MARK: - RocketDetail
struct RocketDetail: Codable, Equatable {
    let height, diameter: Diameter
    let mass: Mass
    let firstStage: FirstStage
    let secondStage: SecondStage
    let engines: Engines
    let landingLegs: LandingLegs
    let payloadWeights: [PayloadWeight]
    let flickrImages: [String]
    let name, type: String
    let active: Bool
    let stages, boosters, costPerLaunch, successRatePct: Int
    let firstFlight, country, company: String
    let wikipedia: String
    let rocketDetailDescription, id: String

    enum CodingKeys: String, CodingKey {
        case height, diameter, mass
        case firstStage = "first_stage"
        case secondStage = "second_stage"
        case engines
        case landingLegs = "landing_legs"
        case payloadWeights = "payload_weights"
        case flickrImages = "flickr_images"
        case name, type, active, stages, boosters
        case costPerLaunch = "cost_per_launch"
        case successRatePct = "success_rate_pct"
        case firstFlight = "first_flight"
        case country, company, wikipedia
        case rocketDetailDescription = "description"
        case id
    }
}

extension RocketDetail {
    static func == (lhs: RocketDetail, rhs: RocketDetail) -> Bool {
        return lhs.id == rhs.id
    }
}

extension RocketDetail {
    static func initWith(id: String) -> RocketDetail {
        return RocketDetail(height: Diameter(meters: 0, feet: 0),
                            diameter: Diameter(meters: 0, feet: 0),
                            mass: Mass(kg: 2, lb: 2),
                            firstStage: FirstStage(thrustSeaLevel: Thrust(kN: 0, lbf: 0),
                                                   thrustVacuum: Thrust(kN: 0, lbf: 0),
                                                   reusable: false,
                                                   engines: 0,
                                                   fuelAmountTons: 0, burnTimeSEC: 0),
                            secondStage: SecondStage(thrust: Thrust(kN: 0, lbf: 0),
                                                     payloads: Payloads(compositeFairing: CompositeFairing(height: Diameter(meters: 0, feet: 0),
                                                                                                           diameter: Diameter(meters: 0, feet: 0)),
                                                                        option1: ""),
                                                     reusable: false,
                                                     engines: 0,
                                                     fuelAmountTons: 0,
                                                     burnTimeSEC: 0),
                            engines: Engines(isp: ISP(seaLevel: 0, vacuum: 0),
                                             thrustSeaLevel: Thrust(kN: 0, lbf: 0),
                                             thrustVacuum: Thrust(kN: 0, lbf: 0),
                                             number: 0,
                                             type: "",
                                             version: "",
                                             layout: "",
                                             engineLossMax: 0,
                                             propellant1: "",
                                             propellant2: "",
                                             thrustToWeight: 0),
                            landingLegs: LandingLegs(number: 0, material: ""),
                            payloadWeights: [],
                            flickrImages: [],
                            name: "",
                            type: "",
                            active: false,
                            stages: 0,
                            boosters: 0,
                            costPerLaunch: 0,
                            successRatePct: 0,
                            firstFlight: "",
                            country: "",
                            company: "",
                            wikipedia: "",
                            rocketDetailDescription: "",
                            id: id)
    }
}

// MARK: - Diameter
struct Diameter: Codable {
    let meters, feet: Double
}

// MARK: - Engines
struct Engines: Codable {
    let isp: ISP
    let thrustSeaLevel, thrustVacuum: Thrust
    let number: Int
    let type, version, layout: String
    let engineLossMax: Int
    let propellant1, propellant2: String
    let thrustToWeight: Double

    enum CodingKeys: String, CodingKey {
        case isp
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case number, type, version, layout
        case engineLossMax = "engine_loss_max"
        case propellant1 = "propellant_1"
        case propellant2 = "propellant_2"
        case thrustToWeight = "thrust_to_weight"
    }
}

// MARK: - ISP
struct ISP: Codable {
    let seaLevel, vacuum: Int

    enum CodingKeys: String, CodingKey {
        case seaLevel = "sea_level"
        case vacuum
    }
}

// MARK: - Thrust
struct Thrust: Codable {
    let kN, lbf: Int
}

// MARK: - FirstStage
struct FirstStage: Codable {
    let thrustSeaLevel, thrustVacuum: Thrust
    let reusable: Bool
    let engines, fuelAmountTons, burnTimeSEC: Double

    enum CodingKeys: String, CodingKey {
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case reusable, engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
    }
}

// MARK: - LandingLegs
struct LandingLegs: Codable {
    let number: Int
    let material: String?
}

// MARK: - Mass
struct Mass: Codable {
    let kg, lb: Int
}

// MARK: - PayloadWeight
struct PayloadWeight: Codable {
    let id, name: String
    let kg, lb: Int
}

// MARK: - SecondStage
struct SecondStage: Codable {
    let thrust: Thrust
    let payloads: Payloads
    let reusable: Bool
    let engines, fuelAmountTons, burnTimeSEC: Double

    enum CodingKeys: String, CodingKey {
        case thrust, payloads, reusable, engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
    }
}

// MARK: - Payloads
struct Payloads: Codable {
    let compositeFairing: CompositeFairing
    let option1: String

    enum CodingKeys: String, CodingKey {
        case compositeFairing = "composite_fairing"
        case option1 = "option_1"
    }
}

// MARK: - CompositeFairing
struct CompositeFairing: Codable {
    let height, diameter: Diameter
}
