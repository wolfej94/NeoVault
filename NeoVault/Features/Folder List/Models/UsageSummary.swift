//
//  UsageSummary.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

import Foundation

struct UsageSummary {
    let documentUsage: CGFloat
    let imageUsage: CGFloat
    let videoUsage: CGFloat
    let musicUsage: CGFloat
    let maxUsage: CGFloat

    var totalUsagePercentage: CGFloat {
        usageFraction(totalUsage) * 100
    }

    var totalUsage: CGFloat {
        documentUsage + imageUsage + videoUsage + musicUsage
    }

    func usageFraction(_ value: CGFloat) -> Double {
        min(value / max(totalUsage, maxUsage), 1.0)
    }
}
