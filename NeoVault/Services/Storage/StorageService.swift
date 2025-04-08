//
//  DefaultStorageService.swift
//  NeoVault
//
//  Created by James Wolfe on 13/11/2024.
//

import CloudStoragePlatform
import LocalStoragePlatform
import Foundation

enum StorageError: LocalizedError {
    case folderNotFound

    var errorDescription: String? {
        switch self {
        case .folderNotFound:
            return "Folder not found"
        }
    }
}

extension Notification.Name {
    static let foldersUpdated = Notification.Name("folders_updated")
}

final class DefaultStorageService {

    static let shared = DefaultStorageService(onlineEnabled: true,
                                              authService: DefaultAuthenticationService()
    )
    var folders: [FolderViewModel] = [] {
        didSet {
            NotificationCenter.default.post(name: .foldersUpdated, object: nil)
        }
    }
    private let authService: any AuthenticationService
    private let cloud = CloudStoragePlatform(
        provider: .wasabi(
            accessKey: Configuration.wasabiKey,
            secretKey: Configuration.wasabiSecret,
            region: .euWest1
        ),
        bucket: Configuration.wasabiBucket
    )
    private let local = LocalStoragePlatform()
    private let onlineEnabled: Bool

    init(onlineEnabled: Bool,
         authService: any AuthenticationService) {
        self.onlineEnabled = onlineEnabled
        self.authService = authService
        folders = local.folders
            .map { FolderViewModel(local: $0) }
    }

    private func sync(sourceOfTruth: SyncSourceOfTruth) async throws -> [LocalFolder] {
        guard let currentUserId = authService.currentUser?.uid else {
            throw AuthenticationError.unauthenticated
        }

        let localFolders = local.folders
        guard onlineEnabled else { return localFolders }
        let webFolders = try await cloud
            .readFolder(atPath: "users/\(currentUserId)/")

        switch sourceOfTruth {
        case .cloud:
            try syncFromCloudToLocal(
                localFolders: localFolders,
                webFolders: webFolders
            )
        case .local:
            try await syncFromLocalToCloud(
                localFolders: localFolders,
                webFolders: webFolders,
                currentUserId: currentUserId
            )
        }

        return local.folders
    }

    private func syncFromCloudToLocal(localFolders: [LocalFolder],
                                      webFolders: [CloudFolder]) throws {
        let webFolderNames = Set(webFolders.map { $0.name })
        for localFolder in localFolders where !webFolderNames.contains(localFolder.name) {
            try local.delete(folder: localFolder)
        }

        for webFolder in webFolders {
            var localFolder: LocalFolder! = localFolders.first { $0.name == webFolder.name }
            if localFolder == nil {
                localFolder = try local.create(folderNamed: webFolder.name)
            }

            for webFile
                    in webFolder.files
                    where localFolder.files.first(where: { $0.name == webFile.name }) == nil {
                guard let name = webFile.path.components(separatedBy: "/").last else { continue }
                _ = try local.create(fileNamed: name, inFolder: localFolder.url, contents: webFile.contents)
            }
        }
    }

    private func syncFromLocalToCloud(localFolders: [LocalFolder],
                                      webFolders: [CloudFolder],
                                      currentUserId: String) async throws {
        for webFolder in webFolders where !localFolders.contains(where: { $0.name == webFolder.name }) {
            try await cloud.delete(path: webFolder.path)
        }

        for localFolder in localFolders {
            var webFolder: CloudFolder! = webFolders.first { $0.name == localFolder.name }
            if webFolder == nil {
                webFolder = try await cloud.createFolder(
                    path: "users/\(currentUserId)/\(localFolder.name)",
                    progress: nil
                )
            }

            for localFile
                    in localFolder.files
                    where webFolder.files.first(where: { $0.name == localFile.name }) == nil {
                guard let localData = localFile.data else { continue }
                _ = try await cloud.createFile(
                    path: "\(webFolder.path)/\(localFile.name)",
                    contents: localData,
                    contentType: localFile.contentType,
                    progress: nil
                )
            }
        }
    }

}

extension DefaultStorageService: FolderService {
    func fetchFolders(sync: Bool) async throws -> [FolderViewModel] {
        if sync && onlineEnabled {
            return try await self.sync(sourceOfTruth: .cloud)
                .map { FolderViewModel(local: $0) }
        }
        return folders
    }

    func create(folderNamed name: String,
                progress: ((Progress?) -> Void)?
    ) async throws -> FolderViewModel {
        guard let currentUserId = authService.currentUser?.uid else {
            throw AuthenticationError.unauthenticated
        }

        let localFolder = try local.create(folderNamed: name)
        folders = local.folders
            .map { FolderViewModel(local: $0) }

        if onlineEnabled {
            _ = try await cloud.createFolder(
                path: "users/\(currentUserId)/\(localFolder.name)",
                progress: progress
            )
        }
        return FolderViewModel(local: localFolder)
    }

    func delete(folder: FolderViewModel) async throws {
        guard let currentUserId = authService.currentUser?.uid else {
            throw AuthenticationError.unauthenticated
        }

        guard let localFolder = local.folders.first(where: { $0.name == folder.name }) else { return }
        try local.delete(folder: localFolder)
        folders = local.folders
            .map { FolderViewModel(local: $0) }

        if onlineEnabled {
            try await cloud.delete(path: "users/\(currentUserId)/\(localFolder.name)/")
        }
    }
}

extension DefaultStorageService: FileService {
    func create(fileNamed name: String,
                inFolder folder: FolderViewModel,
                contents: Data,
                contentType: String,
                progress: ((Progress?) -> Void)?
    ) async throws -> FileViewModel {
        guard let currentUserId = authService.currentUser?.uid else {
            throw AuthenticationError.unauthenticated
        }

        guard let localFolder = local.folders.first(where: { $0.name == folder.name }) else {
            throw StorageError.folderNotFound
        }

        let localFile: LocalFile = try local.create(
            fileNamed: name,
            inFolder: localFolder.url,
            contents: contents
        )
        folders = local.folders
            .map { FolderViewModel(local: $0) }

        if onlineEnabled {
            _ = try await cloud.createFile(
                path: "users/\(currentUserId)/\(folder.name)/\(localFile.name)",
                contents: contents,
                contentType: contentType,
                progress: progress
            )
        }
        return FileViewModel(local: localFile)
    }

    func delete(file: FileViewModel) async throws {
        guard let currentUserId = authService.currentUser?.uid else {
            throw AuthenticationError.unauthenticated
        }

        let folderName = file.path.components(separatedBy: "/").dropLast().last
        guard let localFolder = local.folders.first(where: { $0.name == folderName }) else { return }
        guard let localFile = localFolder.files.first(where: { $0.name == file.name }) else { return }
        try local.delete(file: localFile)
        folders = local.folders
            .map { FolderViewModel(local: $0) }

        if onlineEnabled {
            try await cloud.delete(path: "users/\(currentUserId)/\(localFolder.name)/\(localFile.name)")
        }
    }

    func search(query: String, fileType: FileType?) async throws -> [FileViewModel] {
        folders
            .reduce(into: [FileViewModel](), { $0 += $1.files })
            .filter({
                let isQueryMatch = $0.name.lowercased().contains(query.lowercased())
                let isFileTypeMatch = $0.fileType == fileType
                return isQueryMatch || isFileTypeMatch
            })
    }
}

extension DefaultStorageService {
    enum SyncSourceOfTruth {
        case cloud
        case local
    }
}
