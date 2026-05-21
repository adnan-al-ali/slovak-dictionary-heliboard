git clone https://github.com/sk-spell/hunspell-sk.git
bash build_hunspell.sh
wget --no-check-certificate https://korpus.juls.savba.sk/files/prim-11.0/prim-11.0-public-all-word_frequency.txt.bz2
bzip2 -d prim-11.0-public-all-word_frequency.txt.bz2
awk '$NF > 1' prim-11.0-public-all-word_frequency.txt | grep -P "^[\p{L}]+[\p{L}\-']*\t[0-9]+$" > filtered.txt
echo "Running the spell checker, this might take a while..."
hunspell -1 -d sk_SK -G filtered.txt > spell_checked.txt
./restore_counts.sh > spell_checked_with_freq.txt
echo "Done spellchecking"
perl parser.pl spell_checked_with_freq.txt > parsed.txt
cat header.txt parsed.txt > combined.txt
wget https://github.com/remi0s/aosp-dictionary-tools/raw/refs/heads/master/dicttool_aosp.jar
java -jar dicttool_aosp.jar makedict -s combined.txt -d main_sk.dict
