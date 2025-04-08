//
//  StorageService.swift
//  StoragePlatform
//
//  Created by James Wolfe on 08/11/2024.
//

import Foundation
import AWSCore
import AWSMobileClientXCF
import AWSS3

public protocol StorageService {
    func delete(path: String) async throws
}

public protocol FolderService {
    func createFolder(path: String, progress: ((Progress) -> Void)?) async throws -> CloudFolder
    func readFolder(atPath path: String) async throws -> [CloudFolder]
}

public protocol FileService {
    func createFile(path: String, contents: Data, contentType: String, progress: ((Progress) -> Void)?) async throws -> CloudFile
    func readFile(at path: String) async throws -> CloudFile
}

public final class CloudStoragePlatform {

    private let bucket: String
    private lazy var storage = AWSS3.s3(forKey: "DEFAULT_AWS_S3")

    public init(provider: S3Provider, bucket: String) {
        self.bucket = bucket
        AWSMobileClient.default().initialize { userState, error in
            if let error { fatalError(error.localizedDescription) }
            let configuration = AWSServiceConfiguration(
                region: provider.region.regionType,
                endpoint: .init(region: provider.region.regionType, service: .S3, url: provider.region.url),
                credentialsProvider: provider.credentialsProvider
            )
            if let configuration, userState != nil {
                AWSS3.register(with: configuration, forKey: "DEFAULT_AWS_S3")
            }
        }
    }
}

enum CloudStorageError: LocalizedError {
    case unknown

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

extension CloudStoragePlatform: FolderService {

    public func createFolder(path: String, progress: ((Progress) -> Void)?) async throws -> CloudFolder {
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { progress?($1) }

        guard let request = AWSS3PutObjectRequest() else { throw CloudStorageError.unknown }
        request.bucket = bucket
        request.body = Data()
        request.contentType = "application/x-directory"
        request.key = path+"/"

        do {
            try await storage
                .putObject(request)
            return CloudFolder(name: path.lastPathComponent, path: path, files: [])
        } catch {
            throw error
        }
    }

    public func readFolder(atPath path: String) async throws -> [CloudFolder] {
        guard let listRequest = AWSS3ListObjectsV2Request() else {
            throw CloudStorageError.unknown
        }
        listRequest.startAfter = path
        listRequest.bucket = bucket

        let result = try await storage.listObjectsV2(listRequest)
        let objects = result.contents ?? []
        var folders = [CloudFolder]()
        for object in objects {
            guard let key = object.key, key != path, key.contains(path) else { continue }
            let isFolder = key.last == "/"
            guard isFolder else { continue }
            let files = try await folderContents(ofFolderAtPath: key)
            let folder = CloudFolder(
                name: key.lastPathComponent.deletingPathExtension,
                path: key,
                files: files
            )
            folders.append(folder)
        }
        return folders
    }

    private func folderContents(ofFolderAtPath path: String) async throws -> [CloudFile] {
        guard let listRequest = AWSS3ListObjectsV2Request() else {
            throw CloudStorageError.unknown
        }
        listRequest.bucket = bucket

        let result = try await storage.listObjectsV2(listRequest)
        let objects = result.contents ?? []

        var files = [CloudFile]()
        for object in result.contents ?? [] {
            guard let key = object.key, key.contains(path) else { continue }
            guard key.last != "/" else { continue }
            let file = try await readFile(at: key)
            files.append(file)
        }

        return files
    }

}

extension CloudStoragePlatform: FileService {

    public func createFile(path: String, contents: Data, contentType: String, progress: ((Progress) -> Void)?) async throws -> CloudFile {
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { progress?($1) }

        guard let request = AWSS3PutObjectRequest() else { throw CloudStorageError.unknown }
        request.bucket = bucket
        request.body = contents
        request.contentLength = NSNumber(value: contents.count)
        request.contentType = contentType
        request.key = path
        request.uploadProgress = { bytesSent, totalBytesSent, totalBytesExpectedToSend in
            // Create a Progress object to track upload progress
            let uploadProgress = Progress(totalUnitCount: totalBytesExpectedToSend)
            uploadProgress.completedUnitCount = totalBytesSent

            // Call the provided progress closure with the current progress
            progress?(uploadProgress)
        }

        do {
            try await storage
                .putObject(request)
            return CloudFile(
                name: path.lastPathComponent.deletingPathExtension,
                path: path,
                contentType: contentType,
                contents: contents
            )
        } catch {
            throw error
        }
    }

    public func readFile(at path: String) async throws -> CloudFile {
        guard let objectRequest = AWSS3GetObjectRequest() else { throw CloudStorageError.unknown }
        guard let headerRequest = AWSS3HeadObjectRequest() else { throw CloudStorageError.unknown }
        objectRequest.bucket = bucket
        headerRequest.bucket = bucket
        objectRequest.key = path
        headerRequest.key = path
        let data = try await storage.object(objectRequest).body as? Data
        let headers = try await storage.headObject(headerRequest)
        guard let data, let contentType = headers.contentType else { throw CloudStorageError.unknown }
        return CloudFile(
            name: path.lastPathComponent.deletingPathExtension,
            path: path,
            contentType: contentType,
            contents: data
        )
    }

}

extension CloudStoragePlatform: StorageService {
    public func delete(path: String) async throws {
        guard let deleteRequest = AWSS3DeleteObjectRequest() else {
            throw CloudStorageError.unknown
        }
        deleteRequest.bucket = bucket
        deleteRequest.key = path

        do {
            _ = try await storage.deleteObject(deleteRequest)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
