# Bashx.TelegramBots
A few Telegram bot scripts.

---

## Release

`0.0.8`
| [GitHub](https://github.com/stanbashx/Bashx.TelegramBots/releases/tag/0.0.8)
| [Key](https://stanbashx.github.io/release-public.pem)

### Build and Install

```
$ ./assemble.sh \
 && ./src/test/bash/unit_test.sh \
 && unzip -d /opt/Bashx.TelegramBots-0.0.8 ./build/zip/Bashx.TelegramBots-0.0.8.zip
```

### Download and Install

```
$ TMP_PATH="$(mktemp)"; \
 curl -L 'https://github.com/stanbashx/Bashx.TelegramBots/releases/download/0.0.8/Bashx.TelegramBots-0.0.8.zip' \
  -o "${TMP_PATH}" && unzip -d /opt/Bashx.TelegramBots-0.0.8 "${TMP_PATH}" && rm "${TMP_PATH}"
```

---
