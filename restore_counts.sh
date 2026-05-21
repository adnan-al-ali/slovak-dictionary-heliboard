#!/usr/bin/env bash

filtered="filtered.txt"
spell="spell_checked.txt"

exec 3< "$spell"

IFS= read -r spell_word <&3 || exit 0

while IFS= read -r line; do
    # split into word and count
    word=${line%%$'\t'*}
    count=${line#*$'\t'}

    if [[ "$word" == "$spell_word" ]] || (($count > 1000)); then
        printf ' word=%s,f=%s\n' "$word" "$count"

        if ! IFS= read -r spell_word <&3; then
            break
        fi
    fi
done < "$filtered"

exec 3<&-
