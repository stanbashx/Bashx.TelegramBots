# TelegramBots
A few Telegram bot scripts.

---

## Release

`0.0.7`
| [GitHub](https://github.com/StanleyProjects/TelegramBots/releases/tag/0.0.7)
| [Key](https://StanleyProjects.github.io/release-public.pem)

### Build and Install

```
$ ./assemble.sh \
 && ./src/test/bash/unit_test.sh \
 && unzip -d /opt/TelegramBots-0.0.7 ./build/zip/TelegramBots-0.0.7.zip
```

### Download and Install

```
$ TMP_PATH="$(mktemp)"; \
 curl -L 'https://github.com/StanleyProjects/TelegramBots/releases/download/0.0.7/TelegramBots-0.0.7.zip' \
  -o "${TMP_PATH}" && unzip -d /opt/TelegramBots-0.0.7 "${TMP_PATH}" && rm "${TMP_PATH}"
```

---
