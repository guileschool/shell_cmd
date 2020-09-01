#!/usr/bin/env bash
# makeTagDirectory.sh tech.txt

IFS=$',' read -r -a array < $1
for element in "${array[@]}"
do
    echo "---" > "$element.md"
    echo "name: $element" >> "$element.md"
    echo "title: '$element'" >> "$element.md"
    echo "---" >> "$element.md"
done

