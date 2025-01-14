public struct ANSIColor: Sendable, Equatable, Hashable, Codable {

  package let rawValue: UInt8

}

public extension ANSIColor {

  static let black = Self(rawValue: 0)
  static let red = Self(rawValue: 1)
  static let green = Self(rawValue: 2)
  static let yellow = Self(rawValue: 3)
  static let blue = Self(rawValue: 4)
  static let magenta = Self(rawValue: 5)
  static let cyan = Self(rawValue: 6)
  static let white = Self(rawValue: 7)

  static let brightBlack = Self(rawValue: 8)
  static let brightRed = Self(rawValue: 9)
  static let brightGreen = Self(rawValue: 10)
  static let brightYellow = Self(rawValue: 11)
  static let brightBlue = Self(rawValue: 12)
  static let brightMagenta = Self(rawValue: 13)
  static let brightCyan = Self(rawValue: 14)
  static let brightWhite = Self(rawValue: 15)

  static func palette(index: Int) -> Self {
    let colorPaletteRange = 0...15

    guard
      colorPaletteRange.contains(index)
    else {
      preconditionFailure("Palette index \(index) out of range (\(colorPaletteRange))")
    }

    return Self(rawValue: UInt8(index))
  }

  static func brightPalette(index: Int) -> Self {
    let colorPaletteRange = 0...7

    guard
      colorPaletteRange.contains(index)
    else {
      preconditionFailure("Bright palette index \(index) out of range (\(colorPaletteRange))")
    }

    return .palette(index: index + 8)
  }

  static func color(red: Int, green: Int, blue: Int) -> Self {
    let colorCubeRange = 0...5

    guard
      colorCubeRange.contains(red),
      colorCubeRange.contains(green),
      colorCubeRange.contains(blue)
    else {
      preconditionFailure("Color cube coordinates (r: \(red), g: \(green), b: \(blue)) out of range (\(colorCubeRange))")
    }

    return Self(rawValue: UInt8(16 + 36 * red + 6 * green + blue))
  }

  static func grayscale(intensity: Int) -> Self {
    let intensityRange = 0...23

    guard
      intensityRange.contains(intensity)
    else {
      preconditionFailure("Grayscale intensity \(intensity) out of range (\(intensityRange))")
    }

    return Self(rawValue: UInt8(232 + intensity))
  }

}
