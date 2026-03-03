# CodeXNotePadDemo

基于最新 ArkTS 声明式 UI 风格实现的鸿蒙记事本示例，包含竞品常见的核心体验：

- 笔记新建、编辑、删除
- 关键字搜索
- 分类筛选（工作 / 生活 / 灵感）
- 笔记置顶排序
- 归档视图切换
- 底部浮动按钮 + 抽屉式编辑面板

## 目录结构

- `entry/src/main/ets/model/Note.ets`：数据模型与时间格式化
- `entry/src/main/ets/viewmodel/NoteViewModel.ets`：状态与业务逻辑
- `entry/src/main/ets/pages/Index.ets`：页面 UI 与交互实现

## 说明

当前示例以本地内存状态管理为主，方便快速演示交互。后续可接入 Preferences / RDB 持久化与分布式数据能力。
