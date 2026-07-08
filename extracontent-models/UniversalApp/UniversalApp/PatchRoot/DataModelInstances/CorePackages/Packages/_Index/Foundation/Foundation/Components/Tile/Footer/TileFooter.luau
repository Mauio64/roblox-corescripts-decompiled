local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local View = require(Foundation.Components.View)
local useTile = require(Foundation.Components.Tile.useTile)

local function TileFooter(t1: {[any]: any}) -- line: 14
	-- upvalues: useTile (copy), React (copy), View (copy)
	local v8 = useTile()

	return React.createElement(View, {
		LayoutOrder = 2,
		tag = "shrink size-full-0 auto-y",
		testId = `{ v8.testId }--footer`
	}, t1.children)
end

return TileFooter
