public struct ANSIStyle: Sendable, Equatable, Hashable {

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

  public static let empty = Self()

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
        Self.boldResetCode
      }
    } else {
      []
    }
  }

  var head: String {
    Self.render(
      code: [
        foregroundCode,
        backgroundCode,
        boldCode,
      ]
        .joined()
    )
  }

  var tail: String { Self.reset }

  func resetCode(to context: Self) -> some Sequence<UInt8> {
    var resetSequence: [UInt8] = []

    func appendResetOrContextSequence<T>(
      fieldPath: KeyPath<Self,T?>,
      contextSequencePath: KeyPath<Self,[UInt8]>,
      resetSequencePath: KeyPath<Self,[UInt8]>
    ) where T: Equatable {
      if self[keyPath: fieldPath] != context[keyPath: fieldPath] {
        resetSequence.append(contentsOf:
          context[keyPath: fieldPath] == nil
            ? self[keyPath: resetSequencePath]
            : context[keyPath: contextSequencePath]
        )
      }
    }

    appendResetOrContextSequence(fieldPath: \.foreground, contextSequencePath: \.foregroundCode, resetSequencePath: \.foregroundResetCode)
    appendResetOrContextSequence(fieldPath: \.background, contextSequencePath: \.backgroundCode, resetSequencePath: \.backgroundResetCode)

    appendResetOrContextSequence(fieldPath: \.bold,       contextSequencePath: \.boldCode,       resetSequencePath: \.boldResetCode)

    return resetSequence
  }

  func reset(to context: Self) -> String {
    Self.render(code: resetCode(to: context))
  }

  static let reset: String = Self.render(code: 0)

  static let foregroundResetCode: [UInt8] = [39]
  static let backgroundResetCode: [UInt8] = [49]

  var foregroundResetCode: [UInt8] { Self.foregroundResetCode }
  var backgroundResetCode: [UInt8] { Self.backgroundResetCode }

  static let boldResetCode: [UInt8] = [22]

  var boldResetCode: [UInt8] { Self.boldResetCode }

  func apply(to string: String, in context: Self? = nil) -> String {
    if let context {
      let contextualStyle = self.in(context: context)

      return "\(contextualStyle.head)\(string)\(reset(to: context))"
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
