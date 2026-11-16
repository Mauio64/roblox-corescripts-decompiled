local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local getGridSizeTag = require(Foundation.Utility.getGridSizeTag)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { size = 1, testId = "--foundation-grid--cell" }

local function GridCell(p, ref)
	local v2 = withDefaults(p, v)
	local omit = Dash.omit(v2, { "size" })

	local v3 = React.useMemo(function()
		return getGridSizeTag(v2.size)
	end, { v2.size })

	return React.createElement(View, Dash.assign(omit, {
		tag = table.concat({ v3, v2.tag }, " "),
		ref = ref
	}), v2.children)
end

return React.memo(React.forwardRef(GridCell))
