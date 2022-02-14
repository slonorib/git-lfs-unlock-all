#!/usr/bin/env bash
# func to get current git user name 
parse_git_user() {
    git config --get user.name
}

username=$(parse_git_user)
printf "Find assets locked by %s and unlock them if there are no changes\n" "${username}"

# create tmp file with list of locks
git lfs locks | grep "$username" | cut -f1 > locks.txt

while read p; do
	if [[ ! -z "${p}" ]]
	then
		printf "\nUnlocking %s...\n" "${p}"
		git lfs unlock "${p}"
	fi
done <locks.txt
rm ./locks.txt

# remove this block if you don't want to get git lfs locks result in the end
printf "\nDone! That's how lfs locks look now:\n"
printf "%0.s-" {1..20}
printf "\n"
git lfs locks
