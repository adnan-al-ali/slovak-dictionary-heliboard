# Slovak Dictionary for HeliBoard

Slovak dictionary for spell checking in [HeliBoard](https://github.com/HeliBorg/HeliBoard) and other open-source Android on-screen keyboards.

## Use

To use this dictionary in HeliBoard, download [main_sk.dict](main_sk.dict) and in HeliBoard, go to `Dictionaries` > `Add dictionary from file` > `... select main_sk.dict`.

## Building

Requirements: [Hunspell](https://hunspell.github.io/), [Java](https://www.java.com/en/)

To build, run `main.sh`

## Acknowledgements

- This dictionary is based on the [frequency list](korpus.sk/frekvencne-zoznamy/) published by the Slovak National Corpus.
- To filter misspelt words, the [Slovak Hunspell dictionary](https://github.com/sk-spell/hunspell-sk) is used.
- Compiling the frequency lists is done using the [AOSP dictionary tools](https://github.com/remi0s/aosp-dictionary-tools/tree/master).
