// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct ANSIColorString: Equatable {

  enum Segment: Equatable {
    case plain(string: String)
    case styled(as: ANSIStyle, string: String)
    case complex(string: ANSIColorString)
  }

  public var style: ANSIStyle
  var segments: [Segment]

}

extension ANSIColorString: ExpressibleByStringLiteral {

  public init(stringLiteral: String) {
    self.init(style: .empty, segments: [.plain(string: stringLiteral)])
  }

}

extension ANSIColorString: CustomStringConvertible {

  func rendered(in context: ANSIStyle) -> String {
    var renderedString = ""

    if style != ANSIStyle.empty {
      renderedString.append(style.head)
    }

    for segment in segments {
      switch segment {
      case .plain(let string):
        renderedString.append(string)
      case .styled(let segmentStyle, let string):
        renderedString.append(string.applying(style: segmentStyle, in: style))
      case .complex(let string):
        renderedString.append(string.rendered(in: style))
      }
    }

    if style != ANSIStyle.empty {
      renderedString.append(style.tail)
    }

    if context != .empty {
      renderedString.append(context.head)
    }

    return renderedString
  }

  public var description: String {
    rendered(in: ANSIStyle.empty)
  }

}

public extension ANSIColorString {

  init(style: ANSIStyle, string: any StringProtocol) {
    self.init(style: style, segments: [.plain(string: String(string))])
  }

  mutating func append(string: any StringProtocol, style: ANSIStyle? = nil) {
    if let style {
      segments.append(.styled(as: style, string: String(string)))
    } else {
      segments.append(.plain(string: String(string)))
    }
  }

  mutating func append(string: Self) {
    segments.append(.complex(string: string))
  }

}
