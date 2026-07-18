# Codex Dream Skin Themes

用于保存和分享 Codex Dream Skin macOS 主题包的独立仓库。

换肤引擎来自 [`Fei-Away/Codex-Dream-Skin`](https://github.com/Fei-Away/Codex-Dream-Skin)；本仓库只保存主题素材和安装脚本。

## 当前主题

| 主题 | ID |
| --- | --- |
| 绯红银誓 | `preset-crimson-silver` |

## 安装

先启动过一次官方 Codex，然后退出 Codex。若尚未安装引擎：

```bash
git clone https://github.com/Fei-Away/Codex-Dream-Skin.git
cd Codex-Dream-Skin/macos
./scripts/install-dream-skin-macos.sh --no-launch
```

再安装本主题仓库：

```bash
git clone https://github.com/aaronfang/codex-dream-skin-themes.git
cd codex-dream-skin-themes
./scripts/install-themes-macos.sh --id preset-crimson-silver
```

主题会复制到：

```text
~/Library/Application Support/CodexDreamSkinStudio/themes/
```

只安装、不立即应用：

```bash
./scripts/install-themes-macos.sh --no-apply
```

之后请使用桌面的 `Codex Dream Skin.command` 启动 Codex。直接双击 `/Applications/ChatGPT.app` 不会打开主题所需的本机 CDP 调试会话。

## 切换主题

```bash
ENGINE="$HOME/.codex/codex-dream-skin-studio/scripts"
"$ENGINE/switch-theme-macos.sh" --id preset-crimson-silver
```

安装 SwiftBar 后，也可以从右上角 `🎨 Skin → 已保存的主题` 切换。安装入口来自引擎仓库：

```bash
cd /path/to/Codex-Dream-Skin/macos
./Install\ Menu\ Bar.command
```

## 更新

```bash
cd /path/to/codex-dream-skin-themes
git pull
./scripts/install-themes-macos.sh --id preset-crimson-silver
```

## 新增主题

新增一个目录：

```text
themes/preset-my-theme/
├── background.jpg
└── theme.json
```

主题要求：

- 目录名和 `theme.json.id` 使用 `preset-<slug>`；
- 背景为无 UI 的纯图片，推荐 `2560×1440`、16:9；
- 不超过 16 MB，宽高不超过 16384 像素，总像素不超过 5000 万；
- 左侧约 50%–58% 低信息、低对比，主体放在右侧；
- `theme.json.image` 只能是本目录内的文件名；
- 不要把 Codex 截图、窗口、按钮、文字、Logo 或水印放入背景。

新增后提交：

```bash
git add themes/preset-my-theme
git commit -m "feat: add my theme"
git push
```

安装脚本会自动安装仓库中的全部 `preset-*` 主题，且不会删除用户已有的 `custom-*` 主题。

## 素材权利

安装脚本按 MIT License 发布；主题背景图不自动获得软件许可证授权。公开分享前，请确认生图工具的输出许可、肖像权、版权、商标权、角色权和再分发权限。当前“绯红银誓”是外部工具生成的用户素材，详见 [`ARTWORK-NOTICE.md`](./ARTWORK-NOTICE.md)。
