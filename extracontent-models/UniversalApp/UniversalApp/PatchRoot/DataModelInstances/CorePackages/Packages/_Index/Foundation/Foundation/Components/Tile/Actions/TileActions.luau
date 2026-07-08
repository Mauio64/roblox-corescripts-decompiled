local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local useTile = require(Foundation.Components.Tile.useTile)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)

local function TileActions(t1: {[any]: any}) -- line: 17
	-- upvalues: useTile (copy), React (copy), View (copy)
	local v8 = useTile()

	return React.createElement(View, {
		LayoutOrder = 3,
		tag = "shrink size-full-0 auto-y",
		Visible = t1.Visible,
		testId = `{ v8.testId }--actions`
	}, t1.children)
end

return TileActions
