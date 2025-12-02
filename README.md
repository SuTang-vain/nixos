# NixOS Configuration

一个现代化的、功能完整的 NixOS 配置，支持 Wayland、Niri 窗口管理器和完整的开发环境。

## ✨ 特性

### 🖥️ 桌面环境
- **Niri** - 现代化的 Wayland 合成器
- **Stylix** - 主题管理系统
- **Quickshell** - 快速访问 shell 工具
- **多种 Shell 主题** - DankMaterialShell, Caelestia, Noctalia

### 🛠️ 开发工具
- **NixVim** - 完全配置的 Neovim IDE
- **代码格式化** - Treefmt 配置支持多种语言
- **NH (Nix Helper)** - 简化的 NixOS 管理工具（稳定版本）
- **NIL/Nixd** - Nix 语言服务器和守护进程

### 📦 包管理
- **NUR** - Nix User Repository
- **自定义包** - 浙大连接器、字体、壁纸等
- **包覆盖** - 优化的配置和修复

### 🔧 系统管理
- **Agenix** - 加密密钥管理
- **Fcitx5** - 中文输入法支持
- **Fish Shell** - 现代化的交互式 shell

## 🚀 快速开始

### 前置要求
- NixOS 24.05+ 系统
- 至少 16GB 内存（推荐 32GB）
- 50GB+ 可用磁盘空间（用于 `/nix`）
- 稳定的网络连接

### 1. 克隆仓库
```bash
cd ~
git clone https://github.com/SuTang-vain/nixos.git
cd nixos
```

### 2. 配置主机信息
编辑 `hosts/hosts.nix`，修改主机名和用户名：
```nix
{
  host = "your-hostname";  # 修改为你的主机名
  user = "your-username";  # 修改为你的用户名
  # ...
}
```

### 3. 生成硬件配置
```bash
# 创建硬件配置目录
mkdir -p hosts/your-hostname

# 生成当前机器的硬件配置
sudo nixos-generate-config --show-hardware-config > hosts/your-hostname/hardware-configuration.nix
```

### 4. 启用实验特性
```bash
echo "experimental-features = nix-command flakes pipe-operators" | sudo tee /etc/nix/nix.conf
sudo systemctl restart nix-daemon
```

### 5. 验证配置
```bash
# 检查 flake 结构
nix flake show

# 检查语法错误
nix flake check
```

### 6. 构建系统
```bash
# 构建 NixOS 系统（替换 your-hostname 和 your-username）
sudo nixos-rebuild switch --flake .#your-hostname --show-trace

# 构建 Home Manager
nix run home-manager/master -- switch --flake .#your-username@your-hostname --show-trace
```

### 7. 重启系统
```bash
sudo reboot
```

## 📁 项目结构

```
nixos/
├── flake.nix              # 主配置文件和输入
├── hosts/                 # 主机特定配置
│   ├── default.nix        # 主机构建器
│   ├── hosts.nix          # 主机定义列表
│   └── inspiron/          # Dell Inspiron 配置示例
├── home/                  # Home-Manager 配置
│   ├── default.nix        # 主 Home-Manager 配置
│   ├── lib/               # 共享库
│   ├── programs/          # 程序配置
│   └── tweaks/            # 个性化调整
├── os/                    # NixOS 系统配置
│   ├── programs/          # 系统程序配置
│   └── system/           # 系统设置
├── modules/               # 共享模块
├── overlays/              # 包覆盖
├── pkgs/                  # 自定义包
└── secrets/               # 敏感信息管理
```

## ⚙️ 配置说明

### 主机配置
每个主机的配置在 `hosts/` 目录下：
- **`hosts.nix`** - 定义所有主机信息
- **`your-hostname/`** - 特定主机配置目录
- **`hardware-configuration.nix`** - 硬件配置（由 nixos-generate-config 生成）

### 包管理
- **Overlays** - 在 `overlays/default.nix` 中定义包覆盖
- **自定义包** - 在 `pkgs/` 目录下定义新包
- **稳定版本优先** - NH 等工具使用 nixpkgs 稳定版本避免下载问题

### 主题定制
- **Stylix** - 自动生成系统主题
- **颜色方案** - 支持多种颜色主题
- **壁纸** - 自定义壁纸配置

## 🛠️ 常用命令

### 系统更新
```bash
# 更新系统配置
sudo nixos-rebuild switch --flake .#your-hostname

# 更新用户配置
home-manager switch --flake .#your-username@your-hostname

# 使用 NH 工具（更便捷）
nixu  # 相当于 sudo nixos-rebuild switch
homeu # 相当于 home-manager switch
nixc  # 启动清理服务
```

### 调试和清理
```bash
# 检查配置语法
nix flake check

# 查看可用的配置
nix flake show

# 清理旧的 Nix 存储
nix store gc --delete-older-than 30d

# 查看构建日志
journalctl -u nix-daemon -f
```

## 🔧 自定义配置

### 添加新包
编辑 `home/default.nix` 或 `home/programs/` 下的相应文件：
```nix
home.packages = with pkgs; [
  package1
  package2
  # 你的包
];
```

### 添加新服务
在 `os/programs/` 目录下创建新配置文件并导入到 `os/default.nix`。

### 自定义主题
修改 `home/tweaks/stylix.nix` 来调整主题设置。

## 🐛 故障排除

### 常见问题

**Q: 构建失败，提示包下载卡住**
A: 配置已修复此类问题。如果仍然遇到，检查：
- 网络连接稳定性
- 磁盘空间是否充足
- 内存是否足够（推荐 16GB+）

**Q: NH 工具无法使用**
A: 确保已正确设置主机名和用户名，并且：
```bash
# 检查 NH 是否安装
which nh

# 检查 Fish 别名
type nixu homeu nixc
```

**Q: 输入法无法使用**
A: 确保已正确配置环境变量并重启会话：
```bash
# 检查 Fcitx5 状态
fcitx5-diagnose

# 重新配置环境
sudo systemctl restart gdm
```

**Q: Git 提示仓库不干净**
A: Nix flakes 要求仓库状态干净：
```bash
git add .
git commit -m "Fix configuration"
```

### 调试模式
```bash
# 使用详细日志构建
sudo nixos-rebuild switch --flake .#your-hostname --show-trace --verbose

# 检查配置评估
nix eval .#nixosConfigurations --apply builtins.attrNames
```

## 📝 更新日志

### v1.2.0 - 重建稳定性修复
- ✅ 修复 ToDesk 和 NH 包下载卡住问题
- ✅ NH 工具使用 nixpkgs 稳定版本
- ✅ 禁用有问题的系统服务
- ✅ 简化配置依赖关系

### v1.1.0 - 功能增强
- ✅ 添加完整的开发环境支持
- ✅ 集成多种 Shell 主题
- ✅ 优化包管理和清理
- ✅ 增强主题定制功能

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 🔗 相关链接

- [NixOS 官方文档](https://nixos.org/manual/nixos/)
- [NixVim 项目](https://github.com/nix-community/nixvim)
- [Niri 窗口管理器](https://github.com/sodiboo/niri-flake)
- [Stylix 主题管理](https://github.com/nix-community/stylix)
- [NH Nix Helper](https://github.com/nix-community/nh)
