# 🔐 GitHub Secrets 配置指南

## ✅ Cloudflare 凭据已获取

- **API Token**: `q7a_Yfr6gMZMZlAs5U-WDKiXu-kY79Q2N2RRbpzE`
- **Account ID**: `a99f2b7b0cc5a1aae66ffb5889a5d10c`

## 🚀 配置GitHub Secrets步骤

### 第一步：访问仓库设置

1. 打开您的GitHub仓库：https://github.com/skyame4/augment-proxy
2. 点击仓库页面上方的 **"Settings"** 标签
3. 在左侧菜单中找到 **"Secrets and variables"**
4. 点击 **"Actions"**

### 第二步：添加Secrets

点击 **"New repository secret"** 按钮，添加以下两个secrets：

#### Secret 1: Cloudflare API Token
```
Name: CLOUDFLARE_API_TOKEN
Value: q7a_Yfr6gMZMZlAs5U-WDKiXu-kY79Q2N2RRbpzE
```

#### Secret 2: Cloudflare Account ID
```
Name: CLOUDFLARE_ACCOUNT_ID
Value: a99f2b7b0cc5a1aae66ffb5889a5d10c
```

### 第三步：验证配置

配置完成后，您应该在 **"Repository secrets"** 部分看到：
- ✅ `CLOUDFLARE_API_TOKEN`
- ✅ `CLOUDFLARE_ACCOUNT_ID`

## 🎯 自动部署触发

配置完成后，任何推送到 `main` 分支的代码都会自动触发部署：

1. **GitHub Actions** 会自动运行
2. **创建D1数据库** (如果不存在)
3. **部署Worker代码** 到Cloudflare
4. **初始化数据库结构**

## 📊 查看部署状态

1. 在GitHub仓库页面点击 **"Actions"** 标签
2. 查看最新的workflow运行状态
3. 绿色✅表示部署成功
4. 红色❌表示部署失败，点击查看详细日志

## 🌐 部署成功后

部署成功后，您将获得：

- **API端点**: `https://augment-proxy.workers.dev/v1`
- **管理面板**: `https://augment-proxy.workers.dev`
- **健康检查**: `https://augment-proxy.workers.dev/health`

### 默认管理员账号
- **用户名**: `admin`
- **密码**: `admin123`

⚠️ **重要**: 部署成功后请立即登录管理面板修改默认密码！

## 🔧 手动触发部署

如果需要手动触发部署：

1. 在GitHub仓库的 **"Actions"** 页面
2. 选择 **"Deploy to Cloudflare Workers"** workflow
3. 点击 **"Run workflow"** 按钮
4. 选择 `main` 分支并点击 **"Run workflow"**

## 🎉 完成！

配置完成后，您的Augment2Api多用户代理系统将自动部署到Cloudflare Workers，享受：

- 🌐 **全球CDN加速**
- 🔄 **自动扩展**
- 💰 **极低成本**
- 🛡️ **企业级安全**
- 🚀 **零维护**

---

**下一步**: 配置完GitHub Secrets后，推送任何代码更改都会自动部署！
