//
//  S3Provider.swift
//  StoragePlatform
//
//  Created by James Wolfe on 09/11/2024.
//

import AWSMobileClientXCF

public class S3Provider: NSObject {

    private var accessKey: String?
    private var secretKey: String?
    let credentialsProvider: AWSStaticCredentialsProvider
    internal let region: S3Region

    private init(accessKey: String, secretKey: String, region: S3Region) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.region = region
        self.credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
    }

    public static func wasabi(accessKey: String, secretKey: String, region: WasabiRegion) -> S3Provider {
        return .init(accessKey: accessKey, secretKey: secretKey, region: region)
    }
}

