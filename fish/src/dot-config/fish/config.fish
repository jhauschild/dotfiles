#!/usr/bin/fish

set -gx GPG_TTY (tty)
set -g fish_key_bindings fish_hybrid_key_bindings

set -gx PATH $PATH /home/johannes/bin
# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/johannes/.lmstudio/bin
# End of LM Studio CLI section

