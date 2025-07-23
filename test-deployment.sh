#!/bin/bash

# 🚀 Cloudflare部署测试脚本

echo "🔧 测试Cloudflare API连接..."

# 测试API Token
echo "📡 测试API Token..."
ACCOUNT_RESPONSE=$(curl -s -X GET "https://api.cloudflare.com/client/v4/accounts" \
  -H "Authorization: Bearer q7a_Yfr6gMZMZlAs5U-WDKiXu-kY79Q2N2RRbpzE" \
  -H "Content-Type: application/json")

if echo "$ACCOUNT_RESPONSE" | grep -q '"success":true'; then
    echo "✅ API Token 有效"
    ACCOUNT_ID=$(echo "$ACCOUNT_RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo "📋 Account ID: $ACCOUNT_ID"
else
    echo "❌ API Token 无效"
    exit 1
fi

# 检查是否已安装Wrangler
echo "🔍 检查Wrangler CLI..."
if command -v wrangler &> /dev/null; then
    echo "✅ Wrangler CLI 已安装"
    wrangler --version
else
    echo "📦 安装Wrangler CLI..."
    npm install -g wrangler
fi

# 测试Wrangler登录
echo "🔐 配置Wrangler认证..."
export CLOUDFLARE_API_TOKEN="q7a_Yfr6gMZMZlAs5U-WDKiXu-kY79Q2N2RRbpzE"
export CLOUDFLARE_ACCOUNT_ID="a99f2b7b0cc5a1aae66ffb5889a5d10c"

# 检查D1数据库
echo "🗄️ 检查D1数据库..."
DB_LIST=$(wrangler d1 list 2>/dev/null || echo "")
if echo "$DB_LIST" | grep -q "augment2api-multiuser"; then
    echo "✅ 数据库 augment2api-multiuser 已存在"
else
    echo "📊 创建D1数据库..."
    wrangler d1 create augment2api-multiuser
fi

# 测试部署
echo "🚀 测试部署..."
if [ -f "wrangler.toml" ]; then
    echo "✅ wrangler.toml 配置文件存在"
    echo "🔄 执行部署测试..."
    wrangler deploy --dry-run
    
    if [ $? -eq 0 ]; then
        echo "✅ 部署测试成功！"
        echo ""
        echo "🎯 下一步："
        echo "1. 在GitHub仓库设置中添加Secrets："
        echo "   - CLOUDFLARE_API_TOKEN: q7a_Yfr6gMZMZlAs5U-WDKiXu-kY79Q2N2RRbpzE"
        echo "   - CLOUDFLARE_ACCOUNT_ID: a99f2b7b0cc5a1aae66ffb5889a5d10c"
        echo ""
        echo "2. 推送代码到GitHub将自动触发部署"
        echo ""
        echo "3. 部署成功后访问："
        echo "   - 管理面板: https://augment-proxy.workers.dev"
        echo "   - API端点: https://augment-proxy.workers.dev/v1"
    else
        echo "❌ 部署测试失败"
    fi
else
    echo "❌ wrangler.toml 配置文件不存在"
fi

echo ""
echo "🎉 测试完成！"
