#! /bin/bash

languages=`echo "go lua python terraform" | tr ' ' '\n'`
core_utils=`echo "xargs find mv sed awk grep" | tr ' ' '\n'`

selected=`printf "$languages\n$core_utils" | fzf`
read -p "query: " query

if printf $languages | grep -qs $selected; then
    # tmux neww bash -c "curl cht.sh/$selected`echo $query | tr ' ' '+'` & while [ : ]; do sleep 1; done"
    query = `echo $query | tr ' ' '+'`
    # tmux neww bash -c "curl cht.sh/$selected/$query/ & while [ : ]; do sleep 1; done"
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query/ & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl cht.sh/$selected~$query & while [ : ]; do sleep 1; done"
    # rg --files-with-matches --no-messages $query | fzf | xargs -r $selected
f
