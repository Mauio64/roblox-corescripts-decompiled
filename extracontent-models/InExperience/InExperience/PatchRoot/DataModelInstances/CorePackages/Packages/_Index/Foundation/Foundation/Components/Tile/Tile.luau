local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local TileContext = require(script.Parent.TileContext)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Enums.FillBehavior)

local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local t1 = {
	isContained = false,
	testId = "--foundation-tile",
	FillDirection = Enum.FillDirection.Vertical
}

local function Tile(p1, p2) -- line: 36
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), View (copy), withCommonProps (copy), StateLayerAffordance (copy), TileContext (copy)
	local v13 = withDefaults(p1, t1)

	return React.createElement(View, withCommonProps(v13, {
		tag = {
			["bg-shift-200"] = v13.isContained,
			["gap-small"] = not v13.isContained,
			["radius-medium"] = true
		},
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		onStateChanged = v13.onStateChanged,
		layout = {
			FillDirection = v13.FillDirection,
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		Size = v13.Size,
		ref = p2
	}), {
		TileContext = if not v13.children then nil else React.createElement(TileContext.Provider, {
			value = {
				isContained = v13.isContained,
				fillDirection = v13.FillDirection,
				testId = v13.testId
			}
		}, v13.children)
	})
end

return React.forwardRef(Tile)
