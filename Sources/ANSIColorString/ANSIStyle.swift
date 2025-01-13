public struct ANSIStyle: Sendable, Equatable {

  public let foreground: ANSIColor?
  public let background: ANSIColor?
  public let bold: Bool?

  public init(
    foreground: ANSIColor? = nil,
    background: ANSIColor? = nil,
    bold: Bool? = nil
  ) {
    self.foreground = foreground
    self.background = background
    self.bold = bold
  }


  fileprivate static func render(code: UInt8...) -> String {
    render(code: code)
  }

  fileprivate static func render(code: any Sequence<UInt8>) -> String {
    "\u{001B}[\(code.map(\.description).joined(separator: ";"))m"
  }

  var foregroundCode: [UInt8] {
    if let foreground {
      [38, 5, foreground.rawValue]
    } else {
      []
    }
  }

  var backgroundCode: [UInt8] {
    if let background {
      [48, 5, background.rawValue]
    } else {
      []
    }
  }

  var boldCode: [UInt8] {
    if let bold {
      if bold {
        [1]
      } else {
        [22]
      }
    } else {
      []
    }
  }

  var head: String {
    Self.render(code: [ foregroundCode, backgroundCode, boldCode ].joined())
  }

  var tail: String { Self.reset }

  static let empty = Self()
  static let reset: String = Self.render(code: 0)

  func apply(to string: String, in context: Self? = nil) -> String {
    if let context {
      let contextualStyle = self.in(context: context)

      return "\(contextualStyle.head)\(string)\(tail)\(context.head)"
    } else {
      return "\(head)\(string)\(tail)"
    }
  }

  package func `in`(context: Self) -> Self {
    Self(
      foreground: self.foreground ?? context.foreground,
      background: self.background ?? context.background,
      bold: self.bold ?? context.bold
    )
  }

}
