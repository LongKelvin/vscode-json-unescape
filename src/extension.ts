import * as vscode from 'vscode';

function tryParseJson(text: string): any | null {
  try {
    return JSON.parse(text);
  } catch {
    return null;
  }
}

function unescapeAndParse(text: string): any {
  const trimmed = text.trim();

  const directParse = tryParseJson(trimmed);
  if (directParse !== null) {
    if (typeof directParse === 'string') {
      const innerParse = tryParseJson(directParse);
      if (innerParse !== null) return innerParse;
    } else {
      return directParse;
    }
  }

  if ((trimmed.startsWith('"') && trimmed.endsWith('"')) ||
      (trimmed.startsWith("'") && trimmed.endsWith("'"))) {
    try {
      const unquoted = JSON.parse(trimmed);
      if (typeof unquoted === 'string') {
        const parsedInner = tryParseJson(unquoted);
        if (parsedInner !== null) return parsedInner;
      }
      if (typeof unquoted === 'object' && unquoted !== null) {
        return unquoted;
      }
      return unquoted;
    } catch {}
  }

  try {
    const replaced = trimmed.replace(/\\"/g, '"');
    const attempt = tryParseJson(replaced);
    if (attempt !== null) return attempt;
  } catch {}

  try {
    const wrapped = JSON.stringify(trimmed);
    const unescaped = JSON.parse(wrapped);
    const parsed = tryParseJson(unescaped);
    if (parsed !== null) return parsed;
    return unescaped;
  } catch {
    throw new Error('Could not parse input as JSON or escaped JSON.');
  }
}

function convertToEscapedString(value: any, wrapQuotes = true): string {
  if (typeof value === 'string') {
    try {
      const parsed = JSON.parse(value);
      const str = JSON.stringify(parsed);
      return wrapQuotes ? JSON.stringify(str) : str;
    } catch {
      const escaped = value
        .replace(/\\/g, '\\\\')
        .replace(/"/g, '\\"')
        .replace(/\n/g, '\\n')
        .replace(/\r/g, '\\r')
        .replace(/\t/g, '\\t');
      return wrapQuotes ? `"${escaped}"` : escaped;
    }
  }

  const json = JSON.stringify(value, null, 2);
  const escaped = json
    .replace(/\\/g, '\\\\')
    .replace(/"/g, '\\"')
    .replace(/\n/g, '\\n')
    .replace(/\r/g, '\\r')
    .replace(/\t/g, '\\t');
  return wrapQuotes ? `"${escaped}"` : escaped;
}

async function replaceText(editor: vscode.TextEditor, newText: string) {
  await editor.edit(editBuilder => {
    const selection = editor.selection;
    if (selection.isEmpty) {
      const fullRange = new vscode.Range(
        new vscode.Position(0, 0),
        new vscode.Position(editor.document.lineCount, 0)
      );
      editBuilder.replace(fullRange, newText);
    } else {
      editBuilder.replace(selection, newText);
    }
  });
}

function getActiveEditor(): vscode.TextEditor | undefined {
  const editor = vscode.window.activeTextEditor;
  if (!editor) {
    vscode.window.showErrorMessage('No active editor.');
  }
  return editor;
}

function getText(editor: vscode.TextEditor): string {
  return editor.document.getText(
    editor.selection.isEmpty ? undefined : editor.selection
  );
}

async function convertToJson() {
  const editor = getActiveEditor();
  if (!editor) return;

  try {
    const text = getText(editor);
    const parsed = unescapeAndParse(text);
    const pretty = JSON.stringify(parsed, null, 2);
    await replaceText(editor, pretty);
    vscode.window.showInformationMessage('Converted to pretty JSON.');
  } catch (err: any) {
    vscode.window.showErrorMessage(`Conversion failed: ${err.message}`);
  }
}

async function convertSelectionToJson() {
  const editor = getActiveEditor();
  if (!editor) return;

  if (editor.selection.isEmpty) {
    vscode.window.showInformationMessage('Select the escaped JSON string first.');
    return;
  }

  try {
    const text = getText(editor);
    const parsed = unescapeAndParse(text);
    const pretty = JSON.stringify(parsed, null, 2);
    await replaceText(editor, pretty);
    vscode.window.showInformationMessage('Selection converted to pretty JSON.');
  } catch (err: any) {
    vscode.window.showErrorMessage(`Conversion failed: ${err.message}`);
  }
}

async function convertToEscaped() {
  const editor = getActiveEditor();
  if (!editor) return;

  const text = getText(editor);
  let value = tryParseJson(text) ?? tryParseJson(text.trim()) ?? text;

  try {
    const escaped = convertToEscapedString(value, true);
    await replaceText(editor, escaped);
    vscode.window.showInformationMessage('Converted JSON → escaped string.');
  } catch (err: any) {
    vscode.window.showErrorMessage(`Conversion failed: ${err.message}`);
  }
}

async function convertClipboardToJson() {
  const editor = getActiveEditor();
  if (!editor) return;

  try {
    const clip = await vscode.env.clipboard.readText();
    if (!clip || clip.trim().length === 0) {
      vscode.window.showInformationMessage('Clipboard is empty.');
      return;
    }
    const parsed = unescapeAndParse(clip);
    const pretty = JSON.stringify(parsed, null, 2);
    await replaceText(editor, pretty);
    vscode.window.showInformationMessage('Clipboard JSON converted and inserted.');
  } catch (err: any) {
    vscode.window.showErrorMessage(`Clipboard conversion failed: ${err.message}`);
  }
}

export function activate(context: vscode.ExtensionContext) {
  const commands = [
    vscode.commands.registerCommand('extension.convertToJson', convertToJson),
    vscode.commands.registerCommand('extension.convertSelectionToJson', convertSelectionToJson),
    vscode.commands.registerCommand('extension.convertToEscaped', convertToEscaped),
    vscode.commands.registerCommand('extension.convertClipboardToJson', convertClipboardToJson)
  ];

  context.subscriptions.push(...commands);
}

export function deactivate() {}