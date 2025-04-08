//
//  SaltService.swift
//  NeoVault
//
//  Created by James Wolfe on 01/11/2024.
//

import Foundation
import CloudStoragePlatform

protocol SaltService {
    func salt() async throws -> Data
    func storeSalt(data: Data, onProgress: ((Progress?) -> Void)?) async throws
}

final class DefaultSaltService: SaltService {

    private let storage = CloudStoragePlatform(
        provider: .wasabi(
            accessKey: Configuration.wasabiKey,
            secretKey: Configuration.wasabiSecret,
            region: .euWest1
        ),
        bucket: Configuration.wasabiBucket
    )
    private let authService: any AuthenticationService

    init(authService: any AuthenticationService = DefaultAuthenticationService()) {
        self.authService = authService
    }

    func salt() async throws -> Data {
        guard let currentUserId = authService.currentUser?.uid else {
            throw AuthenticationError.unauthenticated
        }

        do {
            let saltFile = try await storage.readFile(at: "users/\(currentUserId)/salt")
            return saltFile.contents
        } catch {
            if let newSalt: Data = .randomSalt(length: 32) {
                return newSalt
            } else {
                throw error
            }
        }
    }

    func storeSalt(data: Data, onProgress: ((Progress?) -> Void)?) async throws {
        guard let currentUserId = authService.currentUser?.uid else {
            throw AuthenticationError.unauthenticated
        }

        let existing = try? await storage.readFile(at: "users/\(currentUserId)/salt")
        if existing == nil {
            _ = try await storage.createFile(
                path: "users/\(currentUserId)/salt",
                contents: data,
                contentType: "application/octet-stream",
                progress: onProgress
            )
        }
    }

}
