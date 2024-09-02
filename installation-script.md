# 📌 Using the Standalone Script
This script is a personal project created for fun. Its purpose is to simplify the installation of customization and its dependencies, such as `git`, `figlet`, and `nerd-fonts`. While it's currently a work in progress and not yet fully polished, I'd like to continue developing it to enhance my skills and improve its functionality.

## 🔹 How It Works
You can run this script by itself without any other file from this repository.
To use the script, follow these steps:

1. **Check for Existing Configurations**: Before running the script, verify that you will not lose any existing aliases or configurations in your `.bashrc` or `.bash_profile` files.

2. **Run the Script**: Log in to your system as your regular user and execute the script with sudo privileges. This is necessary to customize the root prompt , install dependencies (git, nerd-fonts and figlet) and configure the figlet warning.

3. **Follow Prompts**: The script will provide informative messages about the actions it is performing. It will also ask for your confirmation to customize the root prompt.

4. **Specify a User**: If you wish to customize a different user or reapply the customization, you can specify the username when prompted. 
    - If you respond with 'N' to the prompt asking "Customize prompt for user 'username'?", you will be prompted to enter a new username for customization.

5. **Figlet Warning**: The script will inquire whether you want to activate the figlet root warning and will configure it accordingly based on your response.
   
> [!NOTE]
> Please note that this script is still under development and may have some issues. Your feedback and suggestions are appreciated as I continue to refine it.
> 
![customize-bash](https://github.com/user-attachments/assets/adb36806-c3e7-46e6-8e14-c99df1aac07c)
