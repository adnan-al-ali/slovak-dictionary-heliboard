#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$script_dir"
source_dir="$project_root/hunspell-sk"
build_dir="$project_root/build"
backup_dir="$project_root/Backups"

export LC_ALL="${LC_ALL:-sk_SK.UTF-8}"

mkdir -p "$backup_dir"
rm -rf "$build_dir"
mkdir -p "$build_dir"
: >"$build_dir/dict"

for file in \
	"$source_dir/_osobnosti/sport.dic" \
	"$source_dir/_osobnosti/politika.dic" \
	"$source_dir/_osobnosti/it.dic" \
	"$source_dir/_osobnosti/rozne.dic" \
	"$source_dir/_skratky/it.dic" \
	"$source_dir/_skratky/geografia.dic" \
	"$source_dir/_skratky/politika.dic" \
	"$source_dir/_skratky/rozne.dic" \
	"$source_dir/_tematicke/nabozenske.dic" \
	"$source_dir/_tematicke/cudzie.dic" \
	"$source_dir/_terminy/it.dic" \
	"$source_dir/sk_SK.dic"
do
	sed '1d' "$file" >>"$build_dir/dict"
	printf '\n' >>"$build_dir/dict"
done

sort -u "$build_dir/dict" >"$build_dir/temp.dic"

grep -v '/' "$build_dir/temp.dic" | grep -v ':' >"$build_dir/sk_noflag.dic"
grep -v '/' "$build_dir/temp.dic" | grep ':' >"$build_dir/sk_fl.tmp"
grep '/' "$build_dir/temp.dic" >>"$build_dir/sk_fl.tmp"
wc -l <"$build_dir/sk_fl.tmp" | cat - "$build_dir/sk_fl.tmp" | sort -u >"$build_dir/sk_fl.dic"
cp "$source_dir/sk_SK.aff" "$build_dir/sk_fl.aff"

hunspell -d "$build_dir/sk_fl" -l "$build_dir/sk_noflag.dic" >"$build_dir/add.words"
tr -d '\r' <"$build_dir/add.words" >"$build_dir/add.words.unix"
mv "$build_dir/add.words.unix" "$build_dir/add.words"
sed '1d' "$build_dir/sk_fl.dic" >"$build_dir/temp.dic"
cat "$build_dir/add.words" >>"$build_dir/temp.dic"
sort -u <"$build_dir/temp.dic" >"$build_dir/sk_SK.dic"

datestamp="$(date +%Y%m%d)"
if [[ -f "$project_root/sk_SK.dic" && ! -e "$backup_dir/sk_SK.dic-$datestamp.bak" ]]; then
	mv "$project_root/sk_SK.dic" "$backup_dir/sk_SK.dic-$datestamp.bak"
fi

wc -l <"$build_dir/sk_SK.dic" | cat - "$build_dir/sk_SK.dic" >"$project_root/sk_SK.dic"
cp "$source_dir/sk_SK.aff" "$project_root/sk_SK.aff"

echo "Finished."
