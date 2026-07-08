local Foundation = script:FindFirstAncestor("Foundation")
local Flags = require(Foundation.Utility.Flags)
local Popover = require(script.Popover)
local Anchor = require(script.Anchor)
local Content = require(script.Content)

return {
	Root = Popover,
	Anchor = Anchor,
	Content = if not Flags.FoundationPopoverPluginSupport then Content else require(script.PopoverContentProxy)
}
