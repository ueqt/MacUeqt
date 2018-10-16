#  Mac Ueqt

Ueqt's Mac Assistant

因为不想系统中软件过多，所以想把各种软件集成到一起，所以自己写一个吧

* Only for self usage, so many feature is only tested on my mac.

## I do not need

### FinderGo, Go2Shell

[x] Open Finder current path in iTerm from `Main Icon Menu` -> `Finder` -> `iTerm`

### Unlox

[ ] Capture Photos at screen wake up and face detection then face recognition then auto login

### TinyCal(小历)
[ ] Calendar

### 腾讯电脑管家 
[ ] Cpu usage
[ ] Memory usage
[ ] Network usage

## Other Feature

[x] Start at login

## 如果 start at login 功能失败

```bash
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -dump|grep .*path.*MacUeqt.
```

删除相关多余目录

```bash
# 重置数据库
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
```
