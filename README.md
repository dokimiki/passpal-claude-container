# Claude Container

Claude CLI を動かすためのDockerコンテナ環境です。

## 構成

- **Base**: Ubuntu 22.04
- **Claude CLI**: npm でインストール
- **ツール**: git, nodejs, npm, ripgrep, GitHub CLI (gh)
- **ユーザー**: claude (sudo権限付き)
- **ボリューム**: `claude-home` が `/home/claude` にマウント

## 使用方法

### 起動

```bash
./start.sh
```

### アクセス方法

#### Claude を直接実行
```bash
docker compose exec claude claude
```

#### コンテナに接続
```bash
docker compose exec claude bash
```

#### 複数セッション
```bash
# 複数のターミナルから同時接続可能
docker compose exec claude bash    # ターミナル1
docker compose exec claude claude  # ターミナル2
docker compose exec claude bash    # ターミナル3
```

#### バックグラウンド実行 (tmux使用)
```bash
# tmuxセッションでClaudeを実行
docker compose exec claude tmux new-session -d -s claude-session 'claude'
docker compose exec claude tmux attach -t claude-session

# デタッチ: Ctrl+B, D
# 再接続: docker compose exec claude tmux attach -t claude-session
```

#### コマンド実行
```bash
docker compose exec claude git status
docker compose exec claude npm install
```

#### ログ確認
```bash
docker compose logs claude
```

### 停止

```bash
docker compose down
```

## ボリューム

`claude-home` ボリュームがコンテナの `/home/claude` にマウントされます。
データは永続化されるため、コンテナを再起動してもファイルは保持されます。

## 手動ビルド

```bash
docker compose build
docker compose up -d
```