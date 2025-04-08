//
//  WasabiRegion.swift
//  StoragePlatform
//
//  Created by James Wolfe on 09/11/2024.
//

import Foundation
import AWSMobileClientXCF

public enum WasabiRegion: S3Region {
    case usEast1
    case usEast2
    case usWest1
    case caCentral1
    case euCentral1
    case euWest1
    case euWest2
    case euSouth1
    case apNorthEast1
    case apNorthEast2
    case apSouthEast1
    case apSouthEast2

    var url: URL {
        switch self {
        case .usEast1:
            return URL(string: "https://s3.us-east-1.wasabisys.com")!
        case .usEast2:
            return URL(string: "https://s3.us-east-2.wasabisys.com")!
        case .usWest1:
            return URL(string: "https://s3.us-west-1.wasabisys.com")!
        case .caCentral1:
            return URL(string: "https://s3.ca-central-1.wasabisys.com")!
        case .euCentral1:
            return URL(string: "https://s3.eu-central-1.wasabisys.com")!
        case .euWest1:
            return URL(string: "https://s3.uk-1.wasabisys.com")!
        case .euWest2:
            return URL(string: "https://s3.eu-west-2.wasabisys.com")!
        case .euSouth1:
            return URL(string: "https://s3.eu-south-1.wasabisys.com")!
        case .apNorthEast1:
            return URL(string: "https://s3.ap-northeast-1.wasabisys.com")!
        case .apNorthEast2:
            return URL(string: "https://s3.ap-notheast-2.wasabisys.com")!
        case .apSouthEast1:
            return URL(string: "https://s3.ap-southwest-1.wasabisys.com")!
        case .apSouthEast2:
            return URL(string: "https://s3.ap-southwest-2.wasabisys.com")!
        }
    }

    var regionType: AWSRegionType {
        switch self {
        case .usEast1:
            return .USEast1
        case .usEast2:
            return .USEast2
        case .usWest1:
            return .USWest1
        case .caCentral1:
            return .CACentral1
        case .euCentral1:
            return .EUCentral1
        case .euWest1:
            return .EUWest1
        case .euWest2:
            return .EUWest2
        case .euSouth1:
            return .EUSouth1
        case .apNorthEast1:
            return .APNortheast1
        case .apNorthEast2:
            return .APNortheast2
        case .apSouthEast1:
            return .APSoutheast1
        case .apSouthEast2:
            return .APSoutheast2
        }
    }
}
