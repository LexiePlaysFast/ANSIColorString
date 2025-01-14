import Testing
import ANSIColorString

@Test func colorValues() async throws {
  let black = ANSIColor.black

  #expect(black.rawValue == 0)

  let pink = ANSIColor.color(red: 5, green: 1, blue: 3)

  #expect(pink.rawValue == 205)

  let gray = ANSIColor.grayscale(intensity: 10)

  #expect(gray.rawValue == 242)
}

@Test func paletteIndex() async throws {
  let magenta1 = ANSIColor.brightMagenta
  let magenta2 = ANSIColor.palette(index: 13)
  let magenta3 = ANSIColor.brightPalette(index: 5)

  #expect(magenta1 == magenta2)
  #expect(magenta2 == magenta3)
}

@Test func style() async throws {
  let style = ANSIStyle(foreground: .black)

  #expect(style.foreground == .black)
  #expect(style.background == nil)
  #expect(style.bold == nil)

  let baseString = "test string"
  let string = baseString.applying(style: style)

  #expect(string == "\u{001B}[38;5;0mtest string\u{001B}[0m")

  let otherString = baseString.applying(foreground: .black)

  #expect(string == otherString)
}

@Test func styleContext() async throws {
  let contextStyle1 = ANSIStyle(background: .red)
  let contextStyle2 = ANSIStyle(foreground: .blue)
  let realStyle = ANSIStyle(foreground: .green, bold: true)

  #expect(realStyle.in(context: contextStyle1) == ANSIStyle(foreground: .green, background: .red, bold: true))
  #expect(realStyle.in(context: contextStyle2) == ANSIStyle(foreground: .green, background:  nil, bold: true))
}

@Test func styledString() async throws {
  let style = ANSIStyle(foreground: .red)

  var string: ANSIColorString = "test string"

  #expect(string.description == "test string")

  string.style = style

  #expect(string.description == "\u{001B}[38;5;1mtest string\u{001B}[0m")
}

@Test func embeddedString() async throws {
  let style = ANSIStyle(foreground: .red)

  var string: ANSIColorString = ""

  string.style = style

  string.append(string: "foo ")
  string.append(style: .init(foreground: .blue, bold: true), string: "bar")
  string.append(string: " baz")

  #expect(string.description == "\u{001B}[38;5;1mfoo \u{001B}[38;5;4;1mbar\u{001B}[38;5;1;22m baz\u{001B}[0m")
}
