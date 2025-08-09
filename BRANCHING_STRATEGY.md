# 🌳 Git Branch Strategy for Multi-Session Development

## 概要

TrojanHorseHuntプロジェクトにおけるマルチセッション開発対応のためのGitブランチ戦略です。複数の研究テーマを並行して進行し、異なるセッション間でのコード競合を避けながら効率的な開発を実現します。

## 🏗️ ブランチ構造

```
main (保護ブランチ)
├── develop (統合開発ブランチ)
├── feature/data-analysis (データ分析機能)
├── feature/trigger-detection (トリガー検出アルゴリズム)
├── feature/model-forensics (モデルフォレンジック)
├── feature/baseline-methods (ベースライン手法)
├── feature/optimization-methods (最適化ベース手法)
├── feature/gradient-methods (勾配ベース手法)
├── experiment/session-YYYYMMDD-HHMM (実験セッション)
└── hotfix/* (緊急修正)
```

## 📋 ブランチ種別

### 🛡️ 保護ブランチ

#### `main`
- **目的**: 本番リリース・最終提出版
- **保護レベル**: 最高
- **マージ条件**: Pull Request + レビュー必須
- **用途**: 安定したコード、ドキュメント、最終提出ファイル

#### `develop`
- **目的**: 開発統合ブランチ
- **保護レベル**: 中
- **マージ条件**: Pull Request推奨
- **用途**: feature ブランチの統合、日次ビルド

### 🔬 研究テーマブランチ (`feature/*`)

#### `feature/data-analysis`
- **目的**: データ探索・前処理・可視化
- **担当**: データサイエンティスト
- **主要ファイル**: `02_notebooks/data-analysis/`, `03_src/data/`

#### `feature/trigger-detection`
- **目的**: トリガー検出コアアルゴリズム
- **担当**: 機械学習エンジニア
- **主要ファイル**: `03_src/detection/`, `04_models/detection/`

#### `feature/model-forensics`
- **目的**: モデル内部解析・異常検出
- **担当**: セキュリティ研究者
- **主要ファイル**: `03_src/forensics/`, `06_reports/forensics/`

#### `feature/baseline-methods`
- **目的**: ベースライン手法の実装
- **担当**: リサーチエンジニア
- **主要ファイル**: `03_src/baselines/`, `02_notebooks/baselines/`

#### `feature/optimization-methods`
- **目的**: 最適化ベースのトリガー再構築
- **担当**: 最適化スペシャリスト
- **主要ファイル**: `03_src/optimization/`, `02_notebooks/optimization/`

#### `feature/gradient-methods`
- **目的**: 勾配ベースの敵対的サンプル生成
- **担当**: 敵対的ML専門家
- **主要ファイル**: `03_src/gradient/`, `02_notebooks/gradient/`

### 🧪 実験セッションブランチ (`experiment/*`)

#### `experiment/session-YYYYMMDD-HHMM`
- **目的**: 特定のセッション・実験の記録
- **命名例**: `experiment/session-20250109-1430`
- **用途**: 
  - 一時的な実験コード
  - パラメータ調整
  - 結果検証
  - セッション固有の分析

#### `experiment/comparative-study`
- **目的**: 手法間の比較研究
- **用途**: 複数アルゴリズムの性能比較

### 🚨 ホットフィックスブランチ (`hotfix/*`)

#### `hotfix/urgent-fix-name`
- **目的**: 緊急度の高いバグ修正
- **特徴**: main から直接分岐、main と develop に両方マージ

## 🔄 ワークフロー

### 日常開発フロー

```bash
# 1. 最新のdevelopを取得
git checkout develop
git pull origin develop

# 2. 機能ブランチを作成
git checkout -b feature/your-feature-name

# 3. 開発・コミット
git add .
git commit -m "Add feature implementation"

# 4. リモートにプッシュ
git push -u origin feature/your-feature-name

# 5. Pull Request作成（GitHub Web UI）
# 6. レビュー・マージ後にローカルクリーンアップ
git checkout develop
git pull origin develop
git branch -d feature/your-feature-name
```

### セッションベース実験フロー

```bash
# 1. セッション開始
git checkout develop
git checkout -b experiment/session-$(date +%Y%m%d-%H%M)

# 2. 実験実行・結果記録
jupyter notebook  # 実験ノート作成
git add . && git commit -m "Session experiment: parameter tuning"

# 3. 有用な結果はfeatureブランチにcherry-pick
git checkout feature/trigger-detection
git cherry-pick <experiment-commit-hash>

# 4. セッション終了（実験ブランチ保持 or 削除選択可能）
```

### リリース準備フロー

```bash
# 1. develop -> main への統合準備
git checkout main
git merge develop

# 2. 最終提出ファイルの準備
# 3. タグ付け
git tag -a v1.0 -m "Final submission for competition"
git push origin v1.0
```

## 🛠️ セッション管理スクリプト

### セッション開始スクリプト (`scripts/start-session.sh`)

```bash
#!/bin/bash
SESSION_NAME="session-$(date +%Y%m%d-%H%M)"
BASE_BRANCH=${1:-develop}

echo "🚀 Starting new research session: $SESSION_NAME"
git checkout $BASE_BRANCH
git pull origin $BASE_BRANCH
git checkout -b experiment/$SESSION_NAME

echo "📝 Session branch created: experiment/$SESSION_NAME"
echo "📊 Ready for experimentation!"
```

### セッション終了スクリプト (`scripts/end-session.sh`)

```bash
#!/bin/bash
CURRENT_BRANCH=$(git branch --show-current)

if [[ $CURRENT_BRANCH == experiment/* ]]; then
    echo "📊 Session Summary:"
    git log --oneline --since="1 day ago"
    
    echo "🤔 Keep this experimental branch? (y/n)"
    read -r response
    if [[ $response == "n" ]]; then
        git checkout develop
        git branch -D $CURRENT_BRANCH
        echo "🗑️ Experimental branch deleted"
    else
        echo "📚 Experimental branch preserved for future reference"
    fi
else
    echo "⚠️ Not currently on an experiment branch"
fi
```

## 📖 マルチセッション運用ガイド

### セッション開始時

1. **ブランチ確認**: `git branch -a` で現在の状況確認
2. **最新同期**: `git checkout develop && git pull origin develop`
3. **セッションブランチ作成**: テーマに応じて適切なブランチを選択
4. **作業ディレクトリ設定**: 実験に必要なデータ・ノートブック準備

### セッション中

1. **定期コミット**: 実験の節目でこまめにコミット
2. **意味のあるコミットメッセージ**: 実験内容・パラメータ・結果を記録
3. **ノートブック管理**: 実験ログを詳細に記録
4. **中間結果保存**: 重要な結果は即座にコミット

### セッション終了時

1. **結果整理**: 有用な結果を適切なfeatureブランチに統合
2. **実験記録**: セッションサマリをREPORTSに記録
3. **ブランチクリーンアップ**: 不要な実験ブランチの整理
4. **次セッション準備**: 次の研究方向性を文書化

### 競合解決

1. **事前回避**: セッション開始時に最新版を取得
2. **ファイル分離**: 異なるセッションは異なるファイル/ディレクトリで作業
3. **統合調整**: 複数の改善を統合する際は新しいブランチを作成
4. **レビュー**: 重要な統合はPull Requestでレビュー実施

## 🔒 ブランチ保護ルール

### main ブランチ
- Direct push禁止
- Pull Request必須
- 1名以上のレビュー必須
- CI/CD通過必須

### develop ブランチ  
- Direct push制限
- Pull Request推奨
- 自動マージ可能（緊急時）

### feature/* ブランチ
- 自由な開発
- 定期的なdevelopとの同期推奨

## 📊 ブランチ管理ダッシュボード

### 定期確認項目

```bash
# アクティブブランチ一覧
git branch -a

# 最近の活動
git log --oneline --graph --all -10

# ブランチ間の差分確認
git diff develop..feature/your-branch

# 未マージのブランチ確認
git branch --no-merged develop
```

---

**効果的なマルチセッション開発のために、この戦略を活用して研究の進捗と品質を両立させましょう！**