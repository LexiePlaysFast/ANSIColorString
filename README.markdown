# ANSIColorString

This is a simple library for doing a simple thing: Adding ANSI escape code-based colors and simple styles to Swift `String`s.

The primary interface for this library is the `String` extension `.applying(style:)`, and its destructured cousin, `.applyingStyle(foreground:background:bold)`. The former is useful for repeatedly applying the same style, while the latter is useful for ad-hoc applications.

```swift

let style = ANSIStyle(background: .red)

let aMillionUnstyledStrings: [String] = // . . .
let aMillionStyledStrings: [String] = aMillionUnstyledStrings.map {
  $0.applying(style: style)
}

let unstyledString = "Hello, world!"
let styledString = unstyledString.applying(foreground: .black, background: .green, bold: true)

```

The beating heart of this library is `ANSIColor`'s public interface, providing for the following facilities:

```swift

let colorExamples: [ANSIColor] = [
  // Named palette colors
  .black,
  .brightMagenta,
  // indexed and indexed bright colors (0...15)/(0...7)
  .palette(index: 3),       // "yellow"
  .palette(index: 12),      // bright blue
  .brightPalette(index: 4), // bright blue
  // RGB colors (6x6x6)
  .color(red: 2, green: 4, blue: 1),
  // grayscale (0...23)
  .grayscale(intensity: 3),
]
```

These facilities are provided separate from any other console knowledge.
