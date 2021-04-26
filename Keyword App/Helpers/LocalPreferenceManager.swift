
import UIKit
import Photos

class LocalPreferenceManager: NSObject {
    static let shared = LocalPreferenceManager()
    
    var arrCountry = [[String: Any]]()
    var arrKeywordLocationInfo = [KeywordLocationInfo]()
    var arrSavedKeyword = [[String: Any]]()
    var arrVolumeSearchInfo = [VolumeSearchInfo]()
    
    lazy var bundlePathForCountries = Bundle.main.path(forResource: "countries", ofType: "plist")!
    lazy var bundlePathForSavedKeyword = Bundle.main.path(forResource: "saved_keywords", ofType: "plist")!
    
    override init() {
        super.init()
        preparePlistForUse()
        loadCountriesData()
        loadSavedKeywordsData()
    }
    
    var countriesPlistPath: URL {
        return FileHelper.documentDirectoryPath().appendingPathComponent("countries.plist")
    }
    
    var savedKeywordPlistPath: URL {
        return FileHelper.documentDirectoryPath().appendingPathComponent("saved_keywords.plist")
    }
    
    func preparePlistForUse() {
        if !FileHelper.isFileExistsAtPath(fileURL: countriesPlistPath) {
            do {
                try FileManager.default.copyItem(atPath: bundlePathForCountries, toPath: countriesPlistPath.path)
            } catch {
                print("Error occurred while copying file to document \(error)")
            }
        }
        
        if !FileHelper.isFileExistsAtPath(fileURL: savedKeywordPlistPath) {
            do {
                try FileManager.default.copyItem(atPath: bundlePathForSavedKeyword, toPath: savedKeywordPlistPath.path)
            } catch {
                print("Error occurred while copying file to document \(error)")
            }
        }
    }
    
    func loadCountriesData() {
        if let data = FileManager.default.contents(atPath: countriesPlistPath.path) {
            do {
                if let dataAr = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.ReadOptions.mutableContainersAndLeaves, format: nil) as? [[String: Any]] {
                    arrCountry = dataAr
                    arrKeywordLocationInfo.removeAll()
                    for i in 0..<arrCountry.count {
                        let dict = arrCountry[i]
                        let content = KeywordLocationInfo(data: dict)
                        arrKeywordLocationInfo.append(content)
                    }
                }
            } catch {
                print("Error occurred while copying file to document \(error)")
            }
        }
    }
    
    func loadSavedKeywordsData() {
        if let data = FileManager.default.contents(atPath: savedKeywordPlistPath.path) {
            do {
                if let dataAr = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.ReadOptions.mutableContainersAndLeaves, format: nil) as? [[String: Any]] {
                    arrSavedKeyword = dataAr
                    arrVolumeSearchInfo.removeAll()
                    for i in 0..<arrSavedKeyword.count {
                        let dict = arrSavedKeyword[i]
                        let content = VolumeSearchInfo(data: dict)
                        arrVolumeSearchInfo.append(content)
                    }
                }
            } catch {
                print("Error occurred while copying file to document \(error)")
            }
        }
    }
    
    func saveCountries(arrCountryData: [[String: Any]]) {
        arrCountry.removeAll()
        arrKeywordLocationInfo.removeAll()
        arrCountry.append(contentsOf: arrCountryData)
        for data in arrCountryData {
            self.arrKeywordLocationInfo.append(KeywordLocationInfo(data: data))
        }
        if let data = try? PropertyListSerialization.data(fromPropertyList: arrCountry, format: PropertyListSerialization.PropertyListFormat.binary, options: 0) {
            do {
                try data.write(to: countriesPlistPath, options: .atomic)
                print("Successfully write")
            }catch (let err){
                print(err.localizedDescription)
            }
        }
    }
    
    func isKeywordExist(keywordInfo: VolumeSearchInfo) -> (exist: Bool, index: Int) {
        for (index, info) in arrVolumeSearchInfo.enumerated() where info.key == keywordInfo.key && info.loc_id == keywordInfo.loc_id {
            return (true, index)
        }
        return (false, 0)
    }
    
    func addKeywordData(keywordInfo: VolumeSearchInfo) {
        if !isKeywordExist(keywordInfo: keywordInfo).exist {
            arrSavedKeyword.append(keywordInfo.getJson())
            arrVolumeSearchInfo.append(keywordInfo)
            if let data = try? PropertyListSerialization.data(fromPropertyList: arrSavedKeyword, format: PropertyListSerialization.PropertyListFormat.binary, options: 0) {
                do {
                    try data.write(to: savedKeywordPlistPath, options: .atomic)
                    print("Successfully write")
                }catch (let err){
                    print(err.localizedDescription)
                }
            }
        }
    }
    
    func removeKeywordFromSavedKeywordData(keywordInfo: VolumeSearchInfo) {
        let contetExistInfo = isKeywordExist(keywordInfo: keywordInfo)
        if contetExistInfo.exist {
            arrSavedKeyword.remove(at: contetExistInfo.index)
            arrVolumeSearchInfo.remove(at: contetExistInfo.index)
            
            if let data = try? PropertyListSerialization.data(fromPropertyList: arrSavedKeyword, format: PropertyListSerialization.PropertyListFormat.binary, options: 0) {
                do {
                    try data.write(to: savedKeywordPlistPath, options: .atomic)
                    print("Successfully write")
                }catch (let err){
                    print(err.localizedDescription)
                }
            }
        }
    }
}
