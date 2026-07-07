import UIKit

@IBDesignable
final class JapaneseLineHeightLabel: UILabel {

    // MARK: - Constants

    private enum Constants {
        static let fallbackFontSize: CGFloat = 10
    }

    // MARK: - Inspectable Properties

    /// Target line height applied to every line in this label.
    /// Set to 0 to keep the default UILabel rendering.
    @IBInspectable
    var lineHeight: CGFloat = 0 {
        didSet {
            updateAttributedText()
        }
    }

    /// Extra offset for font-specific tuning in Interface Builder.
    /// Positive value moves text upward.
    @IBInspectable
    var customBaselineOffset: CGFloat = 0 {
        didSet {
            updateAttributedText()
        }
    }

    // MARK: - UILabel Overrides

    /// Rebuild attributed string whenever plain text changes.
    override var text: String? {
        didSet {
            updateAttributedText()
        }
    }
    
    /// Recalculate line metrics when font changes.
    override var font: UIFont! {
        didSet {
            updateAttributedText()
        }
    }
    
    /// Keep text color in sync with rebuilt attributes.
    override var textColor: UIColor! {
        didSet {
            updateAttributedText()
        }
    }
    
    /// Respect alignment updates from code/IB.
    override var textAlignment: NSTextAlignment {
        didSet {
            updateAttributedText()
        }
    }

    /// Keep paragraph line-break behavior in sync with rebuilt attributes.
    override var lineBreakMode: NSLineBreakMode {
        didSet {
            updateAttributedText()
        }
    }

    /// If external code sets attributedText directly, normalize it to this class style.
    override var attributedText: NSAttributedString? {
        didSet {
            if !isUpdatingText {
                updateAttributedText()
            }
        }
    }
    
    /// Prevent recursive updates when this class sets `super.attributedText` internally.
    private var isUpdatingText = false

    // MARK: - Internal Styling

    private func updateAttributedText() {
        // Apply only when custom line height is enabled.
        guard lineHeight > 0 else { return }
        // Stop re-entrant execution caused by property observers.
        guard !isUpdatingText else { return }

        // Prefer plain text; fall back to current attributed text content.
        let currentText = super.text ?? super.attributedText?.string ?? ""
        guard !currentText.isEmpty else { return }
        
        isUpdatingText = true
        defer { isUpdatingText = false }
        
        // Font drives actual glyph height, used for vertical centering.
        let currentFont = font ?? UIFont.systemFont(ofSize: Constants.fallbackFontSize)
        let actualLineHeight = currentFont.lineHeight
        
        // Force fixed line height for every line.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = lineBreakMode
        
        // Vertically center glyphs in the target line height.
        let offset = ((lineHeight - actualLineHeight) / 2) + customBaselineOffset
        
        // Rebuild all relevant text attributes in one place.
        let attributes: [NSAttributedString.Key: Any] = [
            .font: currentFont,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: textColor ?? UIColor.label,
            .baselineOffset: offset
        ]
        
        // Set attributed text through super to avoid triggering overridden observer logic.
        super.attributedText = NSAttributedString(string: currentText, attributes: attributes)
    }
    
    /// Render correctly in Interface Builder canvas.
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateAttributedText()
    }
    
    /// Apply style after nib/xib loading.
    override func awakeFromNib() {
        super.awakeFromNib()
        updateAttributedText()
    }

    /// Re-apply after layout in case geometry-dependent properties changed.
    override func layoutSubviews() {
        super.layoutSubviews()
        updateAttributedText()
    }
}
