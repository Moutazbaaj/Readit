import SwiftUI

struct HighlightedText: View {
    let text: String
    let highlightedRange: NSRange?

    var body: some View {
        let attributedString = NSMutableAttributedString(string: text)
        
        if let range = highlightedRange, range.location + range.length <= text.utf16.count {
            attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
        }
        
        return Text(AttributedString(attributedString))
    }
}