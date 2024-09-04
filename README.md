>[!warning] 
>This guide is primarily designed for Arch Linux. While it should be compatible with most Linux distributions, certain details might vary depending on your specific system. I have only tested this with Arch Linux, Ubuntu, and Lubuntu.

>[!Note]
> I've included a standalone installation script. Simply run the script and follow the indications. More info [here](https://github.com/JasonDGian/customize-bash/blob/main/installation-script.md)

# 📌 Welcome to my bash customization repository.
Here, you'll find basic bash customization techniques, configuration files, and tips to enhance both your user and root bash prompts.
If you aim to transform your bash prompt into something like the images below, simply follow the instructions provided here.

**📍 What will you achieve with these changes?**   
This repo is rooted in my personal journey to explore bash customization—mainly for fun. However, the techniques here will help you achieve a clear visual distinction between your user and root prompts.

### Key Features:

- **Contrasting Colors:** The guide uses cyan for the user prompt and red for the root prompt, ensuring you always know which environment you're working in.
- **Custom Root Login Indicator:** A blinking Figlet banner is displayed upon logging in as root from another user. While this feature may seem whimsical (and possibly annoying to some), it’s optional—just comment out or remove the `iamroot` function call in the `/root/.bashrc` file if you prefer not to use it.

Below are examples of the current configurations in action:
### ▫️ User prompt.
![imagen](https://github.com/user-attachments/assets/ae08ad23-f8aa-4963-823f-804a617fe5c3)

### ▫️ Logged into root and warning figlet.
When logging into root from another user a warning figlet will appear making it rather clear that you are entering a dangerous mode. 
   
![caution](https://github.com/user-attachments/assets/320ad574-7dba-456b-8123-4135b8030b14)

**Note:** Within the prompt the word `root` will keep blinking. 

![blink](https://github.com/user-attachments/assets/e24a3d2c-5a81-4227-ada2-2b48e0b770f1)


## 🔹 Requirements.
To achieve the final result, all you need to do is install `nerd-fonts`, `figlet` and `git`.
- **Why nerd-fonts?**   
Because the arrow symbol and the github icons for local and remote repositories are contained in the font pack (       ).

- **Why figlet?**    
Figlet is not really necessary but if you want the `iamroot` function to work you will need it.
      
- **Why git?**   
The repository location grab functions rely on Git to operate. Without Git installed, you might encounter some unexpected errors. Although you can manually remove the Git-related calls, I haven't tested this since I always have Git installed for work purposes.

You can easily install them with the following commands:
```bash
sudo pacman -S figlet
sudo pacman -S nerd-fonts
sudo pacman -S git
```

## 🔹 Customize Root prompt
Unless you've customized your root prompt before, it's likely that no console profile files exist for the root user. To set these up, you can copy the skeleton files from `/etc/skel/` and paste them into `/root/`.
You can simply use this command:
```bash
sudo cp /etc/skel/.bash_profile /root
sudo cp /etc/skel/.bashrc /root
```
>[!warning]
>If you've set any aliases for your root prompt, a .bashrc file may already exist. Overwriting this file will erase any previously configured aliases. Be sure to review the file before proceeding to avoid losing your custom settings.

Now that the root user has a console profile set up, you can proceed with customization.   
To achieve the desired look, copy the content of the file named `root.bashrc` into the `/root/.bashrc` file in your system.

## 🔹 Customize User prompt.
Your user console files should already exist in the `/home/<username>` directory. As with the root prompt, **if you've configured any aliases, completely overwriting the .bashrc file could disrupt your setup.** Be sure to review the file before making changes.   
To customize your user prompt, simply copy the contents of the file named `user.bashrc` into the `/home/<username>/.bashrc` file on your system.   

To confirm the success of the operation open a **new** terminal and check your prompt then log into root to see if everything works. 


