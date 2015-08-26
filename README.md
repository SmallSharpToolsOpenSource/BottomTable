# Bottom Table

When the contents of a table view should settle on the bottom it is necessary to push
the content down by setting the top content inset which uses the height of the table
view and the height of the content.

Older solutions would add up the height of each cell using one of the delegate methods
which can cause a lot of extra processing. And now with autolayout and automatically
sizing cells that option is no longer an option.

Instead this sample project gets the frame for the last row which makes calculating
the top inset possible. It leverages what the table view is already doing to calculate
the height of the content so calling the method to get the frame of the last cell
is all that is needed.

## License

MIT

---
 
Brennan Stehling - 2015 
http://www.smallsharptools.com/

Please excuse the Objective-C. If you'd like to convert it to Swift a PR is welcome.
