import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

struct IconSpec {
    let idiom: String
    let size: String
    let scale: String
    let filename: String
    let role: String?
    let subtype: String?

    var pixelSize: Int {
        let base = Double(size.split(separator: "x")[0])!
        let multiplier = Double(scale.dropLast())!
        return Int((base * multiplier).rounded())
    }

    var json: [String: String] {
        var value = [
            "idiom": idiom,
            "size": size,
            "scale": scale,
            "filename": filename
        ]
        if let role {
            value["role"] = role
        }
        if let subtype {
            value["subtype"] = subtype
        }
        return value
    }
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let iosIconSet = root.appendingPathComponent("CadenceShiftApp/Assets.xcassets/AppIcon.appiconset")
let watchIconSet = root.appendingPathComponent("CadenceShiftWatchApp/Assets.xcassets/AppIcon.appiconset")

let iosSpecs = [
    IconSpec(idiom: "iphone", size: "20x20", scale: "2x", filename: "Icon-20@2x.png", role: nil, subtype: nil),
    IconSpec(idiom: "iphone", size: "20x20", scale: "3x", filename: "Icon-20@3x.png", role: nil, subtype: nil),
    IconSpec(idiom: "iphone", size: "29x29", scale: "2x", filename: "Icon-29@2x.png", role: nil, subtype: nil),
    IconSpec(idiom: "iphone", size: "29x29", scale: "3x", filename: "Icon-29@3x.png", role: nil, subtype: nil),
    IconSpec(idiom: "iphone", size: "40x40", scale: "2x", filename: "Icon-40@2x.png", role: nil, subtype: nil),
    IconSpec(idiom: "iphone", size: "40x40", scale: "3x", filename: "Icon-40@3x.png", role: nil, subtype: nil),
    IconSpec(idiom: "iphone", size: "60x60", scale: "2x", filename: "Icon-60@2x.png", role: nil, subtype: nil),
    IconSpec(idiom: "iphone", size: "60x60", scale: "3x", filename: "Icon-60@3x.png", role: nil, subtype: nil),
    IconSpec(idiom: "ios-marketing", size: "1024x1024", scale: "1x", filename: "Icon-1024.png", role: nil, subtype: nil)
]

let watchSpecs = [
    IconSpec(idiom: "watch", size: "24x24", scale: "2x", filename: "Icon-24@2x.png", role: "notificationCenter", subtype: "38mm"),
    IconSpec(idiom: "watch", size: "27.5x27.5", scale: "2x", filename: "Icon-27_5@2x.png", role: "notificationCenter", subtype: "42mm"),
    IconSpec(idiom: "watch", size: "29x29", scale: "2x", filename: "Icon-29@2x.png", role: "companionSettings", subtype: nil),
    IconSpec(idiom: "watch", size: "29x29", scale: "3x", filename: "Icon-29@3x.png", role: "companionSettings", subtype: nil),
    IconSpec(idiom: "watch", size: "40x40", scale: "2x", filename: "Icon-40@2x.png", role: "appLauncher", subtype: "38mm"),
    IconSpec(idiom: "watch", size: "44x44", scale: "2x", filename: "Icon-44@2x.png", role: "appLauncher", subtype: "40mm"),
    IconSpec(idiom: "watch", size: "50x50", scale: "2x", filename: "Icon-50@2x.png", role: "appLauncher", subtype: "44mm"),
    IconSpec(idiom: "watch", size: "86x86", scale: "2x", filename: "Icon-86@2x.png", role: "quickLook", subtype: "38mm"),
    IconSpec(idiom: "watch", size: "98x98", scale: "2x", filename: "Icon-98@2x.png", role: "quickLook", subtype: "42mm"),
    IconSpec(idiom: "watch", size: "108x108", scale: "2x", filename: "Icon-108@2x.png", role: "quickLook", subtype: "44mm"),
    IconSpec(idiom: "watch-marketing", size: "1024x1024", scale: "1x", filename: "Icon-1024.png", role: nil, subtype: nil)
]

func drawIcon(pixelSize: Int, outputURL: URL) throws {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard let context = CGContext(
        data: nil,
        width: pixelSize,
        height: pixelSize,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
    ) else {
        throw NSError(domain: "IconGenerator", code: 1)
    }

    let side = CGFloat(pixelSize)

    context.setFillColor(CGColor(red: 0.02, green: 0.12, blue: 0.15, alpha: 1))
    context.fill(CGRect(x: 0, y: 0, width: side, height: side))

    let gradientColors = [
        CGColor(red: 0.02, green: 0.12, blue: 0.15, alpha: 1),
        CGColor(red: 0.02, green: 0.46, blue: 0.46, alpha: 1)
    ] as CFArray
    let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors, locations: [0, 1])!
    context.drawLinearGradient(
        gradient,
        start: CGPoint(x: side * 0.1, y: side * 0.08),
        end: CGPoint(x: side * 0.9, y: side * 0.92),
        options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
    )

    context.setStrokeColor(CGColor(red: 0.48, green: 0.92, blue: 0.88, alpha: 0.24))
    context.setLineWidth(max(2, side * 0.09))
    context.setLineCap(.round)
    context.setLineJoin(.round)
    strokeWave(in: context, side: side)

    context.setStrokeColor(CGColor(red: 0.95, green: 1.0, blue: 0.98, alpha: 1))
    context.setLineWidth(max(2, side * 0.052))
    strokeWave(in: context, side: side)

    context.setFillColor(CGColor(red: 0.95, green: 1.0, blue: 0.98, alpha: 1))
    let dotRadius = max(1.5, side * 0.018)
    for point in [CGPoint(x: side * 0.18, y: side * 0.54), CGPoint(x: side * 0.82, y: side * 0.54)] {
        context.fillEllipse(in: CGRect(x: point.x - dotRadius, y: point.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
    }

    guard let image = context.makeImage() else {
        throw NSError(domain: "IconGenerator", code: 2)
    }
    guard let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, UTType.png.identifier as CFString, 1, nil) else {
        throw NSError(domain: "IconGenerator", code: 3)
    }
    CGImageDestinationAddImage(destination, image, nil)
    if !CGImageDestinationFinalize(destination) {
        throw NSError(domain: "IconGenerator", code: 4)
    }
}

func strokeWave(in context: CGContext, side: CGFloat) {
    context.beginPath()
    context.move(to: CGPoint(x: side * 0.14, y: side * 0.54))
    context.addLine(to: CGPoint(x: side * 0.28, y: side * 0.54))
    context.addLine(to: CGPoint(x: side * 0.35, y: side * 0.42))
    context.addLine(to: CGPoint(x: side * 0.43, y: side * 0.68))
    context.addLine(to: CGPoint(x: side * 0.53, y: side * 0.28))
    context.addLine(to: CGPoint(x: side * 0.63, y: side * 0.54))
    context.addLine(to: CGPoint(x: side * 0.86, y: side * 0.54))
    context.strokePath()
}

func writeContentsJSON(specs: [IconSpec], to iconSet: URL) throws {
    let payload: [String: Any] = [
        "images": specs.map(\.json),
        "info": [
            "author": "xcode",
            "version": 1
        ]
    ]
    let data = try JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys])
    try data.write(to: iconSet.appendingPathComponent("Contents.json"))
}

for (iconSet, specs) in [(iosIconSet, iosSpecs), (watchIconSet, watchSpecs)] {
    try FileManager.default.createDirectory(at: iconSet, withIntermediateDirectories: true)
    for spec in specs {
        try drawIcon(pixelSize: spec.pixelSize, outputURL: iconSet.appendingPathComponent(spec.filename))
    }
    try writeContentsJSON(specs: specs, to: iconSet)
}
