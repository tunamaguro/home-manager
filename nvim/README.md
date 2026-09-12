# Neovim keymaps

このディレクトリの Neovim 設定で使用するキーマップの一覧です。

- `<leader>`: `Space`
- `<localleader>`: `\`
- `N`: Normal mode
- `I`: Insert mode
- `V`: Visual mode
- `S`: Select mode
- `T`: Terminal mode

`Custom` はこの設定で明示的に追加しているキーマップ、`Nvim default` は Neovim 0.12 が提供する標準キーマップです。

## Basic

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| I | `jk` | Insert mode を終了 | Custom |
| N | `<leader>w` | ファイルを保存 (`:update`) | Custom |
| N | `<leader>q` | 現在の window を閉じる | Custom |
| N | `<leader>Q` | Neovim を終了 | Custom |

## File explorer / Neo-tree

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| N | `<leader>e` | Neo-tree を開閉 | Custom |
| N | `<leader>E` | 現在のファイルを Neo-tree 上で表示 | Custom |
| N | `<leader>n` | Neo-tree にフォーカス | Custom |
| N | `<C-w>p` | 直前の window に戻る。Neo-tree から編集 window に戻る場合にも使用可能 | Nvim default |
| N | `<C-w>h/j/k/l` | 左 / 下 / 上 / 右の window に移動 | Nvim default |

Neo-tree 内部のファイル操作には Neo-tree 自身のデフォルトキーマップを使用します。

## Buffers

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| N | `[b` | 前の buffer | Custom |
| N | `]b` | 次の buffer | Custom |
| N | `<leader>bd` | 現在の buffer を削除 | Custom |
| N | `<leader>fb` | Telescope で buffer を検索 | Custom |

## Find / Telescope

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| N | `<leader>ff` | ファイル検索 | Custom |
| N | `<leader>fg` | Live grep | Custom |
| N | `<leader>fb` | Buffer 検索 | Custom |
| N | `<leader>fr` | 最近開いたファイルを検索 | Custom |
| N | `<leader>fs` | 現在の document symbols を検索 | Custom |
| N | `<leader>fS` | Workspace symbols を検索 | Custom |
| N | `<leader>fq` | Quickfix items を検索 | Custom |

### Telescope picker 内

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| I | `<C-j>` | 次の候補 | Custom |
| I | `<C-k>` | 前の候補 | Custom |

## Git

### Hunk navigation

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| N | `]h` | 次の Git hunk | Custom |
| N | `[h` | 前の Git hunk | Custom |

### Hunk preview / diff

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| N | `<leader>gp` | Hunk を preview | Custom |
| N | `<leader>gi` | Hunk を inline preview | Custom |
| N | `<leader>gd` | 現在のファイルを diff 表示 | Custom |
| N | `<leader>gs` | Telescope で変更ファイルを表示 | Custom |

### Stage / reset

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| N | `<leader>gS` | 現在の hunk を stage | Custom |
| V | `<leader>gS` | 選択範囲の hunk を stage | Custom |
| N | `<leader>gR` | 現在の hunk を reset | Custom |
| V | `<leader>gR` | 選択範囲の hunk を reset | Custom |
| N | `<leader>gu` | 直前の hunk stage を取り消す | Custom |
| N | `<leader>gA` | Buffer 全体を stage | Custom |
| N | `<leader>gX` | Buffer 全体を reset | Custom |
| N | `<leader>gq` | Git hunks を quickfix に送る | Custom |

### Blame

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| N | `<leader>gb` | 現在行の blame を表示 | Custom |
| N | `<leader>gB` | Current line blame の常時表示を切り替え | Custom |

## LSP

### Definition / navigation

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| N | `gd` | Definition へ移動 | Custom |
| N | `gD` | Declaration へ移動 | Custom |
| N | `<C-]>` | LSP の `tagfunc` を使って definition へ移動 | Nvim default |
| N | `gri` | Implementation へ移動 | Nvim default |
| N | `grr` | References を表示 | Nvim default |
| N | `grt` | Type definition へ移動 | Nvim default |
| N | `gO` | Document symbols を表示 | Nvim default |

### Refactor / information

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| N / V | `gra` | Code action | Nvim default |
| N | `grn` | Rename | Nvim default |
| N | `grx` | Code lens を実行 | Nvim default |
| N | `K` | Hover documentation | Nvim default |
| I | `<C-s>` | Signature help | Nvim default |

### Format / diagnostics

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| N | `<leader>lf` | 現在の buffer を LSP formatter で format | Custom |
| N | `<leader>lq` | Diagnostics を quickfix に送る | Custom |
| N | `]d` | 次の diagnostic | Nvim default |
| N | `[d` | 前の diagnostic | Nvim default |
| N | `]D` | 最後の diagnostic | Nvim default |
| N | `[D` | 最初の diagnostic | Nvim default |
| N | `<C-w>d` | Cursor 位置の diagnostic を floating window で表示 | Nvim default |

LSP server が formatting をサポートしている場合、保存時にも自動で format します。

## Completion / snippets

LSP completion は Neovim 0.12 の native completion を使用します。LSP server の `triggerCharacters` に応じて自動起動し、必要な場合は手動でも起動できます。

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| I | `<C-Space>` | LSP completion を手動起動 | Custom |
| I | `<C-n>` | 次の completion candidate | Nvim default |
| I | `<C-p>` | 前の completion candidate | Nvim default |
| I | `<C-y>` | 選択中の completion candidate を確定 | Nvim default |
| I / S | `<Tab>` | Snippet が active の場合、次の placeholder へ移動 | Nvim default |
| I / S | `<S-Tab>` | Snippet が active の場合、前の placeholder へ移動 | Nvim default |

Buffer/path completion は使用せず、LSP completion を中心にしています。

## Terminal / ToggleTerm

すべての ToggleTerm terminal は floating window で表示します。永続 terminal は window を閉じても shell process と terminal buffer を保持し、同じキーで再表示できます。

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| N / T | `<leader>t1` | 永続 terminal 1 を開閉 | Custom |
| N / T | `<leader>t2` | 永続 terminal 2 を開閉 | Custom |
| N / T | `<leader>t3` | 永続 terminal 3 を開閉 | Custom |
| N / T | `<leader>tt` | 一時 terminal を開閉 | Custom |
| T | `<C-\><C-n>` | Terminal mode から Normal mode に移動 | Nvim default |

### Persistent terminals

`<leader>t1`、`<leader>t2`、`<leader>t3` はそれぞれ独立した terminal session です。float を閉じても shell process は終了しないため、実行中の command や shell の状態を保持したまま再表示できます。

### Temporary terminal

`<leader>tt` は一時的な terminal を作成します。float を閉じると terminal buffer と shell process を破棄するため、次に `<leader>tt` を押したときは新しい terminal session が作成されます。

Terminal 内で shell process 自体が終了した場合も `close_on_exit = true` により float を閉じます。

## Which-key

| Mode | Key | Action | Source |
| --- | --- | --- | --- |
| N | `<leader>?` | Leader keymaps を表示 | Custom |
| N | `<leader>b?` | Buffer-local keymaps を表示 | Custom |

Which-key では以下の prefix をグループ化しています。

| Prefix | Group |
| --- | --- |
| `<leader>b` | Buffer |
| `<leader>f` | Find |
| `<leader>g` | Git |
| `<leader>l` | LSP |
| `<leader>t` | Terminal |

## Useful workflows

### Neo-tree と編集 window の往復

1. `<leader>n` で Neo-tree にフォーカス
2. `<C-w>p` で直前の編集 window に戻る

### Diagnostics を一覧から探す

1. `<leader>lq` で diagnostics を quickfix に送る
2. `<leader>fq` で Telescope から quickfix を検索

### Git hunks を一覧から探す

1. `<leader>gq` で hunks を quickfix に送る
2. `<leader>fq` で Telescope から quickfix を検索
