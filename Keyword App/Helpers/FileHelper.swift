
import UIKit
import Photos

open class FileHelper: NSObject {
    
    /// Returns the default singleton instance.
    open class var shared: FileHelper {
        return FileHelper()
    }
    
    /// Not accessible
    private override init() {
        super.init()
    }
    
    
    /// Create a cache folder
    ///
    /// - Returns: cache directory path
    static func cacheDirectoryPath() -> URL {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return cacheDirectory
    }
    
    static func documentDirectoryPath() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory
    }
    
    static func createDirectoryIfNotExists(withName name: String) -> (Bool, Error?) {
        let directoryUrl = self.documentDirectoryPath().appendingPathComponent(name)
        if FileManager.default.fileExists(atPath: directoryUrl.path) {
            return (true, nil)
        }
        do {
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
            return (true, nil)
        } catch {
            return (false, error)
        }
    }
    
    static func createDirectoryIfNotExists(directoryUrl: URL) -> (Bool, Error?) {
        if FileManager.default.fileExists(atPath: directoryUrl.path) {
            return (true, nil)
        }
        do {
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
            return (true, nil)
        } catch {
            return (false, error)
        }
    }
    
    static func temporaryDirectoryPath() -> URL {
        let temporaryDirectory = FileManager.default.temporaryDirectory
        return temporaryDirectory
    }
    
    static func urlInDocumentsDirectory(forPath path: String) -> URL {
        return documentDirectoryPath().appendingPathComponent(path)
    }
    
    static func isFileExistsAtPath(fileURL: URL) -> Bool {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return true
        }
        return false
    }
    
    static func deleteFileAtPath(fileURL: URL) -> Bool {
        do {
            if isFileExistsAtPath(fileURL: fileURL) {
                print("file exist")
                /// try to delete the old generated video
                try FileManager.default.removeItem(at: fileURL)
                
                return true
            } else {
                return true
            }
        } catch {
            print("error = ", error)
            
            return false
        }
    }
    
    static func deleteFileAtURLs(fileURLs: [URL]) {
        for fileUrl in fileURLs {
            _ = deleteFileAtPath(fileURL: fileUrl)
        }
    }
    
    static func deleteFileAtPaths(directoryUrl: URL, fileNames: [String]) {
        for fileName in fileNames {
            let fileUrl = directoryUrl.appendingPathComponent(fileName)
            _ = deleteFileAtPath(fileURL: fileUrl)
        }
    }
}
