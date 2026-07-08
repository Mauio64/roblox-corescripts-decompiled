local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(FoundationParent.BuilderIcons)

local React = require(FoundationParent.React)
local HeaderBarSlot = require(Foundation.Enums.HeaderBarSlot)
local IconButton = require(Foundation.Components.IconButton)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local constants = require(Foundation.Components.HeaderBar.constants)
local useHeaderBarContext = require(Foundation.Components.HeaderBar.useHeaderBarContext)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function HeaderBarActions(t1: {[any]: any}) -- line: 28
	-- upvalues: useHeaderBarContext (copy), useTokens (copy), React (copy), HeaderBarSlot (copy), constants (copy), IconButton (copy), View (copy)
	local v12 = useHeaderBarContext()
	local v13 = useTokens()
	local v14, v15 = React.useMemo(function() -- line: 32
		-- upvalues: v12 (copy), HeaderBarSlot (copy), constants (copy), v13 (copy)
		if v12.slot == HeaderBarSlot.Leading then
			return constants.LEADING_ACTIONS_LAYOUT_ORDER, {
				left = UDim.new(0, -v13.Size.Size_200)
			}
		end

		if v12.slot == HeaderBarSlot.Trailing then
			return constants.TRAILING_ACTIONS_LAYOUT_ORDER, {
				right = UDim.new(0, -v13.Size.Size_200)
			}
		end

		return nil, nil
	end, {
		v12.slot,
		v13.Size.Size_200
	})
	local t2 = {}

	for v17, v18 in t1.actions do
		t2[tostring(v18.id)] = React.createElement(IconButton, {
			icon = v18.icon,
			onActivated = v18.onActivated,
			LayoutOrder = v17,
			testId = `{ v12.testId }--actions--{ v18.id }`
		})
	end

	return React.createElement(View, {
		tag = "row align-y-center shrink gap-small auto-xy",
		padding = v15,
		LayoutOrder = v14,
		testId = `{ v12.testId }--actions`
	}, t2)
end

return React.memo(HeaderBarActions)
