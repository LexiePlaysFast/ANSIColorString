// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct ANSIColorString {

  enum Segment {
    case plain(string: String)
    case styled(as: ANSIStyle, string: String)
  }

  public private(set) var style: ANSIStyle
  var segments: [Segment]

}

extension ANSIColorString: CustomStringConvertible {

  public var description: String {
    var renderedString = ""

    if style != ANSIStyle.empty {
      renderedString.append(style.head)
    }

    for segment in segments {
      switch segment {
      case .plain(let string): renderedString.append(string)
      case .styled(let style, let string):
        renderedString.append(style.head)
        renderedString.append(string)
      }
    }

    if style != ANSIStyle.empty {
      renderedString.append(style.tail)
    }

    return renderedString
  }

}

public extension ANSIColorString {

  init(style: ANSIStyle, string: any StringProtocol) {
    self.init(style: style, segments: [.plain(string: String(string))])
  }

  mutating func append(string: any StringProtocol) {
    segments.append(.plain(string: String(string)))
  }

}
