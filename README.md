<!-- Uses markdown syntax for neat display at github -->

# Superscripts
A bunch of scripts for all kind of purposes... :-)

## Thing I like

These are just .sh or .bash scripts, but also such scripts have many little tricks you only learn over times.

To require an argument for a script:

    file=${1:? "$0 requires \"file\" as first argument"}
    
Lowercase:

    var_lc=$(echo $var | tr "[:upper:]" "[:lower:]")

Remove temporary file or directory, even if script fails:

    tmpdir=$(mktemp -d -t prefixXXXXX)
    trap 'rm -rf "$tmpdir"' EXIT

Create array from variable `array_txt`:

    IFS=$'\n' read -d '' -r -a array <<< "$array_txt"

And of course its length:

    array_length=${#array[@]}

Disable globbing:

    shopt -s nullglob

Remove comma from last line in file:

    sed -i -e '$s|,||' "$file"

Split a file based on context lines (for example a json array):

    csplit -s -n6 -f "$file" '/metadata/-1' '{*}'

## Copyrights
The copyrights (2014) belong to:

- Author: Anne van Rossum
- Almende B.V., http://www.almende.com and DoBots B.V., http://www.dobots.nl
- Rotterdam, The Netherlands
