local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local View = require(Foundation.Components.View)
local useTile = require(Foundation.Components.Tile.useTile)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	LayoutOrder = 2
}

local function TileContent(t2: {[any]: any}) -- line: 20
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useTile (copy), React (copy), View (copy)
	local v11 = withDefaults(t2, t1)
	local v12 = useTokens()
	local v13 = useTile()

	return React.createElement(View, {
		tag = "col align-y-top gap-small size-full",
		flexItem = {
			FlexMode = Enum.UIFlexMode.Shrink
		},
		padding = if not v13.isContained then nil else v12.Padding.Small,
		LayoutOrder = v11.LayoutOrder,
		testId = `{ v13.testId }--content`
	}, v11.children)
end

return TileContent
