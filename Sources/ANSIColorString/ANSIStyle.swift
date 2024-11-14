public struct ANSIStyle: Sendable, Equatable {

  public let foreground: ANSIColor?
  public let background: ANSIColor?
  public let bold: Bool

  public init(
    foreground: ANSIColor? = nil,
    background: ANSIColor? = nil,
    bold: Bool = false
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
    if bold {
      "\u{001B}[1m"
    } else {
      nil
    }
  }

  var head: String {
    [ foregroundCode, backgroundCode, boldCode ]
      .compactMap { $0 }
      .joined()
  }

  var tail: String { reset }

  let reset: String = "\u{001B}[0m"

  func apply(to string: String) -> String {
    "\(head)\(string)\(tail)"
  }

}
