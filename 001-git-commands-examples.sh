#Markdown syntax
#--- begin
- Using italics in text is as easy as surrounding the target text with single asterisks (*) or single underscores (_).
- Create bold text by using two asterisks (**) or two underscores (__).
- HTML provides content headings such as the <h1> tag. In Markdown, this is supported via the # symbol. Just use one # for each heading level from 1 to 6.
- Image and site links use a similar syntax. ![Link an image.](/learn/azure-devops/shared/media/mara.png)
- You can define ordered or unordered lists. You can also define nested items through indentation.

Here's the Markdown for an ordered list:

markdown
1. First
1. Second
1. Third

Result:
	1.First
	2.Second
	3.Third

Here's the Markdown for an unordered list:

markdown
- First
  - Nested
- Second
- Third

Result:
	* First
		* Nested
	* Second
	* Third

- You can construct tables using a combination of pipes (|) for column breaks and dashes (-) to designate the prior row as a header.

First|Second
-|-
1|2
3|4

- You can create blockquotes using the greater than (>) character.
markdown
> This is quoted text.

- Markdown provides default behavior for working with inline code blocks delimited by the backtick (`) character. When decorating text with this character, it's rendered as code.
markdown
This is `code`.


- If you have a code segment spanning multiple lines, you can use three backticks (```) before and after to create a fenced code block.

```markdown
var first = 1;
var second = 2;
var sum = first + second;
```

- You can create task lists within issues or pull requests using the following syntax. These can be helpful to track progress when used in the body of an issue or pull request.

markdown
- [x] First task
- [x] Second task
- [ ] Third task

- Slash commands can save you time by reducing the typing required to create complex Markdown.
You can use slash commands in any description or comment field in issues, pull requests, or discussions where that slash command is supported.

Command	Description
/code	Inserts a Markdown code block. You choose the language.
/details	Inserts a collapsible detail area. You choose the title and content.
/saved-replies	Inserts a saved reply. You choose from the saved replies for your user account. If you add %cursor% to your saved reply, the slash command places the cursor in that location.
/table	Inserts a Markdown table. You choose the number of columns and rows.
/tasklist	Inserts a tasklist. This slash command only works in an issue description.
/template	Shows all of the templates in the repository. You choose the template to insert. This slash command works for issue templates and a pull request template.

#Markdown syntax
#--- end


#My Dev Setup

#Custom Git Bash Profile
#--- begin

# Function to Parse the Current Git Branch with Error Handling
parse_git_branch() {
    # Check if the current directory is a Git repository
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        # If it is, return the current branch
        git rev-parse --abbrev-ref HEAD
    else
        # If it isn't, return an error message
        echo "Not a Git Repository"
    fi
}

# Function to issue signed Git Commit
gm() {
	set -x # Start debugging and output commands
    git commit -S -m "$1"
	set +x # Stop debugging
}

# Function to issue Git Status
gs() {
    git status
}


PS1='
\[\e[0;33m\] < Date: \[\e[0;32m\]\d \[\e[0;33m\] | Time: \[\e[0;32m\]\t Central Time \[\e[0;33m\] | Working Repo: \[\e[0;36m\]\w \[\e[0;33m\] | Working Branch: \[\e[0;36m\] $(parse_git_branch) \[\e[0;33m\] | Command Number: \[\e[0;32m\] All Sessions \! , This Session \# \[\e[0;33m\] >
\[\e[0m\]\$ '

cd /c/Temp/MyGitRepositories/Alex-Rosa

#Custom Git Bash Profile
#--- end

