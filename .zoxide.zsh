# ======================================================================================
# Zoxide
# ======================================================================================
eval "$(zoxide init zsh)"

# ======================================================================================
# Zoxide / zi fzf UI
# ======================================================================================
export _ZO_FZF_OPTS='
--border=rounded
--border-label=zi
--height=100%
--layout=default
--info=inline
--delimiter=[[:space:]]+
--preview=eza\ --icons\ --group-directories-first\ --color=always\ --tree\ --level=2\ {2..}
--preview-window=right:50%:wrap
--color=fg:#f8f8f2,hl:#f92672
--color=fg+:#f8f8f2,hl+:#fd971f
--color=border:#494949,prompt:#66d9ef,pointer:#66d9ef
--color=marker:#fd971f,spinner:#fd971f,info:#ae81ff
'
