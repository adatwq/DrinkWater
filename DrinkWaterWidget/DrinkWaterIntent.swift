//
//  DrinkWaterIntent.swift
//  DrinkWater
//
//  Created by Khawlah Khalid on 06/12/2023.
//

import Foundation
import AppIntents
import SwiftUI

struct DrinkWaterWidgetIntent: AppIntent{
    static var title: LocalizedStringResource = "Drink water"
    func perform() async throws -> some IntentResult {
        print("Button taped !")
        if CupsInfo.shared.currentCups < CupsInfo.shared.totalCups{
            CupsInfo.shared.currentCups += 1
        }
        return .result()
    }
}
