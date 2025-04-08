// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@Observable public final class LocalStoragePlatform: @unchecked Sendable {

    public var folders: [LocalFolder] = []

    public init() {
        try? sync()
    }

    private func sync() throws {
        let directory = URL
            .applicationSupportDirectory
        let folders = try FileManager
            .default
            .contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: [.isDirectoryKey, .contentModificationDateKey],
                options: .skipsHiddenFiles
            )
            .filter {
                (try? $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true && $0.absoluteString.contains("vault_")
            }
            .sorted(by: {
                guard let lhs = try? $0.resourceValues(forKeys: [.creationDateKey]).creationDate,
                      let rhs = try? $1.resourceValues(forKeys: [.creationDateKey]).creationDate else {
                    return false
                }
                return lhs < rhs
            })
        self.folders = folders.map {
            LocalFolder(url: $0, files: files(inFolder: $0))
        }
    }

    private func files(inFolder folder: URL) -> [LocalFile] {
        let files = try? FileManager
            .default
            .contentsOfDirectory(
                at: folder,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: .skipsHiddenFiles
            )
            .filter { (try? $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == false }
            .compactMap { LocalFile(url: $0) }
        return files ?? []
    }

    public func create(folderNamed name: String) throws -> LocalFolder {
        let url = URL
            .applicationSupportDirectory
            .appending(path: "vault_"+name)

        try FileManager
            .default
            .createDirectory(
                atPath: url.relativePath,
                withIntermediateDirectories: true
            )
        try sync()
        return LocalFolder(url: url, files: [])
    }

    public func delete(folder: LocalFolder) throws {
        try FileManager
            .default
            .removeItem(at: folder.url)
        try sync()
    }

    public func create(fileNamed name: String, inFolder folder: URL, contents: Data) throws -> LocalFile {
        let url = folder
            .appending(path: name)

        FileManager.default.createFile(atPath: url.relativePath, contents: contents)
        try sync()
        return LocalFile(url: url)
    }

    public func delete(file: LocalFile) throws {
        try FileManager
            .default
            .removeItem(at: file.url)
        try sync()
    }

}
