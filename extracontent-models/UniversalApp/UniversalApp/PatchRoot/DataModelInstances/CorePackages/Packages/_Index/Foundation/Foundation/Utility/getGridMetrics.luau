local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(Foundation.Enums.Breakpoint)

local Dash = require(FoundationParent.Dash)

require(Foundation.Providers.Responsive.ResponsiveContext)
require(Foundation.Components.Types)

local function getColumnMetrics(p1, p2, p3) -- line: 29
	local v9 = p1.grid.columns[p2]

	if p3 then
		if type(p3) == "table" then
			p3 = p3[p1.breakpoint.shortNames[p2]] or v9
		end

		v9 = math.clamp(p3, 0, v9)
	end

	local v10 = math.max(0, v9 - 1)

	return {
		colCount = v9,
		gutterCount = v10
	}
end
local function getGridMetrics(p4, p5, n1: number, p6) -- line: 53
	-- upvalues: getColumnMetrics (copy), Dash (copy)
	local v15 = getColumnMetrics(p4, p5)
	local v16 = if not p6 then v15 else getColumnMetrics(p4, p5, p6)
	local grid = p4.grid
	local v18 = grid.gaps[p5]
	local v19 = grid.gutters[p5]
	local v20 = grid.margins[p5]
	local v21 = math.max(0, n1 - v20 * 2)
	local v22 = v15.gutterCount * v19
	local v23 = v16.gutterCount * v19
	local v24 = math.max(0, (v21 - v22) / v15.colCount)
	local v25 = not (v22 < v21) and 0 or math.floor(v24 * v16.colCount + v23)
	local uDim2 = UDim2.fromOffset(v25, 0)

	return Dash.assign({
		full = Dash.assign(v15, {
			margin = v20
		}),
		margin = v20,
		colWidth = v24,
		gapHeight = v18,
		gutterWidth = v19,
		gridWidth = v21,
		cellSize = uDim2,
		cellWidth = v25
	}, v16)
end

return getGridMetrics
