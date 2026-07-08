local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local HeaderBarContext = require(Foundation.Components.HeaderBar.HeaderBarContext)
local HeaderBarSlot = require(Foundation.Enums.HeaderBarSlot)
local View = require(Foundation.Components.View)
local constants = require(Foundation.Components.HeaderBar.constants)
local useHeaderBarContext = require(Foundation.Components.HeaderBar.useHeaderBarContext)

local function HeaderBarTrailing(t1: {[any]: any}) -- line: 16
	-- upvalues: useHeaderBarContext (copy), React (copy), HeaderBarContext (copy), HeaderBarSlot (copy), View (copy), constants (copy)
	local v11 = useHeaderBarContext()

	return React.createElement(HeaderBarContext.Provider, {
		testId = v11.testId,
		slot = HeaderBarSlot.Trailing
	}, React.createElement(View, {
		tag = "row align-x-right align-y-center shrink gap-small size-full",
		LayoutOrder = constants.TRAILING_LAYOUT_ORDER,
		testId = `{ v11.testId }--trailing`
	}, t1.children))
end

return HeaderBarTrailing
