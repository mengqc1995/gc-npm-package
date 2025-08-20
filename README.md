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

```bash
# 基本使用
gc

# 指定类型和描述
gc feat userManage "新增用户管理功能"

# 指定类型、范围和描述
gc fix auth "修复登录验证问题"

# 只指定类型
gc docs
```

## 🔧 工作流程

1. **检查Git状态** - 验证当前目录是否为Git仓库
2. **分析代码变更** - 智能分析修改的文件类型和功能
3. **生成提交信息** - 根据分析结果自动生成规范的提交信息
4. **确认提交** - 显示生成的提交信息供用户确认
5. **执行提交** - 添加文件并提交代码
6. **推送选项** - 可选择是否推送到远程仓库

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

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📄 许可证

ISC License

## 🔗 相关链接

- [npm包页面](https://www.npmjs.com/package/gc-npm-package)
- [Conventional Commits规范](https://www.conventionalcommits.org/)

---

**让Git提交变得简单而规范！** 🎉
