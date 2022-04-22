function replace --description 'find and replace' --argument-names from to
    set rg_command rg -l $from
    set fzf_command fzf \
        --color=16 \
        --preview="rg --line-number --color=always --context=2 $from -r $to {1}" \
        --layout=reverse \
        --multi

    set selected_files ($rg_command | $fzf_command)

    if test -n "$selected_files"
        for file in $selected_files
            rg --passthrough $from -r $to $file | sponge $file
        end
    end

    commandline -f repaint
end
