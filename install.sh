#!/usr/bin/env sh
# ouu-shiit installer
#
# Built on the skills CLI from vercel-labs — https://skills.sh
# Installs ouu-shiit, plus the design skills it is designed to be used with.
#
#   ./install.sh                 install everything, for Claude Code, globally
#   AGENT='*' ./install.sh       install for every agent detected on the machine
#   AGENT=cursor ./install.sh    install for Cursor only
#   SCOPE= ./install.sh          install into the current project instead of ~/
#   SKILL=0 ./install.sh         skip the companion skills, install ouu-shiit only
#
# On Windows, run this from Git Bash, or use install.cmd.

set -eu

AGENT="${AGENT:-claude-code}"
SCOPE="${SCOPE--g}"
SKILL="${SKILL:-1}"

if ! command -v npx >/dev/null 2>&1; then
  printf '%s\n' "npx not found. Install Node.js 18 or newer first: https://nodejs.org" >&2
  exit 1
fi

add() {
  printf '\n\033[1m→ npx skills add %s\033[0m\n' "$*"
  # SCOPE is intentionally unquoted: it is a flag or empty.
  # shellcheck disable=SC2086
  npx -y skills add "$@" $SCOPE -a "$AGENT" -y
}

printf '\n\033[1mouu-shiit\033[0m — GPU effects and scroll layers for the web\n'
printf 'agent: %s   scope: %s\n' "$AGENT" "${SCOPE:-(project)}"

add asterxsk/ouu-shiit --skill ouu-shiit

if [ "$SKILL" != "0" ]; then
  # The design skills this one pairs with. Each is a separate upstream repo.
  add pbakaus/impeccable --skill impeccable
  add Leonxlnx/taste-skill --skill design-taste-frontend
  add vercel-labs/agent-skills --skill web-design-guidelines
fi

cat <<'EOF'

──────────────────────────────────────────────────────────────────
Done.

  ouu-shiit              the effect layer (this repo)
  impeccable             visual direction and craft
  design-taste-frontend  brief inference, motion budget, pre-flight check
  web-design-guidelines  interface audit

Optional, not installable — it is reference material, not a skill:

  awesome-design-md      74 analysed brand DESIGN.md systems

    git clone --depth 1 https://github.com/VoltAgent/awesome-design-md

  Copy a single brand file into a project root when a brief names one.
  See skills/ouu-shiit/reference/design-references.md.

Restart your agent so the new skills are picked up.

Docs:  https://skills.sh
EOF
