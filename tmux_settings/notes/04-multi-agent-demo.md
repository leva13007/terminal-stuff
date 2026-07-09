# 04 — Live demo: кілька AI-агентів паралельно в tmux

Побудовано на `01-basics.md` (panes), `02-config.md` (pane titles через `tp`, layouts) і `03-plugins.md` (сесія живе незалежно від того, підключений ти чи ні). Мета — не просто "відкрити N терміналів", а показати чому tmux — природний інструмент для паралельної роботи з кількома AI-агентами (Claude Code): кожен агент у своїй панелі, зі своєю назвою, зі своєю ізольованою робочою копією коду.

---

## Проблема, яку вирішуємо

Якщо запустити кілька Claude Code сесій в одній робочій копії репозиторію — агенти конфліктують: редагують ті самі файли, git-стан плутається, важко зрозуміти хто що змінив.

Рішення — **один агент = одна git worktree = одна tmux-панель**. Кожен worktree — окрема директорія з власним checkout окремої гілки того самого репозиторію, без дублювання `.git`.

---

## Git worktree — коротко

```bash
# з кореня основного репо
git worktree add ../repo-agent-1 -b agent-1-feature
git worktree add ../repo-agent-2 -b agent-2-feature
git worktree add ../repo-agent-3 -b agent-3-feature
```

Кожна команда створює нову директорію (`../repo-agent-N`) з чекаутом нової гілки. Спільна історія, спільний `.git` (як object store), але файли на диску — незалежні. Агент у `repo-agent-1` ніколи не зачепить файли, які редагує агент у `repo-agent-2`.

Прибирання після демо:

```bash
git worktree remove ../repo-agent-1
git worktree remove ../repo-agent-2
git worktree remove ../repo-agent-3
```

---

## Layout: N панелей, по одному агенту в кожній

Використовуємо вже наявні біндинги з `config/tmux.conf` (`bind h`/`bind v` для splits) і вбудовану циклічну зміну розкладок (`prefix + Space` → `tiled` — рівні панелі, найкраще для 3-4 агентів на стрімі).

Ручний варіант (для розуміння що відбувається):

```bash
tmux new -s agents -c ../repo-agent-1
tmux split-window -h -t agents -c ../repo-agent-2
tmux split-window -v -t agents -c ../repo-agent-3
tmux select-layout -t agents tiled
```

Підпис кожної панелі — через вже задокументовану функцію `tp` (`config/zshrc-additions.zsh`), одразу після заходу в кожну панель:

```bash
tp "agent-1: auth"
tp "agent-2: tests"
tp "agent-3: docs"
```

З `pane-border-status top` (вже в конфізі) назви видно постійно зверху кожної панелі — глядачі на стрімі одразу бачать хто над чим працює, без пояснень голосом.

---

## Скрипт для демо: `config/demo-agents.sh`

Щоб не набирати команди наживо (ризик одруку в прямому ефірі), весь запуск — одним скриптом. Три завдання і три назви — приклад, підставити реальні під конкретний демо-сценарій стріму.

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
SESSION="agents-demo"
TASKS=("agent-1:auth-refactor" "agent-2:add-tests" "agent-3:update-docs")

tmux kill-session -t "$SESSION" 2>/dev/null || true

for task in "${TASKS[@]}"; do
  name="${task%%:*}"
  branch="${task##*:}"
  worktree="${REPO_ROOT}-${name}"
  git -C "$REPO_ROOT" worktree add "$worktree" -b "$branch" 2>/dev/null || true
done

tmux new-session -d -s "$SESSION" -c "${REPO_ROOT}-agent-1"
tmux split-window -h -t "$SESSION" -c "${REPO_ROOT}-agent-2"
tmux split-window -v -t "$SESSION" -c "${REPO_ROOT}-agent-3"
tmux select-layout -t "$SESSION" tiled

tmux send-keys -t "$SESSION.0" 'tp "agent-1: auth"; claude' C-m
tmux send-keys -t "$SESSION.1" 'tp "agent-2: tests"; claude' C-m
tmux send-keys -t "$SESSION.2" 'tp "agent-3: docs"; claude' C-m

tmux attach -t "$SESSION"
```

Прибирання після демо (окремо, не автоматично — щоб встигнути показати діффи):

```bash
for name in agent-1 agent-2 agent-3; do
  git worktree remove "${REPO_ROOT}-${name}" --force
done
```

---

## Відомі підводні камені

| проблема | що робити |
|---|---|
| Малі панелі — з залу не видно тексту | Максимум 3-4 агенти одночасно на екрані. Для більшої кількості — `prefix + z` (zoom) по черзі, а не тримати всі дрібними |
| Claude Code питає підтвердження на кожну дію — заважає плавному демо | Заздалегідь узгодити з собою межі: або приймати запити наживо (чесніше, повільніше), або обмежити задачі настільки простими, що підтверджень майже нема. Не приховувати від глядачів що підтвердження — це нормальна поведінка інструменту, не баг |
| Кілька агентів одночасно = кілька паралельних API-запитів під одним акаунтом | Перевірити ліміти заздалегідь одним прогоном усіх трьох одразу, не тільки по одному |
| Merge гілок в кінці демо | Не автоматизувати — показати `git log --oneline --all --graph` і вручну прорев'ювати/змержити хоча б одну гілку наживо, це і є "вау"-момент |
| Скрипт не спрацював на людях (worktree вже існує з минулого прогону) | `git worktree list` перед стартом — прибрати старі worktree з попередніх репетицій |
| Запуск скрипту з биндингу всередині вже активної tmux-сесії (тієї, яку захоплює OBS) | Не биндити в `config/tmux.conf` — `demo-agents.sh` сам створює нову сесію і робить `tmux attach`, що всередині вже запущеної сесії дає nested-tmux плутанину. Запускати як звичайний shell-скрипт із зовнішнього терміналу/окремого вікна, яке потім і захоплює OBS |

---

## Обов'язково перед стрімом

Прогнати `config/demo-agents.sh` end-to-end щонайменше один раз на реальному тестовому репо — не лише прочитати скрипт. Живі AI-агенти в кількох панелях одночасно — саме той сценарій, де щось непередбачене (rate limit, зависла панель, конфлікт гілок) проявляється тільки під час фактичного запуску.
