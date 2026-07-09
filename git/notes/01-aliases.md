# 01 — Аліаси

Конспект. **Нічого звідси не застосовано** в `~/.gitconfig` чи `~/.zshrc` — це чернетка для відбору фінального набору.

Два різні рівні аліасів, і їх варто не плутати:

| | git alias | shell alias |
|---|---|---|
| де живе | `~/.gitconfig`, секція `[alias]` | `~/.zshrc` (чи `.bashrc`) |
| синтаксис виклику | `git st` | `gs` |
| працює | в будь-якому шелі, IDE-терміналі, скриптах | тільки в тому шелі де оголошений (zsh) |
| портативність | переноситься разом з dotfiles git-рівня | прив'язаний до конкретного `.zshrc` |
| для складної логіки | `!` + shell-команда всередині alias | будь-яка функція |

Загальне правило: **git alias — для команд, shell alias — для швидкого скорочення найчастіших git alias-ів.** Тобто `co` = git alias на `checkout`, а `gco` = shell alias на `git co`.

---

## git alias (`~/.gitconfig`)

Додати можна двома способами — командою:

```bash
git config --global alias.st status
```

або прямим редагуванням `~/.gitconfig`:

```ini
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --
    last = log -1 HEAD
    amend = commit --amend --no-edit
    undo = reset --soft HEAD~1
    aliases = config --get-regexp alias
```

| alias | розгортається в | навіщо |
|---|---|---|
| `git st` | `git status` | найчастіша команда, шкода на неї 6 символів |
| `git co <branch>` | `git checkout <branch>` | перемкнутись на гілку |
| `git br` | `git branch` | список гілок |
| `git ci` | `git commit` | коміт |
| `git unstage <file>` | `git reset HEAD -- <file>` | прибрати файл зі стейджингу, не чіпаючи зміни |
| `git last` | `git log -1 HEAD` | глянути останній коміт |
| `git amend` | `git commit --amend --no-edit` | доклеїти застейджені зміни до останнього коміту без зміни повідомлення |
| `git undo` | `git reset --soft HEAD~1` | відкотити останній коміт, зміни лишаються застейджені |
| `git aliases` | `git config --get-regexp alias` | побачити всі свої аліаси одним рядком |

### Просунуті — з `!` (виконують довільну shell-команду)

```ini
[alias]
    lg = log --graph --pretty=format:'%C(yellow)%h%Creset -%C(red)%d%Creset %s %C(green)(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    graph = log --oneline --graph --all --decorate
    who = shortlog -sn
    root = !git rev-parse --show-toplevel
    cleanup = !git branch --merged | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -d
```

| alias | що робить |
|---|---|
| `git lg` | компактний граф історії з кольорами, автором і відносним часом |
| `git graph` | простіший граф усіх гілок в один рядок на коміт |
| `git who` | хто скільки комітив (shortlog, відсортовано) |
| `git root` | шлях до кореня репозиторію (зручно в скриптах: `cd $(git root)`) |
| `git cleanup` | видаляє локальні гілки, які вже змерджені в main/master (⚠️ перевіряти перед запуском на реальному репо) |

`!` на початку означає "виконати як shell-команду", а не як git-підкоманду — тому можна пайпи, xargs, будь-що.

---

## shell alias (`~/.zshrc`)

Коротші за git alias, бо не треба навіть `git ` префіксу:

```zsh
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'
```

> Якщо в `~/.zshrc` вже підключений oh-my-zsh з `git` плагіном — частина цих аліасів (`gs`, `ga`, `gc`, `gp`, `gl`, `gco`, `gb`, `gd`) вже визначена ним. Перед тим як додавати свої — перевір конфлікти:
> ```bash
> alias | grep '^g[a-z]*='
> ```

---

## Чернетка — мій фінальний набір (TODO)

<!-- Сюди — фінальний вибір після того як пожив з конспектом. Позначити що з git alias, що з shell alias, і чи є конфлікти з oh-my-zsh git-плагіном. -->
