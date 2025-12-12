# JSON Unescape & Formatter

A VS Code extension to convert escaped JSON strings into beautifully formatted JSON and vice versa. Perfect for developers working with API responses, log files, or any escaped JSON data.

## Features

✨ **Unescape & Format JSON**: Convert escaped JSON strings like `"{\"name\":\"value\"}"` into properly formatted JSON

🔄 **Reverse Operation**: Convert formatted JSON back into escaped string literals

📋 **Clipboard Support**: Directly convert JSON from your clipboard

⚡ **Multiple Access Methods**: Keyboard shortcuts, context menu, and command palette

## Usage

### Example

**Input (escaped JSON string):**
```
"{\"eventType\":\"FileUploadedEvent\",\"fileId\":\"0a24a478-fca0-46ab-a732-c256f8a846c7\",\"fileName\":\"document.pdf\"}"
```

**Output (formatted JSON):**
```json
{
  "eventType": "FileUploadedEvent",
  "fileId": "0a24a478-fca0-46ab-a732-c256f8a846c7",
  "fileName": "document.pdf"
}
```

## Commands

- **Unescape & Format JSON** (`Ctrl+Alt+J`): Convert selected text or entire document
- **Unescape Selected Escaped JSON**: Available in right-click context menu when text is selected
- **Convert JSON → Escaped String**: Reverse operation - convert JSON to escaped string
- **Unescape JSON from Clipboard**: Convert JSON from clipboard and insert into editor

## How to Use

1. **Select** the escaped JSON string in your editor
2. **Right-click** and choose "Unescape Selected Escaped JSON"
   - Or press `Ctrl+Alt+J`
   - Or open Command Palette (`Ctrl+Shift+P`) and search for "Unescape"
3. The text will be replaced with formatted JSON

## Installation

Install from the VS Code Marketplace or search for "JSON Unescape & Formatter" in the Extensions view (`Ctrl+Shift+X`).

## Requirements

No additional requirements or dependencies needed.

## Release Notes

### 0.1.0

Initial release with core features:
- Unescape and format escaped JSON strings
- Convert JSON to escaped strings
- Clipboard support
- Context menu integration
- Keyboard shortcuts

## License

MIT

---

**Enjoy!** 🎉
