local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Logger = require(Foundation.Utility.Logger)
local React = require(FoundationParent.React)

require(Foundation.Utility.Plugin.StudioUri)
require(Foundation.Components.Types)

return React.createContext({
	anchor = nil,
	anchorUri = nil,
	isOpen = false,
	testId = "",
	setAnchor = function(_) -- line: 13
		-- upvalues: Logger (copy)
		Logger:warning("No PopoverProvider found for Popover")
	end,
	setAnchorUri = function(_) -- line: 17
		-- upvalues: Logger (copy)
		Logger:warning("No PopoverProvider found for Popover")
	end
})
