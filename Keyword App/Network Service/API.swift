
import Foundation

struct API {
    static let KEYSEARCH_BASE_URL   =   "https://www.keysearch.co/api"
    static let DATAFORSEO_BASE_URL  =   "https://api.dataforseo.com/v2/"
    
    static let KEYWORD_LOCATIONS        =   DATAFORSEO_BASE_URL + "cmn_locations_stat_kwrd_finder"
    static let SEARCH_VOLUME            =   DATAFORSEO_BASE_URL + "kwrd_sv"
    static let KEYWORDS_FOR_KEYWORDS    =   DATAFORSEO_BASE_URL + "kwrd_for_keywords"
    static let KEYWORDS_FOR_TERMS       =   DATAFORSEO_BASE_URL + "kwrd_finder_kwrd_for_terms"
    static let SIMILAR_KEYWORDS         =   DATAFORSEO_BASE_URL + "kwrd_finder_similar_keywords_get"
}
