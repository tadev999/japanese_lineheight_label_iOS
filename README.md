# JapaneseLineHeightLabel

`JapaneseLineHeightLabel` is a custom `UILabel` that applies a fixed line height and stable vertical text alignment, especially useful for Japanese fonts.

## When to Use

- You want consistent line height (`lineHeight`) between design and runtime.
- You want fine-tuned vertical positioning with `customBaselineOffset`.
- You want to configure values directly in Storyboard/XIB using `@IBInspectable`.

## Quick Setup (Storyboard/XIB)

1. Drag a `UILabel` into your screen.
2. Change its class to `JapaneseLineHeightLabel`.
3. Configure these values in Attributes Inspector:
- `lineHeight`: target line height in points. Set `0` to keep default `UILabel` behavior.
- `customBaselineOffset`: font-specific baseline adjustment. Positive values move text upward.

## Usage in Code

```swift
let label = JapaneseLineHeightLabel()
label.font = UIFont.systemFont(ofSize: 14)
label.textColor = .label
label.textAlignment = .left
label.lineBreakMode = .byWordWrapping

label.lineHeight = 20
label.customBaselineOffset = 0
label.text = "Consistent line height across multiple lines"
```

## Behavior Notes

- Whenever `text`, `font`, `textColor`, `textAlignment`, `lineBreakMode`, `lineHeight`, or `customBaselineOffset` changes, the label automatically rebuilds `attributedText`.
- If `attributedText` is set externally, the class normalizes it using current rules (`lineHeight`, `baselineOffset`, color, and alignment).
- The class includes an internal guard to prevent recursive update loops.

## Tuning Tips

- Start with `lineHeight = font.lineHeight` to stay close to default layout, then increase gradually.
- Adjust `customBaselineOffset` in small steps (for example, `0.5` to `1.0`) until the text visually aligns as expected.

## Troubleshooting

- Line height is not applied: verify that `lineHeight > 0`.
- Text looks vertically misaligned: decrease/increase `customBaselineOffset`.
- Text color is unexpected: ensure `textColor` is set after label initialization (especially when overriding theme defaults).
