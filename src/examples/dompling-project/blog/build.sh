dir=$1
final=""
newline=$'\n'
for file in ${@:3}; do
	final="$final$newline$(cat "$dir/$file")"
done

echo "$final" > "$dir/$2"

gsi ./rsc.scm -t js -l max -l dompling -l ribjs/core -l ribjs/reactive -l ribjs/render "$dir/$2"
