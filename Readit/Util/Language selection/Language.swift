//
//  Language.swift
//  Readit
//
//  Created by Moutaz Baaj on 07.01.25.
//

import Foundation

enum Language: String, CaseIterable {
    case english = "en-US"
    case japanese = "ja-JP"
    case french = "fr-FR"
    case german = "de-DE"
    case spanish = "es-ES"
    case italian = "it-IT"
    case chineseMandarin = "zh-CN"
    case chineseHongKong = "zh-HK"
    case chineseTaiwan = "zh-TW"
    case korean = "ko-KR"
    case arabic = "ar-SA"
    case russian = "ru-RU"
    case portugueseBrazil = "pt-BR"
    case portuguesePortugal = "pt-PT"
    case dutch = "nl-NL"
    case swedish = "sv-SE"
    case norwegian = "no-NO"
    case danish = "da-DK"
    case finnish = "fi-FI"
    case polish = "pl-PL"
    case greek = "el-GR"
    case turkish = "tr-TR"
    case thai = "th-TH"
    case hindi = "hi-IN"
    
    var displayName: String {
        switch self {
        case .english: return "English (US - English)"
        case .japanese: return "日本語 (Japanese)"
        case .french: return "Français (French)"
        case .german: return "Deutsch (German)"
        case .spanish: return "Español (Spanish)"
        case .italian: return "Italiano (Italian)"
        case .chineseMandarin: return "中文 (普通话 - Chinese Mandarin)"
        case .chineseHongKong: return "中文 (香港 - Chinese Hong Kong)"
        case .chineseTaiwan: return "中文 (台灣 - Chinese Taiwan)"
        case .korean: return "한국어 (Korean)"
        case .arabic: return "العربية (Arabic)"
        case .russian: return "Русский (Russian)"
        case .portugueseBrazil: return "Português (Brasil - Portuguese Brazil)"
        case .portuguesePortugal: return "Português (Portugal - Portuguese Portugal)"
        case .dutch: return "Nederlands (Dutch)"
        case .swedish: return "Svenska (Swedish)"
        case .norwegian: return "Norsk (Norwegian)"
        case .danish: return "Dansk (Danish)"
        case .finnish: return "Suomi (Finnish)"
        case .polish: return "Polski (Polish)"
        case .greek: return "Ελληνικά (Greek)"
        case .turkish: return "Türkçe (Turkish)"
        case .thai: return "ไทย (Thai)"
        case .hindi: return "हिंदी (Hindi)"
        }
    }
    
    var displayTag: String {
        switch self {
        case .english: return "US"
        case .japanese: return "JP"
        case .french: return "FR"
        case .german: return "DE"
        case .spanish: return "ES"
        case .italian: return "IT"
        case .chineseMandarin: return "CN"
        case .chineseHongKong: return "HK"
        case .chineseTaiwan: return "TW"
        case .korean: return "KR"
        case .arabic: return "AR"
        case .russian: return "RU"
        case .portugueseBrazil: return "BR"
        case .portuguesePortugal: return "PT"
        case .dutch: return "NL"
        case .swedish: return "SE"
        case .norwegian: return "NO"
        case .danish: return "DK"
        case .finnish: return "FI"
        case .polish: return "PL"
        case .greek: return "GR"
        case .turkish: return "TR"
        case .thai: return "TH"
        case .hindi: return "IN"
        }
    }
    
    var pageTranslation: String {
        switch self {
        case .english: return "Page"
        case .japanese: return "ページ"
        case .french: return "Page"
        case .german: return "Seite"
        case .spanish: return "Página"
        case .italian: return "Pagina"
        case .chineseMandarin, .chineseHongKong, .chineseTaiwan: return "页"
        case .korean: return "페이지"
        case .arabic: return "صفحة"
        case .russian: return "Страница"
        case .portugueseBrazil, .portuguesePortugal: return "Página"
        case .dutch: return "Pagina"
        case .swedish: return "Sida"
        case .norwegian: return "Side"
        case .danish: return "Side"
        case .finnish: return "Sivu"
        case .polish: return "Strona"
        case .greek: return "Σελίδα"
        case .turkish: return "Sayfa"
        case .thai: return "หน้า"
        case .hindi: return "पृष्ठ"
        }
    }
}
