public extension String {

  func applying(style: ANSIStyle) -> String {
    style
      .apply(to: self)
  }

  func applying(foreground: ANSIColor? = nil, background: ANSIColor? = nil, bold: Bool = false) -> String {
    self
      .applying(style: .init(foreground: foreground, background: background, bold: bold))
  }

}
