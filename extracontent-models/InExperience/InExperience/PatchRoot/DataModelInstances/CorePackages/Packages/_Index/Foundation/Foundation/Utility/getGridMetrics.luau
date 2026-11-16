local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(Foundation.Enums.Breakpoint)
local Dash = require(parent.Dash)
require(Foundation.Providers.Responsive.ResponsiveContext)
require(Foundation.Components.Types)

local function getColumnMetrics(p, p2, value)
	local column = p.grid.columns[p2]

	if value then
		if type(value) == "table" then
			value = value[p.breakpoint.shortNames[p2]] or column
		end

		column = math.clamp(value, 0, column)
	end

	return {
		colCount = column,
		gutterCount = math.max(0, column - 1)
	}
end

local function getGridMetrics(p, p2, p3: number, p4)
	local columnMetrics = getColumnMetrics(p, p2)
	local v

	if p4 then
		v = getColumnMetrics(p, p2, p4)
	else
		v = columnMetrics
	end

	local grid = p.grid
	local gap = grid.gaps[p2]
	local gutter = grid.gutters[p2]
	local margin = grid.margins[p2]

	local gridWidth = math.max(0, p3 - margin * 2)

	local v2 = columnMetrics.gutterCount * gutter
	local v3 = v.gutterCount * gutter
	local colWidth = math.max(0, (gridWidth - v2) / columnMetrics.colCount)

	local cellWidth = not (v2 < gridWidth) and 0 or math.floor(colWidth * v.colCount + v3)

	local udim = UDim2.fromOffset(cellWidth, 0)

	return Dash.assign({
		full = Dash.assign(columnMetrics, { margin = margin }),
		margin = margin,
		colWidth = colWidth,
		gapHeight = gap,
		gutterWidth = gutter,
		gridWidth = gridWidth,
		cellSize = udim,
		cellWidth = cellWidth
	}, v)
end

return getGridMetrics
