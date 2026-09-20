if status is-interactive
  # Commands to run in interactive sessions can go here
  function fish_mode_prompt
  end
  function dot
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
  end
  set -g fish_key_bindings fish_vi_key_bindings
end
