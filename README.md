# Centralized Git Configuration

This guide will help you set up a centralized Git configuration system that allows you to use different configurations based on the repository you're working on. This is particularly useful if you're using the same machine for both personal and work projects and you want to use different user names and emails for each.

## Automated Setup
To facilitate the setup of your Git configurations, you can use an interactive script. This script will prompt you for your details, install Git if necessary, create your work and personal directories, and set up your configuration files accordingly.

### Running the Configuration Script

1. **Download the Script**: Obtain the script and save it as `setup-git-configs.sh` on your machine.

2. **Make the Script Executable**: You need to grant execution permissions to the script. Open your terminal and run:
    ```bash
    chmod +x setup-git-configs.sh
    ```
3. **Execute the Script**: Start the script by entering the following command in your terminal:
    ```bash
    ./setup-git-configs.sh
    ```
    Follow the on-screen prompts to enter your full name and email addresses for both personal and work settings.

4. Check the Results: After the script has finished, ensure that the directories `~/work/` and `~/personal/` have been created (if they didn't exist already) and that the `.gitconfig`, `.gitconfig-work`, and `.gitconfig-personal` files are in place with the information you provided.

5. Start using your configurations: With your new setup, Git will automatically use the correct user information based on the repository's location, allowing you to switch contexts effortlessly.

## Manual setup

### Step 1: Create Separate Config Files

First, create two separate config files: one for personal use, one for work. Let's say these are located at `~/.gitconfig-personal`, `~/.gitconfig-work`.

In each of these files, set the user name and email (and any other config settings you want to be different) like this:

```ini
[user]
    name = Your Name
    email = your.email@example.com
```

Replace `Your Name` and `your.email@example.com` with your actual name and email.

### Step 2: Set Up the Main Config File

In your main `~/.gitconfig` file, use the `includeIf` directive to include the appropriate config file based on the repository's path. For example:

```ini
[includeIf "gitdir:~/work/"]
    path = .gitconfig-work
[includeIf "gitdir:~/personal/"]
    path = .gitconfig-personal
```

Replace `~/work/` and `~/personal/` with the actual paths where your work and personal repositories are located.

You can also define the default settings directly in the `~/.gitconfig` file. Any settings defined in this file will be used as the default unless overridden by a more specific configuration file. Here's an example:

```ini
[user]
    name = Default Name
    email = default.email@example.com

[includeIf "gitdir:~/work/"]
    path = .gitconfig-work
[includeIf "gitdir:~/personal/"]
    path = .gitconfig-personal
```

In this example, `Default Name` and `default.email@example.com` will be used as the default user name and email.

## How It Works

When Git processes the configuration files, it applies them in a specific order. The settings in the `~/.gitconfig` file are applied first, and then any settings in the included files would override the previous settings if the conditions for the `includeIf` directive are met.

For example, if you have the following in your `~/.gitconfig`:

```ini
[user]
    name = Default Name
    email = default.email@example.com
```

And the following in your `~/.gitconfig-work`:

```ini
[user]
    name = Work Name
    email = work.email@example.com
```

When you're working in a repository that matches the `gitdir:~/work/` condition, the `user.name` and `user.email` will be set to `Work Name` and `work.email@example.com`, overriding the default settings.

## Example

You can find an example of a centralized Git configuration system in this repository. The `src` directory represents the `home` directory of your current user. 
It contains the separate config files for personal and work use, and the `.gitconfig` file includes them based on the repository path.