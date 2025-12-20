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
