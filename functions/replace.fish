function replace --description 'find and replace' --argument-names from to
    if test -z $from; or test -z $to
        echo 'Need a search and a replace pattern'
        return 1
    end

    set rg_command rg --fixed-strings -l $from
    set fzf_command fzf \
        --color=16 \
        --preview="rg --line-number --fixed-strings --color=always --context=2 $from -r $to {1}" \
        --layout=reverse \
        --multi

    set selected_files ($rg_command | $fzf_command)

    if test -n "$selected_files"
        for file in $selected_files
            rg --fixed-strings --passthrough $from -r $to $file | sponge $file
        end
    end

    commandline -f repaint
end
