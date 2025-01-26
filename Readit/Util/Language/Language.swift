//
//  Language.swift
//  Readit
//
//  Created by Moutaz Baaj on 07.01.25.
//

import Foundation

enum Language: String, CaseIterable {
    // English Variants
    case englishUS = "en-US"
    case englishUK = "en-GB"
    case englishAustralia = "en-AU"
    case englishIndia = "en-IN"
    case englishSouthAfrica = "en-ZA"
    
    // French Variants
    case frenchFrance = "fr-FR"
    case frenchCanada = "fr-CA"
    
    // Spanish Variants
    case spanishSpain = "es-ES"
    case spanishMexico = "es-MX"
    
    // Portuguese Variants
    case portugueseBrazil = "pt-BR"
    case portuguesePortugal = "pt-PT"
    
    // Chinese Variants
    case chineseMandarin = "zh-CN"
    case chineseHongKong = "zh-HK"
    case chineseTaiwan = "zh-TW"
    
    // Other Languages
    case germanGermany = "de-DE"
    case japanese = "ja-JP"
    case korean = "ko-KR"
    case arabic = "ar-001"
    case russian = "ru-RU"
    case dutch = "nl-NL"
    case swedish = "sv-SE"
    case danish = "da-DK"
    case finnish = "fi-FI"
    case polish = "pl-PL"
    case greek = "el-GR"
    case turkish = "tr-TR"
    case thai = "th-TH"
    case hindi = "hi-IN"
    
    // Display Name
    var displayName: String {
        switch self {
        case .englishUS: return "English (US)"
        case .englishUK: return "English (UK)"
        case .englishAustralia: return "English (Australia)"
        case .englishIndia: return "English (India)"
        case .englishSouthAfrica: return "English (South Africa)"
        case .frenchFrance: return "Français (France)"
        case .frenchCanada: return "Français (Canada)"
        case .germanGermany: return "Deutsch (Germany)"
        case .spanishSpain: return "Español (Spain)"
        case .spanishMexico: return "Español (Mexico)"
        case .portugueseBrazil: return "Português (Brazil)"
        case .portuguesePortugal: return "Português (Portugal)"
        case .chineseMandarin: return "中文 (Mandarin - China)"
        case .chineseHongKong: return "中文 (Hong Kong)"
        case .chineseTaiwan: return "中文 (Taiwan)"
        case .japanese: return "日本語 (Japanese)"
        case .korean: return "한국어 (Korean)"
        case .arabic: return "العربية (Arabic)"
        case .russian: return "Русский (Russian)"
        case .dutch: return "Nederlands (Dutch)"
        case .swedish: return "Svenska (Swedish)"
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
        case .englishUS: return "US"
        case .englishUK: return "UK"
        case .englishAustralia: return "AU"
        case .englishIndia: return "IN"
        case .englishSouthAfrica: return "ZA"
        case .frenchFrance: return "FR"
        case .frenchCanada: return "CA"
        case .germanGermany: return "DE"
        case .spanishSpain: return "ES"
        case .spanishMexico: return "MX"
        case .portugueseBrazil: return "BR"
        case .portuguesePortugal: return "PT"
        case .chineseMandarin: return "CN"
        case .chineseHongKong: return "HK"
        case .chineseTaiwan: return "TW"
        case .japanese: return "JP"
        case .korean: return "KR"
        case .arabic: return "SA"
        case .russian: return "RU"
        case .dutch: return "NL"
        case .swedish: return "SE"
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
        case .englishUS, .englishUK, .englishAustralia, .englishIndia, .englishSouthAfrica: return "Page"
        case .frenchFrance, .frenchCanada: return "Page"
        case .germanGermany: return "Seite"
        case .spanishSpain, .spanishMexico: return "Página"
        case .portugueseBrazil, .portuguesePortugal: return "Página"
        case .chineseMandarin, .chineseHongKong, .chineseTaiwan: return "页"
        case .japanese: return "ページ"
        case .korean: return "페이지"
        case .arabic: return "صفحة"
        case .russian: return "Страница"
        case .dutch: return "Pagina"
        case .swedish: return "Sida"
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
