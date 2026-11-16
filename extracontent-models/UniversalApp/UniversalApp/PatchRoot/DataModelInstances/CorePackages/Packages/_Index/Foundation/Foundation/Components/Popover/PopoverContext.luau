local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Logger = require(Foundation.Utility.Logger)
local React = require(parent.React)
require(Foundation.Utility.Plugin.StudioUri)
require(Foundation.Components.Types)

return React.createContext({
	anchor = nil,
	setAnchor = function(_)
		Logger:warning("No PopoverProvider found for Popover")
	end,
	anchorUri = nil,
	setAnchorUri = function(_)
		Logger:warning("No PopoverProvider found for Popover")
	end,
	isOpen = false,
	testId = ""
})
