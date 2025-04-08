//
//  S3REGION.swift
//  StoragePlatform
//
//  Created by James Wolfe on 09/11/2024.
//

import Foundation
import AWSMobileClientXCF

protocol S3Region {
    var url: URL { get }
    var regionType: AWSRegionType { get }
}
