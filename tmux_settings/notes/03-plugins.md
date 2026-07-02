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

---

## Дебаг: плагіни "встановлені", але не працюють

Найкоєарніший кейс — здається що resurrect/continuum зберігають сесію, а по факту після ребута нічого не відновлюється. Перевіряти по кроках, а не гадати.

### 1. Чи взагалі встановились плагіни

```bash
ls ~/.tmux/plugins/
# має бути: tpm  tmux-sensible  tmux-resurrect  tmux-continuum
```

Якщо якоїсь папки немає — `prefix + I` не відпрацював (немає інтернету, TPM не проініціалізований, або `run '~/.tmux/plugins/tpm/tpm'` не є останнім рядком конфігу). Порожня/відсутня папка плагіна = плагін фізично не існує, скільки не тисни `prefix + Ctrl+s`.

**Якщо `~/.tmux` взагалі не існує** (`ls: ~/.tmux: No such file or directory`) — це означає TPM не встановлювався жодного разу, навіть крок 1 з "Покрокового сетапу" вище пропущено. `git clone` сам створює всі проміжні директорії, тому відсутня `~/.tmux` = не було навіть спроби клонування, а не "невдала установка". Виправлення:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Після цього — переконайся що `~/.tmux.conf` містить блок `@plugin` + `run '~/.tmux/plugins/tpm/tpm'` (крок 2 нижче), рестартуй tmux і зроби `prefix + I`.

### 2. Чи той конфіг взагалі активний

Проєктний конфіг лежить у `config/tmux.conf`, але tmux читає `~/.tmux.conf`. Якщо копію (`cp config/tmux.conf ~/.tmux.conf`) забув оновити після правок — біжить старий конфіг без плагінів.

```bash
diff ~/.tmux.conf config/tmux.conf   # має бути порожньо
tmux show-options -g | grep continuum
```

Якщо `show-options -g` не показує `@continuum-restore` — конфіг з плагінами не завантажений в поточну tmux-сесію. Треба `prefix + r` (reload) або повний рестарт tmux сервера.

### 3. Чи реально відбувається save (resurrect)

```bash
prefix + Ctrl+s
ls -la ~/.tmux/resurrect/
cat ~/.tmux/resurrect/last     # symlink на останній save-файл
```

Якщо `~/.tmux/resurrect/` порожня або `last` не оновлюється після `prefix + Ctrl+s` — сама команда save не викликається. Перевір біндинги:

```bash
tmux list-keys | grep resurrect
```

Якщо порожньо — плагін не заскриптився в поточну сесію (запущений tmux до встановлення плагіна — потрібен повний рестарт сервера, не просто `source-file`).

### 4. Головна пастка з continuum — restore спрацьовує тільки при старті СЕРВЕРА

`@continuum-restore 'on'` відновлює стан лише коли **стартує tmux server з нуля** — тобто коли *всі* сесії до цього були вбиті і сервер зупинився. Якщо:

- закрив термінал, але tmux-сервер лишився живим у фоні (інша сесія досі відкрита) → новий `tmux attach` НЕ тригерить restore, бо сервер не рестартував;
- вбив одну сесію (`kill-session`), а інша ще активна → сервер живий → restore не спрацює.

Перевірити чи сервер справді мертвий:

```bash
tmux ls
# "no server running on ..." — сервер справді впав, наступний `tmux` викличе restore
```

Якщо треба перевірити restore вручну, без чекання ребута:

```bash
tmux kill-server     # ⚠️ вбиває ВСІ сесії — переконайся що save вже був
tmux                 # новий старт сервера → має підтягнути last save
```

### 5. Continuum autosave (кожні 15 хв) вимагає живого клієнта

Автозбереження — це `run-shell` цикл, який тригериться поки є **приєднаний клієнт**. Якщо сесія detached і жоден термінал до неї не підключений (наприклад весь час сидиш в SSH, який відвалився) — autosave може не встигнути відпрацювати до того як щось впаде.

### Швидкий чеклист

| перевірка | команда | ок якщо |
|---|---|---|
| плагін фізично встановлений | `ls ~/.tmux/plugins/` | папки tpm/resurrect/continuum існують |
| активний конфіг = проєктний | `diff ~/.tmux.conf config/tmux.conf` | порожній вивід |
| опції плагіна завантажені | `tmux show-options -g \| grep continuum` | рядок присутній |
| біндинги зареєстровані | `tmux list-keys \| grep resurrect` | не порожньо |
| save реально пишеться | `cat ~/.tmux/resurrect/last` | свіжий timestamp після `prefix+Ctrl+s` |
| сервер справді був мертвий перед restore | `tmux ls` до старту | "no server running" |
