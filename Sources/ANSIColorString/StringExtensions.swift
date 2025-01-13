public extension String {

  func applying(style: ANSIStyle, in context: ANSIStyle? = nil) -> String {
    style
      .apply(to: self, in: context)
  }

  func applying(foreground: ANSIColor? = nil, background: ANSIColor? = nil, bold: Bool? = nil) -> String {
    self
      .applying(style: .init(foreground: foreground, background: background, bold: bold))
  }

}
