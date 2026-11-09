# App-nup 開発メモ

## コマンド名 "nup" について (2024-12-20)

### 既存の同名コマンド調査

1. **nup (Debian dvi2ps 関連)**
   - dvi2ps 用の古い N-up ツール
   - 参考: https://www.unix.com/man-page/debian/1/NUP/
   - 使用例: `dvi2ps foo.dvi | nup -2 | lpr`
   - 現在はほぼ廃れている

2. **psnup (psutils パッケージ)**
   - PostScript 用の N-up ツール（広く使われている）
   - `nup` ではなく `psnup` という名前
   - 使用例: `psnup -2 file.ps`

3. **CPAN**
   - `nup` という名前の Perl モジュール/スクリプトは存在しない

### 結論

- `nup` という名前は dvi2ps 用の古いツールで使われているが、現在はほぼ廃れている
- CPAN には同名のものはない
- `psnup` とは異なる名前
- 実質的な名前衝突の問題は低い

## 拡張候補: 重ね打ちの太字・下線を SGR に変換する (2026-11-09)

### 現象

`nup --green-board man nup` など、背景色を付けるオプションで man を
表示すると、太字の見出しの後ろの背景が端末の既定色 (白) に戻り、
行末まで帯のように見える。

### 原因

- man の太字・下線はバックスペースの重ね打ち (`c^Hc`, `_^Hc`)
- ansicolumn は重ね打ちを色指定と見なさず、そのまま通す
- less は重ね打ちを terminfo の bold で描き、終わりに sgr0
  (`\e(B\e[m`) で属性を全部リセットする。-R で通した ANSI の色を
  覚えて戻すことはしないので、行の残りは既定の背景になる
- less 709x (tecolicom/tap) と /usr/bin/less 581.2 の両方で再現
- SGR の太字 (`\e[1m...\e[0m`) なら、ansicolumn がリセットの後に
  色を入れ直すので崩れない。perldoc (`PERLDOC=-MPod::Text::Termcap`)
  が大丈夫なのはこのため

### man が重ね打ちになる環境

- macOS: man は mandoc で整形し、太字は常に重ね打ち。mandoc に SGR
  出力はない。mandoc が扱えないページだけ groff で整形され、
  MANCOLOR が空なら `-P-c` で重ね打ちになる (`/usr/bin/man`)
- Linux: grotty の既定は SGR だが、Debian 系は `/etc/groff/man.local`
  で SGR を切っていて重ね打ち (`GROFF_SGR` を設定すると SGR)。
  Arch も 2009 年に同様の変更。実機では未確認

### 案

ansicolumn に渡す前に、重ね打ちを SGR に変換する。

- `c^Hc` → `\e[1mc\e[0m` (連続する文字はまとめる)
- `_^Hc` → `\e[4mc\e[0m`
- 変換は既定でするか、背景色を使うオプション (--*-board, --cm) の
  ときだけにするかは要検討
