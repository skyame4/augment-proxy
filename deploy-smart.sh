#!/bin/bash

# 🚀 智能部署脚本 - 自动处理数据库配置

set -e

echo "🚀 开始智能部署..."

# 检查环境变量
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "❌ 错误: CLOUDFLARE_API_TOKEN 环境变量未设置"
    exit 1
fi

if [ -z "$CLOUDFLARE_ACCOUNT_ID" ]; then
    echo "❌ 错误: CLOUDFLARE_ACCOUNT_ID 环境变量未设置"
    exit 1
fi

# 数据库名称
DB_NAME="augment2api-multiuser"

echo "📊 检查D1数据库..."

# 检查数据库是否存在
DB_LIST=$(npx wrangler d1 list --json 2>/dev/null || echo "[]")
DB_ID=$(echo "$DB_LIST" | jq -r ".[] | select(.name == \"$DB_NAME\") | .uuid" 2>/dev/null || echo "")

if [ -z "$DB_ID" ] || [ "$DB_ID" = "null" ]; then
    echo "📊 创建D1数据库: $DB_NAME"
    CREATE_RESULT=$(npx wrangler d1 create "$DB_NAME" --json)
    DB_ID=$(echo "$CREATE_RESULT" | jq -r '.uuid')
    echo "✅ 数据库创建成功: $DB_ID"
else
    echo "✅ 数据库已存在: $DB_ID"
fi

# 更新wrangler.toml中的数据库ID
echo "🔧 更新wrangler.toml配置..."

# 备份原文件
cp wrangler.toml wrangler.toml.backup

# 替换数据库ID
sed -i.tmp "s/database_id = \"placeholder-will-be-created-automatically\"/database_id = \"$DB_ID\"/g" wrangler.toml
rm -f wrangler.toml.tmp

echo "✅ 配置文件已更新"

# 部署Worker
echo "🚀 部署Worker..."
npx wrangler deploy

# 初始化数据库结构
echo "🗄️ 初始化数据库结构..."
if [ -f "schema-extended.sql" ]; then
    npx wrangler d1 execute "$DB_NAME" --file=schema-extended.sql
    echo "✅ 数据库结构初始化完成"
else
    echo "⚠️ 警告: schema-extended.sql 文件不存在"
fi

# 恢复原配置文件（保持placeholder用于版本控制）
mv wrangler.toml.backup wrangler.toml

echo ""
echo "🎉 部署完成！"
echo ""
echo "📋 部署信息:"
echo "   Worker名称: augment-proxy"
echo "   数据库名称: $DB_NAME"
echo "   数据库ID: $DB_ID"
echo ""
echo "🔗 访问链接:"
echo "   管理面板: https://augment-proxy.workers.dev"
echo "   健康检查: https://augment-proxy.workers.dev/health"
echo "   API端点: https://augment-proxy.workers.dev/v1"
echo ""
echo "👤 默认管理员账号:"
echo "   用户名: admin"
echo "   密码: admin123"
echo ""
echo "⚠️ 重要: 请立即登录管理面板修改默认密码！"
