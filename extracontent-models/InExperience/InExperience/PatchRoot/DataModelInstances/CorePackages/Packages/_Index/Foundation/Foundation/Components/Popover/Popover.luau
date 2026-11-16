local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local withDefaults = require(Foundation.Utility.withDefaults)

local PopoverContext = require(script.Parent.PopoverContext)

require(Foundation.Utility.Plugin.StudioUri)
require(Foundation.Components.Types)

local v = { testId = "--foundation-popover" }

local function Popover(p)
	local v2 = withDefaults(p, v)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)

	local v3 = React.useMemo(function()
		return {
			anchor = state,
			setAnchor = setState,
			anchorUri = state2,
			setAnchorUri = setState2,
			isOpen = v2.isOpen,
			testId = v2.testId
		}
	end, { state, state2, v2.isOpen, v2.testId })

	return React.createElement(PopoverContext.Provider, { value = v3 }, v2.children)
end

return Popover
