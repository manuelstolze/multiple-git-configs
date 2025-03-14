#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install git
install_git() {
  if command_exists git; then
    echo "Git is already installed."
  else
    echo "Installing Git..."
    if command_exists apt-get; then
      sudo apt-get update && sudo apt-get install -y git
    elif command_exists yum; then
      sudo yum install -y git
    elif command_exists brew; then
      brew install git
    else
      echo "Package manager not found. You must manually install Git."
      exit 1
    fi
  fi
}

# Function to create directories if they don't exist
create_dirs() {
  for dir in ~/techem ~/personal; do
    if [ ! -d "$dir" ]; then
      echo "Creating directory $dir..."
      mkdir -p "$dir"
    else
      echo "Directory $dir already exists, skipping creation."
    fi
  done
}

# Function to create .gitconfig files
create_gitconfigs() {
  echo "Creating .gitconfig files..."

  # Prompt for user information
  read -rp "Enter your full name: " full_name
  read -rp "Enter your Techem email address: " techem_email
  read -rp "Enter your personal email address: " personal_email

  # Create main .gitconfig
  cat > ~/.gitconfig << EOF
[user]
	name = $full_name
	# email = placeholder
[alias]
	lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

# Use context related config
[includeIf "gitdir:~/techem/"]
	path = .gitconfig-techem
[includeIf "gitdir:~/personal/"]
	path = .gitconfig-personal
EOF

  # Create .gitconfig-techem
  cat > ~/.gitconfig-techem << EOF
[user]
	name = $full_name
	email = $techem_email
[alias]
	lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
[core]
	autocrlf = input
[http]
	sslVerify = false
EOF

  # Create .gitconfig-personal
  cat > ~/.gitconfig-personal << EOF
[user]
	name = $full_name
	email = $personal_email
[alias]
	lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
[core]
	autocrlf = input
[http]
	sslVerify = true
EOF
}

# Main execution
install_git
create_dirs
create_gitconfigs

echo "Git installation and configuration complete."
