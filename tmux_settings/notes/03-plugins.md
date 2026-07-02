# 03 — Плагіни: TPM, sensible, resurrect, continuum

Як встановити менеджер плагінів і плагіни з поточного `config/tmux.conf`.

---

## TPM — Tmux Plugin Manager

TPM — це менеджер плагінів для tmux. Встановлюється один раз, далі управляє всіма іншими плагінами.

### Встановлення TPM

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Клонуємо репозиторій у `~/.tmux/plugins/tpm` — саме туди, звідки tmux його очікує.

---

## Структура в конфізі

```
# TPM
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'on'

# Ініціалізація — завжди останній рядок!
run '~/.tmux/plugins/tpm/tpm'
```

`set -g @plugin` — оголошує плагін. TPM читає ці рядки і знає що завантажувати.

`run '~/.tmux/plugins/tpm/tpm'` — запускає TPM при старті tmux. **Завжди має бути останнім рядком** у конфізі.

---

## Встановлення плагінів

Після того як TPM встановлено і конфіг підключено:

1. Відкрити (або перезапустити) tmux
2. Натиснути `prefix + I` (велика `I`, тобто `Shift+i`)

TPM скачає і встановить всі плагіни з `@plugin` рядків.

```
prefix + I      — встановити/оновити плагіни
prefix + U      — оновити всі плагіни
prefix + Alt+u  — видалити плагіни яких немає в конфізі
```

---

## Плагіни

### tmux-sensible

```
set -g @plugin 'tmux-plugins/tmux-sensible'
```

Набір розумних дефолтів, які мали б бути в tmux з коробки. Наприклад:

- `set -g escape-time 0` — прибирає затримку після Escape (важливо для vim/neovim)
- `set -g history-limit 50000` — більший буфер скролінгу
- `set -g display-time 4000` — статус-повідомлення видно довше
- `set -g focus-events on` — дозволяє редакторам (vim) отримувати події фокусу

Немає потреби конфігурувати вручну — плагін все це вмикає автоматично.

---

### tmux-resurrect

```
set -g @plugin 'tmux-plugins/tmux-resurrect'
```

Зберігає і відновлює tmux-сесії після перезапуску комп'ютера.

Без resurrect — після ребуту всі сесії, вікна і панелі зникають. З ним — відновлюються одним натисканням.

```
prefix + Ctrl+s   — зберегти поточний стан (sessions, windows, panes, cwd)
prefix + Ctrl+r   — відновити збережений стан
```

Що зберігається: список сесій → список вікон → список панелей → робочі директорії → запущені програми (bash, vim, etc.).

---

### tmux-continuum

```
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'on'
```

Розширення для resurrect: автоматично зберігає стан кожні 15 хвилин (без `prefix + Ctrl+s`).

`@continuum-restore 'on'` — вмикає **автовідновлення**: при запуску tmux він сам відновить останній збережений стан. Вручну натискати `prefix + Ctrl+r` не потрібно.

> resurrect і continuum працюють разом: continuum автоматизує збереження/відновлення, resurrect надає механізм і ручні шорткати.

---

## Зведена таблиця шорткатів

| команда | що робить |
|---------|-----------|
| `prefix + I` | встановити плагіни |
| `prefix + U` | оновити плагіни |
| `prefix + Alt+u` | видалити невикористані |
| `prefix + Ctrl+s` | зберегти стан (resurrect) |
| `prefix + Ctrl+r` | відновити стан (resurrect) |

---

## Покроковий сетап з нуля

```bash
# 1. Встановити TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 2. Скопіювати конфіг
cp config/tmux.conf ~/.tmux.conf

# 3. Запустити (або перезапустити) tmux
tmux

# 4. Встановити плагіни
# Ctrl+b I

# 5. Перезавантажити конфіг (якщо tmux вже був запущений)
# Ctrl+b r
```
