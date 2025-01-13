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


  fileprivate func render(code: UInt8...) -> String {
    render(code: code)
  }

  fileprivate func render(code: any Sequence<UInt8>) -> String {
    "\u{001B}[\(code.map(\.description).joined(separator: ";"))m"
  }

  var foregroundCode: [UInt8]? {
    if let foreground {
      [38, 5, foreground.rawValue]
    } else {
      nil
    }
  }

  var backgroundCode: [UInt8]? {
    if let background {
      [48, 5, background.rawValue]
    } else {
      nil
    }
  }

  var boldCode: [UInt8]? {
    if let bold {
      if bold {
        [1]
      } else {
        [22]
      }
    } else {
      nil
    }
  }

  var head: String {
    let code = [
      foregroundCode,
      backgroundCode,
      boldCode,
    ]
      .compactMap { $0 }
      .joined()

    return render(code: code)
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
