local Popover = require(script.Popover)
local Anchor = require(script.Anchor)

require(script.Content)

return {
	Root = Popover,
	Anchor = Anchor,
	Content = require(script.PopoverContentProxy)
}
