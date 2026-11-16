local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local HeaderBarContext = require(Foundation.Components.HeaderBar.HeaderBarContext)
local HeaderBarSlot = require(Foundation.Enums.HeaderBarSlot)
local View = require(Foundation.Components.View)
local constants = require(Foundation.Components.HeaderBar.constants)
local useHeaderBarContext = require(Foundation.Components.HeaderBar.useHeaderBarContext)

local function HeaderBarLeading(p)
	local v = useHeaderBarContext()

	return React.createElement(
		HeaderBarContext.Provider,
		{ testId = v.testId, slot = HeaderBarSlot.Leading },
		React.createElement(
			View,
			{
				tag = "row align-y-center shrink gap-small size-full",
				LayoutOrder = constants.LEADING_LAYOUT_ORDER,
				testId = `{v.testId}--leading`
			},
			p.children
		)
	)
end

return HeaderBarLeading
