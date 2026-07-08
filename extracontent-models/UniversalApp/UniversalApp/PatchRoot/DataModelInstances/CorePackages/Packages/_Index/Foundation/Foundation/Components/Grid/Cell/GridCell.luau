local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local getGridSizeTag = require(Foundation.Utility.getGridSizeTag)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	size = 1,
	testId = "--foundation-grid--cell"
}

local function GridCell(p1, p2) -- line: 26
	-- upvalues: withDefaults (copy), t1 (copy), Dash (copy), React (copy), getGridSizeTag (copy), View (copy)
	local v12 = withDefaults(p1, t1)
	local v13 = Dash.omit(v12, { "size" })
	local v14 = React.useMemo(function() -- line: 30
		-- upvalues: getGridSizeTag (copy), v12 (copy)
		return getGridSizeTag(v12.size)
	end, { v12.size })

	return React.createElement(View, Dash.assign(v13, {
		tag = table.concat({
			v14,
			v12.tag
		}, " "),
		ref = p2
	}), v12.children)
end

return React.memo(React.forwardRef(GridCell))
