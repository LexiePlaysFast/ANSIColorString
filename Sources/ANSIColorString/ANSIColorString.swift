public struct ANSIColorString: Sendable, Equatable, Hashable, Codable {

  enum Segment: Equatable, Hashable, Codable {
    case plain(_ string: String)
    case styled(as: ANSIStyle, _ string: String)
    case complex(_ string: ANSIColorString)
  }

  public var style: ANSIStyle
  var segments: [Segment]

}

extension ANSIColorString: ExpressibleByStringLiteral {

  public init(stringLiteral: String) {
    self.init(string: stringLiteral)
  }

}

extension ANSIColorString: CustomStringConvertible {

  func rendered(in context: ANSIStyle? = nil) -> String {
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
      case .complex(let complexString):
        renderedString.append(complexString.rendered(in: style))
      }
    }

    if let context {
      renderedString.append(style.reset(to: context))
    } else {
      if style != ANSIStyle.empty {
        renderedString.append(style.tail)
      }
    }

    return renderedString
  }

  public var description: String {
    rendered()
  }

}

public extension ANSIColorString {

  init(style: ANSIStyle = .empty, string: any StringProtocol) {
    self.init(style: style, segments: [.plain(String(string))])
  }

  mutating func append(style: ANSIStyle? = nil, string: any StringProtocol) {
    if let style {
      segments.append(.styled(as: style, String(string)))
    } else {
      segments.append(.plain(String(string)))
    }
  }

  mutating func append(string: Self) {
    segments.append(.complex(string))
  }

  var plainText: String {
    var plainTextString = ""

    for segment in segments {
      switch segment {
      case .plain(let string): fallthrough
      case .styled(_, let string):
        plainTextString.append(string)
      case .complex(let complexString):
        plainTextString.append(complexString.plainText)
      }
    }

    return plainTextString
  }

}
