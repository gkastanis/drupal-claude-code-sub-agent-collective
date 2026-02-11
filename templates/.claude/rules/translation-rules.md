# Translation Rules

## PHP Translation

- Wrap all user-facing text in `t()` or `TranslatableMarkup`.
- Use module name as context (PHP string, not constant).
- English in code, translations in `/translations/*.po` files with `msgctxt`.

## Twig Translation

- Use `|t` filter for translatable strings in Twig templates.
- Use `{% trans %}` blocks for complex translatable content with placeholders.

## PO File Format

```
msgctxt "my_module"
msgid "Original English text"
msgstr "Translated text"
```
