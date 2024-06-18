//
//  KeyboardLocale+FlagTests.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-03-17.
//  Copyright © 2021-2024 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import XCTest

class KeyboardLocale_FlagTests: XCTestCase {
    
    func testFlagIsValidForAllCases() {
        let map = KeyboardLocale.all.map { ($0, $0.flag) }
        let result = Dictionary(uniqueKeysWithValues: map)
        let expected: [KeyboardLocale: String] = [
            .albanian: "🇦🇱",
            .arabic: "🇦🇪",
            .armenian: "🇦🇲",
            .belarusian: "🇧🇾",
            .bulgarian: "🇧🇬",
            .catalan: "🇦🇩",
            .cherokee: "🏳️",
            .croatian: "🇭🇷",
            .czech: "🇨🇿",
            .danish: "🇩🇰",
            .dutch: "🇳🇱",
            .dutch_belgium: "🇧🇪",
            .english: "🇺🇸",
            .english_gb: "🇬🇧",
            .english_us: "🇺🇸",
            .estonian: "🇪🇪",
            .faroese: "🇫🇴",
            .filipino: "🇵🇭",
            .finnish: "🇫🇮",
            .french: "🇫🇷",
            .french_belgium: "🇧🇪",
            .french_canada: "🇨🇦",
            .french_switzerland: "🇨🇭",
            .georgian: "🇬🇪",
            .german: "🇩🇪",
            .german_austria: "🇦🇹",
            .german_switzerland: "🇨🇭",
            .greek: "🇬🇷",
            .hawaiian: "🇺🇸",
            .hebrew: "🇮🇱",
            .hungarian: "🇭🇺",
            .icelandic: "🇮🇸",
            .inari_sami: "🏳️",
            .indonesian: "🇮🇩",
            .irish: "🇮🇪",
            .italian: "🇮🇹",
            .kazakh: "🇰🇿",
            .kurdish_sorani: "🇹🇯",
            .kurdish_sorani_arabic: "🇹🇯",
            .kurdish_sorani_pc: "🇹🇯",
            .latvian: "🇱🇻",
            .lithuanian: "🇱🇹",
            .macedonian: "🇲🇰",
            .malay: "🇲🇾",
            .maltese: "🇲🇹",
            .mongolian: "🇲🇳",
            .northern_sami: "🏳️",
            .norwegian: "🇳🇴",
            .norwegian_nynorsk: "🇳🇴",
            .persian: "🇮🇷",
            .polish: "🇵🇱",
            .portuguese: "🇵🇹",
            .portuguese_brazil: "🇧🇷",
            .romanian: "🇷🇴",
            .russian: "🇷🇺",
            .serbian: "🇷🇸",
            .serbian_latin: "🇷🇸",
            .slovenian: "🇸🇮",
            .slovak: "🇸🇰",
            .spanish: "🇪🇸",
            .spanish_latinAmerica: "🇦🇷",
            .spanish_mexico: "🇲🇽",
            .swedish: "🇸🇪",
            .swahili: "🇰🇪",
            .turkish: "🇹🇷",
            .ukrainian: "🇺🇦",
            .uzbek: "🇺🇿",
            .welsh: "🏴󠁧󠁢󠁷󠁬󠁳󠁿"
        ]

        XCTAssertEqual(result.keys, expected.keys)
        result.keys.forEach {
            XCTAssertEqual(result[$0], expected[$0])
        }
    }

    @available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
    func testFlagDifferences() throws {
        try XCTSkipIf(true)
        KeyboardLocale.allCases.forEach { locale in
            XCTAssertEqual(
                locale.flag,
                locale.locale.flag,
                locale.locale.localizedName
            )
        }
    }
    
    func testPrintFlagGrid() throws {
        try XCTSkipIf(true)
        var count = 0
        var text = ""
        print("")
        printLine("Flag Grid")
        KeyboardLocale.allCases.forEach { locale in
            count += 1
            text += "\(locale.flag) "
            if count == 10 {
                printLine(text)
                count = 0
                text = ""
            }
        }
        if !text.isEmpty {
            printLine(text)
        }
    }
    
    func testPrintFlagNameList() throws {
        try XCTSkipIf(true)
        print("")
        printLine("Flag Names")
        KeyboardLocale.allCases.forEach { locale in
            printLine("\(locale.flag) \(locale.locale.localizedName(in: KeyboardLocale.english.locale))")
        }
    }
    
    func testPrintFlagText() throws {
        try XCTSkipIf(true)
        print("")
        printLine("Flag List")
        let text = KeyboardLocale.allCases
            .map { $0.flag }
            .joined(separator: " ")
        printLine(text)
    }
    
    func testPrintNameText() throws {
        try XCTSkipIf(true)
        print("")
        printLine("Name List")
        let text = KeyboardLocale.allCases
            .map { $0.locale.localizedName(in: KeyboardLocale.english.locale) }
            .joined(separator: ", ")
        printLine(text)
    }
    
    func printLine(_ string: String) {
        print("*** \(string) <br />")
    }
}
