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
