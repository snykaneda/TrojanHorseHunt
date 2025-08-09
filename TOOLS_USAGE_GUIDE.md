# 🛠️ ツール群使用ガイド：TrojanHorseHunt マルチセッション開発

**対象**: TrojanHorseHuntプロジェクト研究者・開発者  
**更新日**: 2025年1月9日

---

## 📋 概要

このガイドでは、TrojanHorseHuntプロジェクト用に構築したマルチセッション開発ツール群の詳細な使用方法を説明します。効率的な研究開発のため、各ツールの特徴・用途・実行方法を理解して活用してください。

## 🧰 ツール群一覧

| ツール名 | ファイル | 主要機能 | 使用頻度 |
|---------|---------|----------|----------|
| セッション開始 | `scripts/start-session.sh` | 新規セッション自動セットアップ | 日次 |
| セッション終了 | `scripts/end-session.sh` | セッション整理・統合処理 | 日次 |
| ブランチ状況確認 | `scripts/branch-status.sh` | プロジェクト状況可視化 | 日次-週次 |
| ブランチ戦略ガイド | `BRANCHING_STRATEGY.md` | 開発ワークフロー仕様 | 参照用 |
| 運用ガイド | `MULTI_SESSION_GUIDE.md` | 実践的な運用方法 | 参照用 |

---

## 🚀 1. セッション開始ツール (`start-session.sh`)

### 目的・用途
新しい研究セッション開始時の定型作業を自動化。実験環境のセットアップ、ブランチ作成、テンプレート生成を一括実行。

### 基本使用法

#### 標準的な実験セッション開始
```bash
# developブランチベースの実験セッション開始
./scripts/start-session.sh
```
**実行結果**:
- セッションブランチ作成: `experiment/session-20250109-1430`
- セッションディレクトリ作成: `02_notebooks/sessions/session-20250109-1430/`
- Jupyterノートブック生成: `session_notebook.ipynb`
- README生成: セッション記録用テンプレート

#### 特定ブランチからのセッション開始
```bash
# 既存のfeatureブランチから分岐
./scripts/start-session.sh feature/trigger-detection

# 特定のセッションから継続
./scripts/start-session.sh experiment/session-20250108-1500
```

#### 機能開発セッション開始
```bash
# 長期開発用featureブランチとして開始
./scripts/start-session.sh develop feature
```
**実行結果**:
- featureブランチ作成: `feature/session-20250109-1430`
- 長期開発向けディレクトリ構造生成

### 高度な使用例

#### パラメータ調整実験
```bash
# データ分析ブランチベースでの実験
./scripts/start-session.sh feature/data-analysis

# 実行後、Jupyter起動
jupyter notebook 02_notebooks/sessions/session-*/session_notebook.ipynb
```

#### アルゴリズム比較研究
```bash
# ベースライン手法から分岐して新手法検証
./scripts/start-session.sh feature/baseline-methods
```

### 生成されるファイル構造詳細

```
02_notebooks/sessions/session-YYYYMMDD-HHMM/
├── README.md                    # セッション記録テンプレート
├── session_notebook.ipynb       # 実験用Jupyterノートブック
├── experiment_logs/             # 実験ログディレクトリ
└── results/                     # 出力・結果保存用
```

#### `README.md` テンプレート内容
```markdown
# Research Session: session-YYYYMMDD-HHMM

**Started:** 2025-01-09 14:30:00
**Base Branch:** develop
**Session Type:** experiment

## Objectives
- [ ] Define research objectives
- [ ] Setup experimental environment
- [ ] Run experiments and record results
- [ ] Document findings and insights

## Experiments
- [ ] Experiment 1: [Description]
- [ ] Experiment 2: [Description]

## Results
[Record your findings here]

## Next Steps
[Plans for future sessions]
```

#### Jupyterノートブックテンプレート
- プロジェクトパス自動設定
- 必要ライブラリ自動インポート
- 実験記録用セル構造
- 結果可視化テンプレート

---

## 🏁 2. セッション終了ツール (`end-session.sh`)

### 目的・用途
セッション終了時の成果整理・統合判断・クリーンアップ処理を対話形式で実行。研究成果の散逸防止と効率的な知見継承を実現。

### 基本使用法

#### 標準的なセッション終了
```bash
./scripts/end-session.sh
```

### 出力情報詳細

#### セッション統計レポート
```
🔍 Ending research session: session-20250109-1430
📊 Session Summary:
==================================
📈 Commits in this session:
a1b2c3d experiment: test parameter X=0.5, accuracy=85%
e4f5g6h results: visualization of detection patterns
i7j8k9l docs: update experiment findings

📝 Changed files:
M    02_notebooks/sessions/session-20250109-1430/session_notebook.ipynb
A    03_src/detection/new_algorithm.py
M    README.md

🔢 Session statistics:
  - Total commits: 3
  - Files modified: 3
  - Lines added/removed: +127 -15
```

### 4つの終了オプション詳細

#### オプション1: Keep branch for future reference
**用途**: 後で参照する可能性がある実験セッション  
**処理**: ブランチをリモートにプッシュして保存  
```bash
📚 Session branch preserved for future reference
✅ Branch pushed to remote: experiment/session-20250109-1430
```

#### オプション2: Merge valuable changes to develop
**用途**: 有用な成果をdevelopブランチに統合  
**処理**: developブランチへのマージ実行  
```bash
🔄 Merging valuable changes to develop...
✅ Changes merged to develop
🗑️  Delete local session branch? (y/n): y
```

#### オプション3: Delete session branch (cleanup)
**用途**: 成果がない、または他で複製済みの実験  
**処理**: ローカル・リモートブランチ削除  
```bash
🗑️ Cleaning up session branch...
🌐 Delete remote branch too? (y/n): y
🗑️ Session branch deleted
```

#### オプション4: Create archive and cleanup
**用途**: 記録として保存するが日常的なアクセスは不要  
**処理**: アーカイブ作成後クリーンアップ  

**生成されるアーカイブ**:
```
06_reports/archived_sessions/
├── session-20250109-1430_summary.md    # セッション要約
├── session-20250109-1430/              # セッション成果物コピー
│   ├── README.md
│   ├── session_notebook.ipynb
│   └── results/
└── ...
```

### Cherry-pick推奨機能

セッションで有用な変更がある場合、適切なfeatureブランチへのcherry-pick方法を提案：

```bash
🍒 Cherry-pick suggestions:
  git checkout feature/data-analysis
  git cherry-pick a1b2c3d

📋 Available feature branches:
feature/baseline-methods
feature/data-analysis
feature/gradient-methods
feature/model-forensics
feature/optimization-methods
feature/trigger-detection
```

---

## 📊 3. ブランチ状況確認ツール (`branch-status.sh`)

### 目的・用途
プロジェクト全体のGitブランチ状況を包括的に可視化。開発進捗確認、同期状況チェック、クリーンアップ対象特定を効率的に実行。

### 基本使用法

```bash
./scripts/branch-status.sh
```

### 出力情報詳細

#### 1. 基本情報セクション
```
🌳 TrojanHorseHunt Git Tree Status
==================================

📍 Current branch: develop
🔄 Last update: 2 hours ago (3008d50)
```

#### 2. ブランチ分類表示
```bash
📋 All Branches:
----------------
🛡️ Protected branches:
  main
  develop

🔬 Feature branches:
  feature/baseline-methods
  feature/data-analysis
  feature/gradient-methods
  feature/model-forensics
  feature/optimization-methods
  feature/trigger-detection

🧪 Experiment branches:
  experiment/session-20250109-1430
  experiment/session-20250108-1500
```

#### 3. ブランチ関係性分析
```bash
🔍 Branch Relationships:
------------------------
📊 develop vs main:
  - Ahead by 5 commits
  - Behind by 0 commits
  - Recent commits on develop:
    3008d50 Implement comprehensive multi-session Git workflow system
    4340f9d Add comprehensive README.md for TrojanHorseHunt project
    329bf8a Initial commit: TrojanHorseHunt cybersecurity research project
```

#### 4. 最近のアクティビティ
```bash
⚡ Recent Activity (last 10 commits):
-------------------------------------
  * 3008d50 (HEAD -> develop, origin/develop) Implement comprehensive multi-session Git workflow system
  * 4340f9d Add comprehensive README.md for TrojanHorseHunt project
  * 329bf8a (origin/main, main) Initial commit: TrojanHorseHunt cybersecurity research project
```

#### 5. 同期状況確認
```bash
🌐 Local vs Remote Status:
--------------------------
📥 Local only branches:
  experiment/session-20250109-1430

📤 Remote only branches:
  None
```

#### 6. 推奨アクション
```bash
💡 Recommended Actions:
----------------------
  🔄 Pull latest changes: git pull origin develop
  🧹 Consider cleaning up old branches (>30 days):
    old-feature-branch 2024-12-01
```

### 高度な使用例

#### 定期的なプロジェクト健全性チェック
```bash
# 朝の作業開始前チェック
./scripts/branch-status.sh

# クリーンアップ対象確認
./scripts/branch-status.sh | grep "Consider cleaning"
```

#### 開発チーム状況共有
```bash
# チーム会議での状況共有用
./scripts/branch-status.sh > daily_status_report.txt
```

---

## 📖 4. ドキュメント群活用法

### `BRANCHING_STRATEGY.md` 活用法

#### 新規開発者のオンボーディング
1. ブランチ構造理解
2. ワークフロー習得
3. コミットメッセージ規則確認
4. 競合解決手順参照

#### 開発方針決定時の参照
- ブランチ種別選択基準
- マージ戦略決定
- 品質ゲート設定

### `MULTI_SESSION_GUIDE.md` 活用法

#### 日常運用マニュアルとして
- セッション開始前の準備確認
- 作業中のベストプラクティス適用
- トラブルシューティング時の対応

#### プロセス改善時の基準として
- 効果測定指標の参照
- 運用改善点の検討
- 新しい運用パターン策定

---

## 🔧 トラブルシューティング・FAQ

### Q1: セッション開始スクリプトが失敗する
**症状**: `./scripts/start-session.sh` 実行時にエラー

**対処法**:
```bash
# 1. 実行権限確認・付与
chmod +x scripts/start-session.sh

# 2. Git状況確認
git status

# 3. 未コミット変更をstash
git stash

# 4. 再実行
./scripts/start-session.sh
```

### Q2: セッション終了時に想定されないオプションが表示される
**症状**: end-session.shで意図しないブランチでの実行

**対処法**:
```bash
# 現在のブランチ確認
git branch --show-current

# セッションブランチ（experiment/*またはfeature/*）に移動
git checkout experiment/session-20250109-1430
./scripts/end-session.sh
```

### Q3: ブランチ状況確認が遅い
**症状**: `branch-status.sh` の実行に時間がかかる

**対処法**:
```bash
# リモート情報更新をスキップして高速化
git config --local branch.autosetupmerge false
git config --local branch.autosetuprebase never
```

### Q4: Cherry-pickで競合が発生
**症状**: 実験成果をfeatureブランチに移行時に競合

**対処法**:
```bash
# 1. 競合状況確認
git status

# 2. 競合ファイル編集
# エディタで <<<<<<< ======= >>>>>>> マーカー部分を解決

# 3. 競合解決完了
git add resolved-file.py
git cherry-pick --continue
```

### Q5: セッションディレクトリが見つからない
**症状**: セッション終了時にディレクトリが存在しない

**対処法**:
```bash
# セッションディレクトリ手動作成
SESSION_NAME=$(git branch --show-current | sed 's/.*\///g')
mkdir -p "02_notebooks/sessions/$SESSION_NAME"

# 基本READMEを作成
echo "# Session: $SESSION_NAME" > "02_notebooks/sessions/$SESSION_NAME/README.md"
```

---

## 🎯 効率的な使用パターン

### パターン1: 日次実験サイクル
```bash
# 朝：状況確認
./scripts/branch-status.sh

# 実験開始
./scripts/start-session.sh

# [実験・コーディング・記録]

# 夕方：セッション終了
./scripts/end-session.sh
```

### パターン2: 週次機能開発サイクル
```bash
# 月曜：機能開発セッション開始
./scripts/start-session.sh develop feature

# 火-木：継続開発
git checkout feature/session-20250106-0900
# [開発作業]

# 金曜：機能完成・統合
./scripts/end-session.sh  # Option 2: Merge to develop
```

### パターン3: 実験比較研究
```bash
# 手法A実験
./scripts/start-session.sh feature/baseline-methods
# [実験A実行・記録]
./scripts/end-session.sh  # Option 4: Archive

# 手法B実験
./scripts/start-session.sh feature/optimization-methods
# [実験B実行・記録]
./scripts/end-session.sh  # Option 4: Archive

# 比較分析セッション
./scripts/start-session.sh develop
# [比較分析・レポート作成]
./scripts/end-session.sh  # Option 2: Merge results
```

---

## 📊 効果測定・改善

### 使用効果の測定方法

#### 定量指標
```bash
# セッション統計
echo "Total sessions: $(ls 02_notebooks/sessions/ | wc -l)"
echo "Archived sessions: $(ls 06_reports/archived_sessions/ | wc -l)"
echo "Active feature branches: $(git branch | grep feature | wc -l)"

# 開発効率
echo "Average commits per session: $(git log --all --oneline | wc -l) / $(ls 02_notebooks/sessions/ | wc -l)"
```

#### 定性評価
- セッション目標達成率
- 実験結果の再利用性
- ドキュメント充実度
- 他メンバーとの協調効率

### 継続的改善

#### 月次レビュー実施
1. アーカイブされたセッションレビュー
2. ツール使用頻度・効果分析
3. 問題点・改善要望収集
4. ツール・プロセス改良

#### カスタマイズ方針
- チーム固有のテンプレート追加
- プロジェクト特化のスクリプト拡張
- 統計レポートの自動化
- CI/CD統合による品質自動チェック

---

**このツール群を活用して、効率的で高品質なトロイの木馬検出研究を推進しましょう！🚀🔬**