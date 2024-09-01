# 📌 Ansi colors and formatting.
By using ANSI color escape codes, you can add color to the output strings in your terminal. The ANSI standard specifies a range of color codes that allow you to customize the appearance of text. 

**How do Ansi colors work?**   
ANSI colors are implemented using escape sequences, which are special sequences of characters that begin with the escape character (ASCII 27) followed by a series of codes. The general format for an ANSI escape sequence is:
```bash
<escape character>[<formatting_codes>;<text_color_code>;<background_color_code>;<additional_codes>m
```
**Example**
```bash
\e[00;00;00;00m
```

**Reset text format**   
When an ansi color is applied, it stays on until it meets the reset character or another ansi color configuration.   
To reset a string output to 'normal' use `\e[00m`  

**Example**
```bash
echo -e "\e[31mThis is red text \e[36m this is dark cyan \e[0m and from this point onwards standard format."
```


**Here’s a brief overview of how these codes work:**   

<table>
    <tr>
        <th>Color</th>
        <th>Foreground</th>
        <th>Background</th>
    </tr>
    <tr>
        <td>Black</td>
        <td>30</td>
        <td>40</td>
    </tr>
        <tr>
        <td>Red</td>
        <td>31</td>
        <td>41</td>
    </tr>
        <tr>
        <td>Green</td>
        <td>32</td>
        <td>42</td>
    </tr>
        <tr>
        <td>Yellow</td>
        <td>33</td>
        <td>43</td>
    </tr>
        <tr>
        <td>Dark Blue</td>
        <td>34</td>
        <td>44</td>
    </tr>
        <tr>
        <td>Dark Magenta</td>
        <td>35</td>
        <td>45</td>
    </tr>
        <tr>
        <td>Dark Cyan</td>
        <td>36</td>
        <td>46</td>
    </tr>
        <tr>
        <td>Dark White</td>
        <td>37</td>
        <td>47</td>
    </tr>
        <tr>
        <td>Bright Black</td>
        <td>90</td>
        <td>100</td>
    </tr>
        <tr>
        <td>Bright Red</td>
        <td>91</td>
        <td>101</td>
    </tr>
        <tr>
        <td>Bright Green</td>
        <td>92</td>
        <td>102</td>
    </tr>
    <tr>
        <td>Bright Yellow</td>
        <td>93</td>
        <td>103</td>
    </tr>
    <tr>
        <td>Bright Blue</td>
        <td>94</td>
        <td>104</td>
    </tr>
    <tr>
        <td>Bright Magenta</td>
        <td>95</td>
        <td>105</td>
    </tr>
    <tr>
        <td>Bright Cyan</td>
        <td>96</td>
        <td>106</td>
    </tr>
    <tr>
        <td>White</td>
        <td>97</td>
        <td>107</td>
    </tr>
</table>

<table>
    <tr>
        <th>Effect</th>
        <th>Code</th>
    </tr>
    <tr>
        <td>Bold</td>
        <td>1</td>
    </tr>
    <tr>
        <td>Dim text</td>
        <td>2</td>
    </tr>
    <tr>
        <td>Italic</td>
        <td>3</td>
    </tr>
    <tr>
        <td>Underline</td>
        <td>4</td>
    </tr>
    <tr>
        <td>Blinking</td>
        <td>5</td>
    </tr>
    <tr>
        <td>Blinking 2</td>
        <td>6</td>
    </tr>
    <tr>
        <td>Reversed colors</td>
        <td>7</td>
    </tr>
    <tr>
        <td>Invisible text</td>
        <td>8</td>
    </tr>
    <tr>
        <td>Striked</td>
        <td>9</td>
    </tr>
</table>


## 🔹 Adding ansi to your prompt.
To add ANSI colors to your prompt, there are a few important details to consider:
- **Wrapping ANSI Codes:** When incorporating ANSI codes directly into your prompt, make sure to prefix them with `\[` and suffix them with `\]`. This practice ensures that the text width calculations are accurate and prevents the terminal from misinterpreting the formatting codes. I am not entirely sure why this is required but is the only consistent method I've found so far.

- **Using Functions:** Alternatively, you can create functions to handle formatting and colors. This approach allows you to avoid repetitive code and simplifies the management of your prompt's appearance. I prefer this method because makes the prompt configuration easier to read and much more manageable in case of future changes.
