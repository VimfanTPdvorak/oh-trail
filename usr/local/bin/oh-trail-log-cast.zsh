#!/usr/bin/zsh
#
# Accept no option or -f followed by a file

# Check if the -f option is provided
if [[ $1 == "-f" ]]; then
    # Check if a filename is provided after the -f option
    if [[ -n "$2" ]] && [[ -f "$2" ]]; then
        # Perform operations on the file
        cat "$2" >> /var/log/cast.log
    else
        # If no filename is provided, display an error message
        echo "Error: No filename provided after -f option or provided file is not found."
    fi
else
    # If -f option is not provided, treat the argument as a string
    echo "$1" >> /var/log/cast.log
fi
