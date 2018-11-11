#!/bin/bash
# resetore the original colors when done running guard
[ -x "$(which emacsclient)" ] && emacsclient --eval '(set-face-attribute '\''mode-line nil :background "#1e2320" :foreground "#acbc90")' >/dev/null
[ -x "$(which tmux)" ] && tmux set status-left-bg colour239
