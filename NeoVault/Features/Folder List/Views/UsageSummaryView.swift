//
//  UsageSummaryComponent.swift
//  NeoVault
//
//  Created by James Wolfe on 25/10/2024.
//

import SwiftUI

struct UsageSummaryView: View {

    private let usage: UsageSummary
    @State private var animateChart = false

    private var documentRotationDegrees: Double {
        -90
    }

    private var imageRotationDegrees: Double {
        documentRotationDegrees
        + usage.usageFraction(usage.imageUsage)
    }

    private var videoRotationDegrees: Double {
        imageRotationDegrees
        + usage.usageFraction(usage.videoUsage)
    }

    private var musicRotationDegrees: Double {
        videoRotationDegrees
        + usage.usageFraction(usage.musicUsage)
    }

    private var documentTrim: Double {
        usage.usageFraction(usage.documentUsage)
    }

    private var imageTrim: Double {
        documentTrim
        + usage.usageFraction(usage.imageUsage)
    }

    private var videoTrim: Double {
        imageTrim
        + usage.usageFraction(usage.videoUsage)
    }

    private var musicTrim: Double {
        videoTrim
        + usage.usageFraction(usage.musicUsage)
    }

    init(usage: UsageSummary) {
        self.usage = usage
    }

    var body: some View {
        HStack(spacing: 40) {
            ZStack {
                Text(String(format: "%.0f%%", usage.totalUsagePercentage))
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Circle()
                    .trim(from: 0, to: animateChart ? documentTrim : 0)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                    .foregroundColor(.blueOne)
                    .rotationEffect(.degrees(documentRotationDegrees))
                    .zIndex(4)

                Circle()
                    .trim(from: 0, to: animateChart ? imageTrim : 0)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                    .foregroundColor(.blueTwo)
                    .rotationEffect(.degrees(imageRotationDegrees))
                    .zIndex(3)
                Circle()
                    .trim(from: 0, to: animateChart ? videoTrim : 0)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                    .foregroundColor(.blueThree)
                    .rotationEffect(.degrees(videoRotationDegrees))
                    .zIndex(2)
                Circle()
                    .trim(from: 0, to: animateChart ? musicTrim : 0)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                    .foregroundColor(.blueFour)
                    .rotationEffect(.degrees(musicRotationDegrees))
                    .zIndex(1)
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                    .foregroundColor(Color.white.opacity(0.1))
                    .zIndex(0)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    animateChart = true
                }
            }

            // Key and Usage Details
            VStack(alignment: .leading, spacing: 6) {
                UsageKeyRow(color: .blueOne, label: "Documents", value: usage.documentUsage)
                UsageKeyRow(color: .blueTwo, label: "Images", value: usage.imageUsage)
                UsageKeyRow(color: .blueThree, label: "Videos", value: usage.videoUsage)
                UsageKeyRow(color: .blueFour, label: "Music", value: usage.musicUsage)
            }
        }
        .padding(.all, 30)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(Color.blueFive)
        }
    }

}

struct UsageKeyRow: View {

    private let color: Color
    private let label: String
    private let value: CGFloat

    init(color: Color, label: String, value: CGFloat) {
        self.color = color
        self.label = label
        self.value = value
    }

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
                .frame(width: 12, height: 12)
            Text("\(label): \(Int(value)) MB")
                .foregroundStyle(Color.white)
                .font(.caption)
        }
    }

}

struct CircleSegment: Shape {

    private let percentage: CGFloat

    init(percentage: CGFloat) {
        self.percentage = percentage
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: .degrees(0),
            endAngle: .degrees(Double(percentage * 360)),
            clockwise: false
        )
        return path
    }

}
