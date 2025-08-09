# 🔄 マルチセッション運用ガイド

TrojanHorseHuntプロジェクトでの効率的なマルチセッション研究開発ガイドです。

## 🚀 クイックスタート

### セッション開始
```bash
# 基本的なセッション開始（developベース）
./scripts/start-session.sh

# 特定のブランチからセッション開始
./scripts/start-session.sh feature/data-analysis

# featureブランチとしてセッション開始
./scripts/start-session.sh develop feature
```

### セッション状況確認
```bash
# 全ブランチの状況確認
./scripts/branch-status.sh

# 現在のセッション情報確認
git branch --show-current
git status
```

### セッション終了
```bash
# 対話形式でセッション終了
./scripts/end-session.sh
```

## 📋 セッション種別

### 🧪 実験セッション (`experiment/*`)
**用途**: 短期的な実験・パラメータ調整・手法検証

**特徴**:
- 一時的なコード変更
- 快速な試行錯誤
- 結果記録重視
- 必要に応じて破棄可能

**命名規則**: `experiment/session-YYYYMMDD-HHMM`

**典型的なワークフロー**:
1. アイデア検証のための実験セッション開始
2. 複数のパラメータや手法を試行
3. 結果をJupyterノートブックに記録
4. 有用な結果はfeatureブランチにcherry-pick
5. セッション終了時にアーカイブまたは削除

### 🔬 機能開発セッション (`feature/*`)
**用途**: 長期的な機能開発・アルゴリズム実装

**特徴**:
- 構造的なコード変更
- テスト駆動開発
- ドキュメント作成
- 最終的にdevelopブランチにマージ

**命名規則**: `feature/descriptive-name`

**典型的なワークフロー**:
1. 新機能の設計・計画
2. 継続的な開発・テスト・リファクタリング
3. 複数セッションに分けて段階的実装
4. Pull Requestでレビュー
5. developブランチにマージ

## 🏗️ ブランチ戦略詳細

### 基本構造
```
main (本番・最終提出)
├── develop (開発統合)
├── feature/data-analysis (データ分析機能)
├── feature/trigger-detection (検出アルゴリズム)
├── feature/model-forensics (フォレンジック)
├── feature/baseline-methods (ベースライン手法)
├── feature/optimization-methods (最適化手法)
├── feature/gradient-methods (勾配手法)
└── experiment/session-* (実験セッション)
```

### ブランチ間の関係
- **main ← develop**: 安定版リリース時
- **develop ← feature/***: 機能完成時
- **feature/* ← experiment/***: 有用な実験結果をcherry-pick

## 🛠️ 日常的なワークフロー

### 1. セッション開始前
```bash
# 最新状況確認
./scripts/branch-status.sh

# 特定の研究テーマで作業開始
git checkout feature/trigger-detection
git pull origin feature/trigger-detection

# または新規実験セッション開始
./scripts/start-session.sh
```

### 2. 作業中
```bash
# 定期的なコミット（実験記録）
git add -A
git commit -m "experiment: test parameter X=0.5, accuracy improved to 85%"

# 中間プッシュ（バックアップ）
git push origin current-branch-name

# 他のセッションから有用なコミットを取得
git cherry-pick commit-hash
```

### 3. セッション終了時
```bash
# セッション総括と整理
./scripts/end-session.sh

# 次のセッションへの引き継ぎ記録
git log --oneline -5  # 直近の作業確認
```

## 📊 セッション管理ベストプラクティス

### ✅ 推奨されるセッション運用

#### 実験ログ記録
```markdown
## 実験記録テンプレート
**実験ID**: EXP-001
**目的**: パラメータXの影響確認
**設定**: X=0.1, Y=0.5, epochs=100
**結果**: accuracy=82%, loss=0.15
**考察**: Xを増加させると精度向上
**次のアクション**: X=0.2で再実験
```

#### コミットメッセージ規則
```bash
# 実験系
git commit -m "experiment: test parameter tuning for trigger detection"
git commit -m "results: achieved 85% accuracy with optimized parameters"

# 機能開発系
git commit -m "feature: implement baseline trigger reconstruction"
git commit -m "fix: resolve data loading issue in forensics module"
git commit -m "docs: add API documentation for detection methods"
```

#### セッションディレクトリ構造
```
02_notebooks/sessions/
├── session-20250109-1430/
│   ├── README.md (セッション目的・結果)
│   ├── session_notebook.ipynb (実験ノート)
│   ├── experiment_logs/ (詳細ログ)
│   └── results/ (出力ファイル・図表)
└── session-20250109-1600/
    └── ...
```

### ❌ 避けるべき運用

- **大きすぎるコミット**: 複数の変更を一度にコミット
- **意味のないメッセージ**: "fix", "update", "change"等
- **ブランチ放置**: 実験後のクリーンアップを怠る
- **マージタイミング**: 未完成のコードをdevelopに送る
- **バックアップ不足**: ローカルのみで作業

## 🔧 トラブルシューティング

### よくある問題と解決法

#### ブランチ間の競合
```bash
# 解決手順
git checkout target-branch
git pull origin target-branch
git checkout your-branch
git rebase target-branch
# 競合解決後
git rebase --continue
```

#### 間違ったブランチでの作業
```bash
# コミット前の場合
git stash
git checkout correct-branch
git stash pop

# コミット後の場合
git cherry-pick commit-hash  # 正しいブランチで
git reset --hard HEAD~1     # 間違ったブランチで取り消し
```

#### セッションデータの復旧
```bash
# アーカイブからの復旧
ls 06_reports/archived_sessions/
cat 06_reports/archived_sessions/session-*_summary.md

# 削除されたブランチの復旧
git reflog
git checkout -b recovered-branch <commit-hash>
```

## 📈 効果測定・改善

### セッション効率指標
- **セッション時間**: 平均セッション長
- **実験成功率**: 目標達成したセッションの割合
- **コード再利用率**: cherry-pickされたコミット数
- **ドキュメント充実度**: README・コメントの充実度

### 定期レビュー項目
```bash
# 月次ブランチクリーンアップ
git branch --merged develop | grep -v main | grep -v develop | xargs -n 1 git branch -d

# セッション統計レポート
echo "Total sessions: $(ls 02_notebooks/sessions/ | wc -l)"
echo "Total experiments: $(git branch -a | grep experiment | wc -l)"
echo "Feature branches: $(git branch -a | grep feature | wc -l)"
```

## 🎯 セッション目標設定

### 日次セッション目標例
- **データ分析**: 新しいパターン1つ発見
- **アルゴリズム実装**: 機能1つ完成
- **実験**: パラメータ組み合わせ3つテスト
- **文書化**: 実験結果1つレポート作成

### 週次統合目標
- **Pull Request**: 1つのfeatureブランチを完成
- **コードレビュー**: 他の機能をレビュー
- **結果統合**: 実験結果をまとめて報告
- **計画更新**: 次週の研究計画策定

---

**効率的なマルチセッション研究で、トロイの木馬検出技術を発展させましょう！🛡️🔬**