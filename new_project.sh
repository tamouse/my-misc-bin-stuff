#!/bin/sh

set -e

git init "$1"
pushd "$1"
echo "$2" > .git/description

cat <<EOF > package.json
{
  "name": "$1",
  "description": "$2",
  "private": true
}
EOF

cat <<EOF > README.md
# $1

> $2

## Installation

...

## Usage

...

## Development

...

## License

See [LICENSE](./LICENSE)

## Contributing

See [CONTRIBUTING](./CONTRIBUTING.md)

## Colophon

Another tamouse project!
EOF

cat <<EOF > .gitignore
.DS_Store
.CFUserTextEncoding
.localized
/node_modules/
EOF

[ -x `which lice` ] && lice mit > LICENSE

curl -so CONTRIBUTING.md 'https://www.contributor-covenant.org/version/2/0/code_of_conduct.md'

cat <<EOF > .editorconfig
# EditorConfig is awesome: http://EditorConfig.org
# top-most EditorConfig file
root = true

# Unix-style newlines with a newline ending every file
[*]
end_of_line = lf
insert_final_newline = true
charset = utf-8
indent_style = space
indent_size = 2
trim_trailing_whitespace = true

[*.md, *.markdown, *.mdx]
trim_trailing_whitespace = false

# Tab indentation (no size specified)
[Makefile]
indent_style = tab
tab_width = 8
EOF

hub create -d "$2"
yarn init

git add --all --verbose
git commit -m 'new project initial commit'
git push -u origin master

echo "Done!"
