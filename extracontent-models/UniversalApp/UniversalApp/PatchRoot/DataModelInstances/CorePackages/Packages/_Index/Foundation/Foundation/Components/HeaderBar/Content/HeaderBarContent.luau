local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local HeaderBarContext = require(Foundation.Components.HeaderBar.HeaderBarContext)
local HeaderBarSlot = require(Foundation.Enums.HeaderBarSlot)
local View = require(Foundation.Components.View)
local constants = require(Foundation.Components.HeaderBar.constants)
local useHeaderBarContext = require(Foundation.Components.HeaderBar.useHeaderBarContext)

local function HeaderBarContent(p)
	local v = useHeaderBarContext()

	return React.createElement(
		HeaderBarContext.Provider,
		{ testId = v.testId, slot = HeaderBarSlot.Content },
		React.createElement(
			View,
			{
				tag = "align-y-center grow size-0-full auto-x",
				LayoutOrder = constants.CONTENT_LAYOUT_ORDER,
				testId = `{v.testId}--content`
			},
			p.children
		)
	)
end

return HeaderBarContent
