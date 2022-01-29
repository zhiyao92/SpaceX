import Foundation

typealias Rockets = [Rocket]

// MARK: - Rocket
struct Rocket: Codable {
    let fairings: Fairings?
    let links: Links
    let staticFireDateUTC: String?
    let staticFireDateUnix: Int?
    let net: Bool
    let window: Int?
    let rocket: String
    let success: Bool?
    let failures: [Failure]
    let details: String?
    let crew, ships, capsules, payloads: [String]
    let launchpad: String
    let flightNumber: Int
    let name, dateUTC: String
    let dateUnix: Int
    let dateLocal: String
    let datePrecision: DatePrecision
    let upcoming: Bool
    let cores: [Core]
    let autoUpdate, tbd: Bool
    let launchLibraryID: String?
    let id: String

    enum CodingKeys: String, CodingKey {
        case fairings, links
        case staticFireDateUTC = "static_fire_date_utc"
        case staticFireDateUnix = "static_fire_date_unix"
        case net, window, rocket, success, failures, details, crew, ships, capsules, payloads, launchpad
        case flightNumber = "flight_number"
        case name
        case dateUTC = "date_utc"
        case dateUnix = "date_unix"
        case dateLocal = "date_local"
        case datePrecision = "date_precision"
        case upcoming, cores
        case autoUpdate = "auto_update"
        case tbd
        case launchLibraryID = "launch_library_id"
        case id
    }
}

// For the purpose mocking data for Unit Test
extension Rocket {
    static func initRocketWith(title: String) -> Rocket {
        return Rocket(fairings: nil,
                      links: Links(patch: Patch(small: nil, large: nil),
                                   reddit: Reddit(campaign: nil, launch: nil, media: nil, recovery: nil),
                                   flickr: Flickr(small: [], original: []),
                                   presskit: nil,
                                   webcast: nil,
                                   youtubeID: nil,
                                   article: nil, wikipedia: nil),
                      staticFireDateUTC: nil,
                      staticFireDateUnix: nil,
                      net: false,
                      window: nil,
                      rocket: "",
                      success: nil,
                      failures: [],
                      details: nil,
                      crew: [],
                      ships: [],
                      capsules: [],
                      payloads: [],
                      launchpad: "",
                      flightNumber: 0,
                      name: title,
                      dateUTC: "",
                      dateUnix: 1,
                      dateLocal: "",
                      datePrecision: DatePrecision.day,
                      upcoming: false,
                      cores: [],
                      autoUpdate: false,
                      tbd: false,
                      launchLibraryID: nil,
                      id: "")
    }
}

// MARK: - Core
struct Core: Codable {
    let core: String?
    let flight: Int?
    let gridfins, legs, reused, landingAttempt: Bool?
    let landingSuccess: Bool?
    let landingType: LandingType?
    let landpad: String?

    enum CodingKeys: String, CodingKey {
        case core, flight, gridfins, legs, reused
        case landingAttempt = "landing_attempt"
        case landingSuccess = "landing_success"
        case landingType = "landing_type"
        case landpad
    }
}

enum LandingType: String, Codable {
    case asds = "ASDS"
    case ocean = "Ocean"
    case rtls = "RTLS"
}

//enum Landpad: String, Codable {
//    case the5E9E3032383Ecb267A34E7C7 = "5e9e3032383ecb267a34e7c7"
//    case the5E9E3032383Ecb554034E7C9 = "5e9e3032383ecb554034e7c9"
//    case the5E9E3032383Ecb6Bb234E7CA = "5e9e3032383ecb6bb234e7ca"
//    case the5E9E3032383Ecb761634E7Cb = "5e9e3032383ecb761634e7cb"
//    case the5E9E3032383Ecb90A834E7C8 = "5e9e3032383ecb90a834e7c8"
//    case the5E9E3033383Ecb075134E7CD = "5e9e3033383ecb075134e7cd"
//    case the5E9E3033383Ecbb9E534E7Cc = "5e9e3033383ecbb9e534e7cc"
//}

enum DatePrecision: String, Codable {
    case day = "day"
    case hour = "hour"
    case month = "month"
}

// MARK: - Failure
struct Failure: Codable {
    let time: Int
    let altitude: Int?
    let reason: String
}

// MARK: - Fairings
struct Fairings: Codable {
    let reused, recoveryAttempt, recovered: Bool?
    let ships: [String]

    enum CodingKeys: String, CodingKey {
        case reused
        case recoveryAttempt = "recovery_attempt"
        case recovered, ships
    }
}

//enum Launchpad: String, Codable {
//    case the5E9E4501F509094Ba4566F84 = "5e9e4501f509094ba4566f84"
//    case the5E9E4502F509092B78566F87 = "5e9e4502f509092b78566f87"
//    case the5E9E4502F509094188566F88 = "5e9e4502f509094188566f88"
//    case the5E9E4502F5090995De566F86 = "5e9e4502f5090995de566f86"
//}

// MARK: - Links
struct Links: Codable {
    let patch: Patch
    let reddit: Reddit
    let flickr: Flickr
    let presskit: String?
    let webcast: String?
    let youtubeID: String?
    let article: String?
    let wikipedia: String?

    enum CodingKeys: String, CodingKey {
        case patch, reddit, flickr, presskit, webcast
        case youtubeID = "youtube_id"
        case article, wikipedia
    }
}

// MARK: - Flickr
struct Flickr: Codable {
    let small: [String]
    let original: [String]
}

// MARK: - Patch
struct Patch: Codable {
    let small, large: String?
}

// MARK: - Reddit
struct Reddit: Codable {
    let campaign: String?
    let launch: String?
    let media, recovery: String?
}
