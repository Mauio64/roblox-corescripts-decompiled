local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local withDefaults = require(Foundation.Utility.withDefaults)
local PopoverContext = require(script.Parent.PopoverContext)

require(Foundation.Utility.Plugin.StudioUri)
require(Foundation.Components.Types)

local t1 = {
	testId = "--foundation-popover"
}

local function Popover(t2: {[any]: any}) -- line: 25
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), PopoverContext (copy)
	local v9 = withDefaults(t2, t1)
	local v10, v11 = React.useState(nil)
	local v12, v13 = React.useState(nil)

	return React.createElement(PopoverContext.Provider, {
		value = {
			anchor = v10,
			setAnchor = v11,
			anchorUri = v12,
			setAnchorUri = v13,
			isOpen = v9.isOpen,
			testId = v9.testId
		}
	}, v9.children)
end

return Popover
