//
//  KeyGen.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/17/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import Foundation

public final class KeyGen {
    
    private static var word: String {
        return allWords.random
    }
    
    public static func newKey() -> String {
        return word + word
    }
}

fileprivate extension KeyGen {
    
    fileprivate enum Separator: String {
        case none = ""
        case space = " "
        case dot = "."
        case newLine = "\n"
    }
    
    fileprivate static let allWords: [String] = "PENGUIN,BRAWLER,BEEFCAKE,VIRGIN,PHENOMENAL,DIFFICULT,DRAMATIC,HOME,EXPRESSION,EARLY,PILL,COAL,DOUBLE,HERD,ALIEN,HERB,CATCH,EDIT,BABOON,BUMPER,DIVORCE,ORNAMENTAL,CHAMPION,BLACKNESS,FLAKE,FASHIONABLE,JIGSAW,LEGENDARY,CLEAN,DEFORMITY,CONTRADICTION,EAR,CYNICAL,POETRY,EVENT,AGILITY,LUSTRE,CORRUPTION,ESTATE,GENERATION,DOGTOOTH,GUTSY,JOYSTICK,DECADENT,MOOD,BOTTOMLESS,CONCERT,VIRGIN,BOAST,UNIT,SNAKE,LUBRICANT,REVENGE,POWDER,ALTERNATE,BELLY,ARROWS,DITCH,ALSO,WEARABLE,PILL,VOID,ASTOUNDING,GUZZLING,RAVEN,CHILDISH,SUGAR,FLUENT,COUGH,FLOPPY,SURREAL,SUGAR,DIARY,CHISEL,APPARITION,EVECTIONAL,HELL,TANK,PURPLE,RAT,RASTLING,HELLFIRE,PUSH,EXPERIMENT,ACCIDENTAL,PRIMITIVE,DISHONEST,SOLITARY,JADE,BOUNCE,EXHIBIT,BARE,ANCHOVIES,BITTERSWEET,HANGMAN,FOG,PIPES,DEMOLISHMENT,BESTIAL,COMPLETE".components(separatedBy: ",")
}

fileprivate extension Array {
    
    fileprivate var random: Element {
        precondition(!isEmpty)
        return self[Int.random(max: count - 1)]
    }
    
}


fileprivate extension Int {
    
    fileprivate static func random(min: Int = 0, max: Int) -> Int {
        precondition(min >= 0 && min < max)
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
    
}

