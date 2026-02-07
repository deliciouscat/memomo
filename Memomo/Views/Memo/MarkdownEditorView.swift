import SwiftUI
#if canImport(MarkdownUI)
import MarkdownUI
#endif

struct MarkdownEditorView: View {
    @Binding var content: String
    @State private var isPreview: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle("Preview", isOn: $isPreview)
                .toggleStyle(.switch)

            if isPreview {
                ScrollView {
                    Group {
#if canImport(MarkdownUI)
                        Markdown(content)
#else
                        Text(renderedMarkdown)
#endif
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
                }
                .background(Color(NSColor.textBackgroundColor))
            } else {
                TextEditor(text: $content)
                    .font(.body)
                    .background(Color(NSColor.textBackgroundColor))
            }
        }
    }

    private var renderedMarkdown: AttributedString {
        (try? AttributedString(markdown: content)) ?? AttributedString(content)
    }
}
