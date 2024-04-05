
# Define a function to execute SSH and run the command "ls" in a new tmux pane
execute_ssh_in_tmux() {
    local username=$1
    local ip_address=$2
    local password=$3
    local split=$4

    # Create a new pane in the existing tmux session and execute SSH command
    if [ "$split" = true ]; then
        tmux split-window -v
    fi

    tmux send-keys "sshpass -p '$password' ssh '$username'@'$ip_address' -t 'btop" Enter
}

# Main function to prompt user for username, IP address, and password
main() {
    # Create a new tmux session named "ssh_session" if not exists
    tmux has-session -t ssh_session 2>/dev/null || tmux new-session -d -s ssh_session

    local did_first=false

    while true; do
        username=$(gum input --prompt "Enter username>" --placeholder "")
        ip=$(gum input --prompt "Enter IP>" --placeholder "")
        pass=$(gum input --password --prompt "Password>" --placeholder "")

        # Execute SSH command in a new pane in the tmux session
        execute_ssh_in_tmux "$username" "$ip" "$pass" $did_first

        did_first=true

        read -p "Do you want to continue (yes/no)? " choice
        case "$choice" in
            [Nn]* ) break;;
            * ) continue;;
        esac
    done

    # Attach to the tmux session to view the panes
    tmux attach -t ssh_session
}

echo "So you want to big flex all your servers....."
echo "Make sure all servers have btop installed :D"

# Call the main function
main
