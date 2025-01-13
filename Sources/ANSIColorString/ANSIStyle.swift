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

  var foregroundCode: String? {
    if let foreground {
      "\u{001B}[38;5;\(foreground.rawValue)m"
    } else {
      nil
    }
  }

  var backgroundCode: String? {
    if let background {
      "\u{001B}[48;5;\(background.rawValue)m"
    } else {
      nil
    }
  }

  var boldCode: String? {
    if
      let bold,
      bold
    {
      "\u{001B}[1m"
    } else {
      nil
    }
  }

  var unboldCode: String? {
    if
      let bold,
      !bold
    {
      "\u{001B}[22m"
    } else {
      nil
    }
  }

  var head: String {
    [
      foregroundCode,
      backgroundCode,
      boldCode,
      unboldCode,
    ]
      .compactMap { $0 }
      .joined()
  }

  var tail: String { Self.reset }

  static let empty = Self()
  static let reset: String = "\u{001B}[0m"

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
