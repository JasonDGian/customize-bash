# 📌 Understanding the PS numbers and their meaning. 
In Linux there are several environment variables that define the appearance and behavior of the shell prompt in the terminal. These variables are called PS0, PS1, PS2, PS3 .. etc.
Each PS variable can be customized on its own and have them behave differently within their own context. In my case I have only customized PS1 and PS2 since those are the only two prompts I really see or care about. 

## 🔹 How to customize a PS variable.
Within your console profile file, assign a value to the variable you wish to customize.
**Example:**
```bash
# Displays 'username@hostname current-directory >>'
PS1='\u@\h \w >>'
```

**Here's what each one typically represents:**
<table>
    <thead>
        <tr>
            <th>Variable</th>
            <th>Description</th>
            <th>Usage Example</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>PS0</code></td>
            <td>Executed just before a command runs. Rarely used and does not display a prompt.</td>
            <td>Not commonly set. Used for debugging or logging.</td>
        </tr>
        <tr>
            <td><code>PS1</code></td>
            <td>The primary prompt string, displayed when the shell is ready for a new command. It’s the default prompt you see in the terminal.</td>
            <td><code>PS1='\u@\h:\w\$ '</code> (Displays username, hostname, and current directory)</td>
        </tr>
        <tr>
            <td><code>PS2</code></td>
            <td>The secondary prompt string, displayed when a command is incomplete and requires more input.</td>
            <td><code>PS2='> '</code> (Default continuation prompt)</td>
        </tr>
        <tr>
            <td><code>PS3</code></td>
            <td>The prompt used by the <code>select</code> command in shell scripts to prompt the user to choose an option from a list.</td>
            <td><code>PS3='Please choose an option: '</code> (Prompt for user selection)</td>
        </tr>
        <tr>
            <td><code>PS4</code></td>
            <td>The prompt prefix used when debugging shell scripts with <code>set -x</code>. It appears before each command in trace output.</td>
            <td><code>PS4='+ '</code> (Default prefix for debugging)</td>
        </tr>
    </tbody>
</table>
