import AppKit
import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

struct SourceSpec {
    let file: String
    let crop: CGRect
}

struct CompositeSpec {
    let output: String
    let sources: [SourceSpec]
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let assets = root.appendingPathComponent("Réalisation/Schéma/Nouveau/GoodFood - C4-Option3/assets")

let specs: [CompositeSpec] = [
    .init(
        output: "azure-kubernetes.png",
        sources: [
            .init(file: "azure.png", crop: CGRect(x: 0.16, y: 0.08, width: 0.68, height: 0.56)),
            .init(file: "kubernetes.png", crop: CGRect(x: 0.12, y: 0.04, width: 0.76, height: 0.80)),
        ]
    ),
    .init(
        output: "dotnet-postgresql.png",
        sources: [
            .init(file: "dotnet.png", crop: CGRect(x: 0.14, y: 0.04, width: 0.72, height: 0.68)),
            .init(file: "postgresql.png", crop: CGRect(x: 0.14, y: 0.06, width: 0.72, height: 0.62)),
        ]
    ),
    .init(
        output: "nodejs-mongodb.png",
        sources: [
            .init(file: "nodejs.png", crop: CGRect(x: 0.12, y: 0.08, width: 0.76, height: 0.46)),
            .init(file: "mongodb.png", crop: CGRect(x: 0.18, y: 0.04, width: 0.64, height: 0.64)),
        ]
    ),
    .init(
        output: "keycloak-postgresql.png",
        sources: [
            .init(file: "keycloak.png", crop: CGRect(x: 0.12, y: 0.08, width: 0.76, height: 0.50)),
            .init(file: "postgresql.png", crop: CGRect(x: 0.14, y: 0.06, width: 0.72, height: 0.62)),
        ]
    ),
]

func fail(_ message: String) -> Never {
    fputs("error: \(message)\n", stderr)
    exit(1)
}

func loadCGImage(_ file: String) -> CGImage {
    let url = assets.appendingPathComponent(file)
    guard
        let image = NSImage(contentsOf: url),
        let tiff = image.tiffRepresentation,
        let bitmap = NSBitmapImageRep(data: tiff),
        let cgImage = bitmap.cgImage
    else {
        fail("cannot open \(url.path)")
    }

    return cgImage
}

func cropImage(_ image: CGImage, relativeRect: CGRect) -> CGImage {
    let cropRect = CGRect(
        x: relativeRect.origin.x * CGFloat(image.width),
        y: relativeRect.origin.y * CGFloat(image.height),
        width: relativeRect.width * CGFloat(image.width),
        height: relativeRect.height * CGFloat(image.height)
    ).integral

    guard let cropped = image.cropping(to: cropRect) else {
        fail("cannot crop image")
    }

    return cropped
}

func makeContext(width: Int, height: Int) -> CGContext {
    guard
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
        let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
    else {
        fail("cannot create graphics context")
    }

    context.clear(CGRect(x: 0, y: 0, width: width, height: height))
    context.interpolationQuality = .high
    return context
}

func draw(_ image: CGImage, in rect: CGRect, context: CGContext) {
    context.saveGState()
    context.setAlpha(1.0)
    context.draw(image, in: rect)
    context.restoreGState()
}

func aspectFitRect(for image: CGImage, in bounds: CGRect) -> CGRect {
    let widthScale = bounds.width / CGFloat(image.width)
    let heightScale = bounds.height / CGFloat(image.height)
    let scale = min(widthScale, heightScale)

    let drawWidth = CGFloat(image.width) * scale
    let drawHeight = CGFloat(image.height) * scale

    return CGRect(
        x: bounds.origin.x + ((bounds.width - drawWidth) / 2.0),
        y: bounds.origin.y + ((bounds.height - drawHeight) / 2.0),
        width: drawWidth,
        height: drawHeight
    )
}

func writePNG(_ image: CGImage, to file: String) {
    let outputURL = assets.appendingPathComponent(file)
    guard let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, UTType.png.identifier as CFString, 1, nil) else {
        fail("cannot create destination \(outputURL.path)")
    }

    CGImageDestinationAddImage(destination, image, nil)
    if !CGImageDestinationFinalize(destination) {
        fail("cannot write \(outputURL.path)")
    }
}

let canvasWidth = 512
let canvasHeight = 512
let slots = [
    CGRect(x: 40, y: 286, width: 432, height: 170),
    CGRect(x: 40, y: 56, width: 432, height: 170),
]

for spec in specs {
    let context = makeContext(width: canvasWidth, height: canvasHeight)

    for (index, source) in spec.sources.enumerated() {
        let fullImage = loadCGImage(source.file)
        let cropped = cropImage(fullImage, relativeRect: source.crop)
        let drawRect = aspectFitRect(for: cropped, in: slots[index])
        draw(cropped, in: drawRect, context: context)
    }

    guard let result = context.makeImage() else {
        fail("cannot render composite \(spec.output)")
    }

    writePNG(result, to: spec.output)
    print("wrote \(spec.output)")
}
