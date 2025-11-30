#!/bin/zsh

function ppath() {
	echo "$PATH" | sed 's/:/\n/g'
}

function hascmd() {
	hash $1 2>/dev/null
}

function catbin() {
	local cat_cmd bin_path bin_type

	if [[ "$#" != 1 ]]; then
		echo 'usage: catbin some_command' >&2
		return 1
	fi

	if hascmd bat; then
		cat_cmd=bat
	else
		cat_cmd=cat
	fi

	bin_path="$(command -v $1)"

	if [[ ! "$bin_path" =~ '^/' ]]; then
		which $1 | "$cat_cmd"
	else
		bin_path="$(readlink -f "$bin_path")"
		bin_type=$(file -b --mime-type "$bin_path" | sed 's|/.*||')
		[[ "$bin_type" == 'text' ]] && "$cat_cmd" "$bin_path" || file "$bin_path"
	fi
}
