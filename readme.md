# 基于[Florida](https://github.com/Ylarod/Florida)写的dockerfile
一键生成frida-server
```bash
# kjlk 进程名和文件名
docker build --build-arg NAME=kjlk -t frida --output . .
```

```python
patch_values ="".join(random.sample(random_charset, len(patch_str)))
patch = [ord(n) for n in patch_values]
log_color(f"[*] Patching section name={section.name} offset={hex(section.file_offset + addr)} orig:{patch_str} new:{patch_values}")
```

## References

- [https://github.com/Ylarod/Florida](https://github.com/Ylarod/Florida)
- [https://www.bilibili.com/video/BV1mFsDeGEJ9](https://www.bilibili.com/video/BV1mFsDeGEJ9)