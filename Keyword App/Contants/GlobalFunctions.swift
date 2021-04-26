
import Foundation
import AVKit
import MediaPlayer

func delay(time: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
        closure()
    }
}

func DLog(_ items: Any?..., function: String = #function, file: String = #file, line: Int = #line) {
    if Utility.shared.enableLog {
        print("-----------START-------------")
        let url = NSURL(fileURLWithPath: file)
        print("Message = ", items, "\n\n(File: ", url.lastPathComponent ?? "nil", ", Function: ", function, ", Line: ", line, ")")
        print("-----------END-------------\n")
    }
}

func previewImageFromVideo(url: URL) -> UIImage? {
    let url = url
    let request = URLRequest(url: url)
    let cache = URLCache.shared
    
    if
        let cachedResponse = cache.cachedResponse(for: request),
        let image = UIImage(data: cachedResponse.data)
    {
        return image
    }
    
    let asset = AVAsset(url: url)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    imageGenerator.maximumSize = CGSize(width: 250, height: 120)
    
    var time = asset.duration
    time.value = min(time.value, 2)
    
    var image: UIImage?
    
    do {
        let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
        image = UIImage(cgImage: cgImage)
    } catch { }
    
    if
        let image = image,
        let data = image.pngData(),
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
    {
        let cachedResponse = CachedURLResponse(response: response, data: data)
        
        cache.storeCachedResponse(cachedResponse, for: request)
    }
    
    return image
}

func thumbnailForVideoAtURL(url: String) -> UIImage? {
    
    let asset = AVAsset(url: URL(string: url)!)
    let assetImageGenerator = AVAssetImageGenerator(asset: asset)
    
    var time = asset.duration
    time.value = min(time.value, 2)
    
    do {
        let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
        return UIImage(cgImage: imageRef)
    } catch {
        print("error")
        return nil
    }
}

//VideoConvertToMP4
func encodeVideo(at videoURL: URL, completionHandler: ((URL?, Error?) -> Void)?) {
    let avAsset = AVURLAsset(url: videoURL, options: nil)
    
    let startDate = Date()
    
    //Create Export session
    guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
        completionHandler?(nil, nil)
        return
    }
    
    //Creating temp path to save the converted video
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
    let filePath = documentsDirectory.appendingPathComponent("Video_\(datePresentString()).mp4")
    
    //Check if the file already exists then remove the previous file
    if FileManager.default.fileExists(atPath: filePath.path) {
        do {
            try FileManager.default.removeItem(at: filePath)
        } catch {
            completionHandler?(nil, error)
        }
    }
    
    exportSession.outputURL = filePath
    exportSession.outputFileType = AVFileType.mp4
    exportSession.shouldOptimizeForNetworkUse = true
    let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
    let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
    exportSession.timeRange = range
    
    exportSession.exportAsynchronously(completionHandler: {() -> Void in
        switch exportSession.status {
        case .failed:
            print(exportSession.error ?? "NO ERROR")
            completionHandler?(nil, exportSession.error)
        case .cancelled:
            print("Export canceled")
            completionHandler?(nil, nil)
        case .completed:
            //Video conversion finished
            let endDate = Date()
            
            let time = endDate.timeIntervalSince(startDate)
            print(time)
            print("Successful!")
            print(exportSession.outputURL ?? "NO OUTPUT URL")
            completionHandler?(exportSession.outputURL, nil)
            
        default: break
        }
    })
}

func datePresentString() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
    dateFormatter.calendar = Calendar(identifier: .iso8601)
    dateFormatter.locale = enUSPosixLocale
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
    
    let iso8601String = dateFormatter.string(from: date as Date)
    
    return iso8601String
}

func converVideoUrlToData(StrUrl: String) -> Data {
    var videoData = Data()
    
    do
    {
       videoData = try Data(contentsOf:  URL(string: StrUrl)!, options: .mappedIfSafe)
    } catch let error {
        print(error.localizedDescription)
    }
    
    return videoData
}

func videoURLShare(url: URL) -> URL {
    var videoLink: URL?
    let urlData = try? Data(contentsOf: url)
    
    if ((urlData) != nil) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDirectory = paths[0]
        let filePath = "\(docDirectory)/Video.mp4"
        //urlData?.write(to: URL(string: filePath)!)
        
        // file saved
        videoLink = URL(fileURLWithPath: filePath)
    }
    
    return videoLink!
}

/*func getIndexHasImages(of key: String, for value: String, in dictionary : [HasImages]?) -> Int {
    var count = 0
    for dictElement in dictionary! {
        if dictElement.img_url != nil {
            if (dictElement.img_url?.contains(value))! && dictElement.img_url == value {
                return count
            } else {
                count += 1
            }
        } else {
            if (dictElement.image_path?.contains(value))! {
                return count
            }
        }
    }
    return -1
}*/
