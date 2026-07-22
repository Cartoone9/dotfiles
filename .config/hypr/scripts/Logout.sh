#!/usr/bin/env bash
# Graceful session teardown: ask session apps to quit and wait for them, stop
# the graphical session units, THEN exit Hyprland (or hand off to systemd for
# reboot/poweroff). Exiting the compositor first yanks the display out from
# under running apps (Discord, browsers, ...) and leaves hyprpolkitagent
# restart-looping into a dead session — both of which crash and dump core.
#
# Usage: Logout.sh [logout|reboot|poweroff]   (default: logout)
# Debug log: ~/.cache/hypr-logout.log

mode="${1:-logout}"
case "$mode" in
  logout|reboot|poweroff) ;;
  *) echo "unknown mode: $mode" >&2; exit 1 ;;
esac

exec >>"$HOME/.cache/hypr-logout.log" 2>&1
echo "=== $mode started: $(date '+%F %T') ==="

ancestors_of() { # print pid + all its ancestors
  local p=$1
  while [ -n "$p" ] && [ "$p" -gt 1 ] 2>/dev/null; do
    echo "$p"
    p=$(awk '/^PPid:/{print $2}' "/proc/$p/status" 2>/dev/null)
  done
}

# Never kill: this script + its ancestors, and Hyprland + ITS ancestors
# (start-hyprland, gdm-wayland-session, ...). Hyprland double-forks spawned
# commands, so our own parent chain does NOT reach the compositor.
hypr_pid=$(pgrep -x Hyprland | head -1)
keep=" "
for p in $(ancestors_of $$); do keep+="$p "; done
for h in $(pgrep -x Hyprland); do
  for p in $(ancestors_of "$h"); do keep+="$p "; done
done
# Xwayland is Hyprland's child: it ignores SIGTERM and is torn down by the
# compositor itself at exit — killing it just stalls the wait loop for 5s.
for x in $(pgrep -x Xwayland); do keep+="$x "; done

# Candidates: every process in this login session's scope, plus the owner of
# every open window (catches apps that landed outside the session scope)
scope="/sys/fs/cgroup/user.slice/user-$(id -u).slice/session-${XDG_SESSION_ID}.scope"
mapfile -t candidates < <(
  {
    [ -d "$scope" ] && find "$scope" -name cgroup.procs -exec cat {} +
    hyprctl clients -j | jq -r '.[].pid'
  } 2>/dev/null | sort -un
)

targets=()
for pid in "${candidates[@]}"; do
  case "$keep" in *" $pid "*) continue ;; esac
  targets+=("$pid")
done
echo "keep:$keep| targets: ${targets[*]}"

if [ "${#targets[@]}" -gt 0 ]; then
  kill -TERM "${targets[@]}" 2>/dev/null

  # Give them up to 5 seconds to exit cleanly
  for _ in $(seq 50); do
    alive=0
    for pid in "${targets[@]}"; do
      kill -0 "$pid" 2>/dev/null && { alive=1; break; }
    done
    [ "$alive" -eq 0 ] && break
    sleep 0.1
  done

  survivors=()
  for pid in "${targets[@]}"; do
    kill -0 "$pid" 2>/dev/null && survivors+=("$pid $(ps -o comm= -p "$pid" 2>/dev/null)")
  done
  if [ "${#survivors[@]}" -gt 0 ]; then
    echo "ignored SIGTERM, sending SIGKILL: ${survivors[*]}"
    for s in "${survivors[@]}"; do kill -KILL "${s%% *}" 2>/dev/null; done
  fi
fi
echo "apps terminated: $(date '+%T')"

# Stop session-bound user services (hyprpolkitagent, ...) cleanly while the
# compositor still exists; nothing else stops these targets in a GDM session,
# which is what caused the restart-into-dead-session crash loop.
systemctl --user stop hyprland-session.target graphical-session.target
echo "session targets stopped (rc=$?): $(date '+%T')"

# For reboot/poweroff, hand off to systemd now: it tears down Hyprland and the
# session in proper unit order. Exiting the compositor ourselves first would
# risk this script being reaped with the session before it can issue the call.
if [ "$mode" != "logout" ]; then
  echo "handing off to systemctl $mode"
  exec systemctl "$mode"
fi

# Exit the compositor — this Hyprland uses a Lua dispatch layer, so the
# dispatcher must be a Lua expression, not the plain "exit" keyword.
# Fallbacks below so we can never strand the user on an empty session.
hyprctl dispatch 'hl.dsp.exit()'
echo "hyprctl dispatch hl.dsp.exit() rc=$?"
for _ in $(seq 30); do
  kill -0 "$hypr_pid" 2>/dev/null || { echo "Hyprland exited cleanly"; exit 0; }
  sleep 0.1
done

echo "Hyprland still alive after dispatch exit -> SIGTERM"
kill -TERM "$hypr_pid" 2>/dev/null
for _ in $(seq 30); do
  kill -0 "$hypr_pid" 2>/dev/null || { echo "Hyprland exited on SIGTERM"; exit 0; }
  sleep 0.1
done

echo "Hyprland ignoring SIGTERM -> loginctl terminate-session ${XDG_SESSION_ID}"
loginctl terminate-session "$XDG_SESSION_ID"
