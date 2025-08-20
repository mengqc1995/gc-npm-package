# gc-npm-package

一个智能的Git提交工具，帮助开发者快速、规范地提交代码。

## ✨ 功能特性

- 🚀 **智能提交类型识别** - 自动分析代码变更并推荐合适的提交类型
- 📝 **标准化提交格式** - 遵循Conventional Commits规范
- 🔍 **代码变更分析** - 智能分析文件类型和功能模块
- 🎨 **彩色输出** - 美观的命令行界面
- 📊 **变更统计** - 显示详细的文件变更统计信息
- 🚀 **一键推送** - 提交后可选择直接推送到远程仓库

## 📦 安装

```bash
npm install -g gc-npm-package
```

## 🚀 使用方法

### 基本用法

```bash
gc [type] [scope] [description]
```

### 参数说明

- `type`: 提交类型（可选，默认为 "update"）
  - `feat`: 新功能
  - `fix`: 修复bug
  - `update`: 更新/优化
  - `docs`: 文档更新
  - `style`: 代码格式调整
  - `refactor`: 代码重构
  - `test`: 测试相关
  - `chore`: 构建/工具相关

- `scope`: 影响范围（可选，默认为 "general"）
- `description`: 提交描述（可选，会自动生成）

### 使用示例

#### 基础示例
```bash
# 基本使用（自动分析代码变更）
gc

# 指定类型和描述
gc feat userManage "新增用户管理功能"

# 指定类型、范围和描述
gc fix auth "修复登录验证问题"

# 只指定类型
gc docs
```

#### 高级示例
```bash
# 新功能开发
gc feat "新增用户注册功能"
gc feat auth "实现OAuth2.0认证"

# Bug修复
gc fix "修复内存泄漏问题"
gc fix ui "修复移动端显示异常"

# 代码重构
gc refactor "重构用户服务模块"
gc refactor utils "优化工具函数性能"

# 文档更新
gc docs "更新API文档"
gc docs readme "完善使用说明"

# 测试相关
gc test "添加单元测试"
gc test e2e "集成端到端测试"

# 构建工具
gc chore "更新构建配置"
gc chore deps "升级依赖包版本"
```

#### 实际工作流示例
```bash
# 1. 开发新功能
gc feat "实现用户登录功能"

# 2. 修复发现的问题
gc fix "修复登录状态丢失bug"

# 3. 优化代码
gc refactor "重构认证逻辑"

# 4. 添加测试
gc test "添加登录功能测试"

# 5. 更新文档
gc docs "更新登录API文档"

# 6. 发布版本
gc chore "发布v1.0.0版本"
```

## 🔧 工作流程

1. **检查Git状态** - 验证当前目录是否为Git仓库
2. **分析代码变更** - 智能分析修改的文件类型和功能
3. **生成提交信息** - 根据分析结果自动生成规范的提交信息
4. **确认提交** - 显示生成的提交信息供用户确认
5. **执行提交** - 添加文件并提交代码
6. **推送选项** - 可选择是否推送到远程仓库

## 🔍 智能分析功能

### 文件类型识别
- **前端文件**: `.vue`, `.js`, `.ts`, `.jsx`, `.tsx`
- **样式文件**: `.css`, `.scss`, `.less`, `.styl`
- **配置文件**: `.json`, `.yaml`, `.yml`, `.toml`
- **文档文件**: `.md`, `.txt`, `.rst`

### 功能模块识别
- **API层**: `src/api/`, `api/`, `services/`
- **组件**: `src/components/`, `components/`
- **页面**: `src/pages/`, `pages/`, `views/`
- **状态管理**: `src/store/`, `store/`, `state/`
- **路由**: `src/router/`, `router/`
- **工具函数**: `src/utils/`, `utils/`, `helpers/`

## 📁 文件结构

```
gc-npm-package/
├── gc                    # 主命令入口
├── git-commit.sh        # 核心提交脚本
├── code-analyzer.sh     # 代码分析脚本
└── package.json         # 包配置文件
```

## 🎯 适用场景

- 个人项目开发
- 团队协作开发
- 开源项目维护
- 需要规范化Git提交的项目

## 🚨 常见问题

### Q: 命令找不到？
**A**: 确保已全局安装：`npm install -g gc-npm-package`

### Q: 权限错误？
**A**: 在macOS/Linux上可能需要：`sudo npm install -g gc-npm-package`

### Q: 脚本执行失败？
**A**: 确保脚本有执行权限：`chmod +x gc git-commit.sh code-analyzer.sh`

### Q: 推送失败？
**A**: 检查远程仓库配置：`git remote -v`

### Q: 如何自定义提交类型？
**A**: 目前支持8种标准类型，未来版本将支持自定义

## 🔧 配置选项

### 环境变量
```bash
# 设置默认提交类型
export GC_DEFAULT_TYPE="feat"

# 设置默认影响范围
export GC_DEFAULT_SCOPE="app"

# 禁用彩色输出
export GC_NO_COLOR="true"
```

### Git配置
```bash
# 设置用户信息
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 设置默认编辑器
git config --global core.editor "code --wait"
```

## 🤝 贡献

欢迎提交Issue和Pull Request！

### 贡献指南
1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/AmazingFeature`
3. 提交更改：`gc feat "添加新功能"`
4. 推送到分支：`git push origin feature/AmazingFeature`
5. 创建Pull Request

## 📄 许可证

ISC License

## 🔗 相关链接

- [npm包页面](https://www.npmjs.com/package/gc-npm-package)
- [GitHub仓库](https://github.com/mengqc1995/gc-npm-package)
- [Conventional Commits规范](https://www.conventionalcommits.org/)
- [Git提交规范](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#-commit-message-format)

## 📈 更新日志

### v1.0.2
- ✨ 新增智能代码分析功能
- 🎨 优化命令行界面
- 📚 完善文档和示例

### v1.0.1
- 🐛 修复基础功能
- 📦 优化包结构

### v1.0.0
- 🎉 首次发布
- 🚀 基础Git提交功能

---

**让Git提交变得简单而规范！** 🎉

> 💡 **提示**: 使用 `gc --help` 查看帮助信息（如果支持的话）
