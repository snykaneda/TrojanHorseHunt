#!/bin/bash
# TrojanHorseHunt ブランチ状況確認スクリプト

set -e

echo "🌳 TrojanHorseHunt Git Tree Status"
echo "=================================="
echo ""

# 現在のブランチ情報
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Current branch: $CURRENT_BRANCH"
echo "🔄 Last update: $(git log -1 --format='%cr (%h)')"
echo ""

# 全ブランチ一覧（整理して表示）
echo "📋 All Branches:"
echo "----------------"
echo "🛡️ Protected branches:"
git branch -a | grep -E "(main|develop)" | sed 's/^[* ] */  /'
echo ""

echo "🔬 Feature branches:"
git branch -a | grep "feature/" | sed 's/^[* ] */  /' | sed 's/remotes\/origin\///g' | sort | uniq
echo ""

echo "🧪 Experiment branches:"
git branch -a | grep "experiment/" | sed 's/^[* ] */  /' | sed 's/remotes\/origin\///g' | sort | uniq || echo "  No experiment branches found"
echo ""

# ブランチ間の関係性
echo "🔍 Branch Relationships:"
echo "------------------------"

# developとの比較
if [[ $CURRENT_BRANCH != "develop" ]]; then
    echo "📊 $CURRENT_BRANCH vs develop:"
    AHEAD=$(git rev-list --count develop..$CURRENT_BRANCH)
    BEHIND=$(git rev-list --count $CURRENT_BRANCH..develop)
    echo "  - Ahead by $AHEAD commits"
    echo "  - Behind by $BEHIND commits"
    
    if [[ $AHEAD -gt 0 ]]; then
        echo "  - Recent commits on $CURRENT_BRANCH:"
        git log --oneline develop..$CURRENT_BRANCH | head -5 | sed 's/^/    /'
    fi
    echo ""
fi

# mainとの比較
if [[ $CURRENT_BRANCH != "main" ]]; then
    echo "📊 $CURRENT_BRANCH vs main:"
    AHEAD=$(git rev-list --count main..$CURRENT_BRANCH)
    BEHIND=$(git rev-list --count $CURRENT_BRANCH..main)
    echo "  - Ahead by $AHEAD commits"
    echo "  - Behind by $BEHIND commits"
    echo ""
fi

# 最近のアクティビティ
echo "⚡ Recent Activity (last 10 commits):"
echo "-------------------------------------"
git log --oneline --graph --all -10 | sed 's/^/  /'
echo ""

# 未マージのブランチ確認
echo "🔄 Branches not merged to develop:"
echo "----------------------------------"
UNMERGED=$(git branch --no-merged develop | grep -v "main" | sed 's/^[* ] *//' || true)
if [[ -n "$UNMERGED" ]]; then
    echo "$UNMERGED" | sed 's/^/  /'
else
    echo "  All branches merged to develop ✅"
fi
echo ""

# ローカルとリモートの同期状況
echo "🌐 Local vs Remote Status:"
echo "--------------------------"
git remote update origin --prune >/dev/null 2>&1

LOCAL_BRANCHES=$(git branch | sed 's/^[* ] *//')
REMOTE_BRANCHES=$(git branch -r | grep -v "HEAD" | sed 's/^[* ] *//' | sed 's/origin\///g')

echo "📥 Local only branches:"
comm -23 <(echo "$LOCAL_BRANCHES" | sort) <(echo "$REMOTE_BRANCHES" | sort) | sed 's/^/  /' || echo "  None"
echo ""

echo "📤 Remote only branches:"
comm -13 <(echo "$LOCAL_BRANCHES" | sort) <(echo "$REMOTE_BRANCHES" | sort) | sed 's/^/  /' || echo "  None"
echo ""

# セッション統計
echo "📊 Session Statistics:"
echo "---------------------"
EXPERIMENT_COUNT=$(git branch -a | grep -c "experiment/" || echo "0")
FEATURE_COUNT=$(git branch -a | grep -c "feature/" || echo "0")
TOTAL_COMMITS=$(git rev-list --count --all)

echo "  - Feature branches: $FEATURE_COUNT"
echo "  - Experiment branches: $EXPERIMENT_COUNT"
echo "  - Total commits: $TOTAL_COMMITS"
echo ""

# 推奨アクション
echo "💡 Recommended Actions:"
echo "----------------------"

# 同期が必要なブランチチェック
if git status | grep -q "Your branch is behind"; then
    echo "  🔄 Pull latest changes: git pull origin $CURRENT_BRANCH"
fi

if git status | grep -q "Your branch is ahead"; then
    echo "  📤 Push changes: git push origin $CURRENT_BRANCH"
fi

# 古いブランチの確認
OLD_BRANCHES=$(git for-each-ref --format='%(refname:short) %(committerdate)' refs/heads | awk '$2 < "'$(date -d '30 days ago' '+%Y-%m-%d')'"' || true)
if [[ -n "$OLD_BRANCHES" ]]; then
    echo "  🧹 Consider cleaning up old branches (>30 days):"
    echo "$OLD_BRANCHES" | sed 's/^/    /'
fi

echo ""
echo "🚀 Quick Commands:"
echo "  - Start new session: ./scripts/start-session.sh"
echo "  - End current session: ./scripts/end-session.sh"
echo "  - Switch to feature branch: git checkout feature/[name]"
echo "  - Update all branches: git fetch --all"
echo ""
echo "✅ Branch status report complete! 📋"