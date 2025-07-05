# pandoc-ruby-filter

このプロジェクトは [kotobuki](https://github.com/kotobuki/pandoc-ruby-filter) さんによる [pandoc-ruby-filter](https://github.com/kotobuki/pandoc-ruby-filter) をフォークし、対応ファイルのフォーマットを拡充したものです。オリジナル版が対応しているのは LaTeX と HTML ですが、そこかさらに EPUB および DOCX、[Typst](https://typst.app/) に対応させました。
以下はオリジナル版の概要説明です。

> この [Pandoc](https://pandoc.org/) 用フィルターは、文章中のルビ表記を処理して、LaTeX や HTML などの出力形式に合わせて変換します。このフィルターを制作するにあたり、[minoki](https://github.com/minoki) さんの[pandoc-aozora-ruby](https://github.com/minoki/pandoc-aozora-ruby)を参照しています。ただし、pandoc-aozora-ruby でサポートされていた省略記法（漢字から始まる文字列に対して｜を省略できる）には対応していません。

## 入力形式

フィルターは、以下の形式のルビ表記を認識します。

`｜単語《よみがな》`

## 出力形式

フィルターは、出力形式に応じて次のようにルビ表記を変換します。

- LaTeX の場合： `\ruby{単語}{よみがな}`
- HTML の場合： `<ruby>単語<rp>《</rp><rt>よみがな</rt><rp>》</rp></ruby>`
- **EPUB の場合**： `<ruby>単語<rp>《</rp><rt>よみがな</rt><rp>》</rp></ruby>`
- **Typst の場合**： `#ruby[よみがな][単語];`
  - Typst は単体ではルビに対応していません。この形式は [rubby](https://typst.app/universe/package/rubby) パッケージのサンプルコードにある関数 `ruby` に合わせたものです
- **DOCX の場合**： `<w:r><w:ruby><w:rt><w:r><w:t>よみがな</w:t></w:r></w:rt><w:rubyBase><w:r><w:t>単語</w:t></w:r></w:rubyBase></w:ruby></w:r>`
- 上記以外の場合： 入力形式と同じまま維持されます。

## 使い方

1. Pandoc がインストールされていることを確認してください（[Pandoc のインストール方法](https://pandoc.org/installing.html)）。
2. 本リポジトリをダウンロードし、Lua スクリプト（`ruby_filter.lua`）をパスの通っている場所に移動するか、適当な場所に移動してパスを通します。
3. Pandoc コマンドで、`--lua-filter`オプションを使用してフィルターを適用します。例：

```sh
pandoc input.md --lua-filter=ruby_filter.lua -o output.epub
```

この例では、`input.md`という Markdown ファイルを入力として使用し、フィルターを適用して`output.html`という HTML ファイルを生成しています。

## 注意事項

このフィルターは、Pandoc の`Str` 要素（文字列）を処理します。そのため、ルビ表記が複数の`Str`要素にまたがっている場合、正しく処理されないことがあります。ルビ表記が正しく認識されるように、適切な場所で改行や空白を挿入してください。

## 備考

`｜単語《よみがな》` に加えて `単語《よみがな》` の省略記法にも対応させようと考えたのですが、Lua の標準ライブラリはシングルバイト文字のみを想定しているため、ライブラリを使わず単体で行うのは難しいと断念しました 😔
