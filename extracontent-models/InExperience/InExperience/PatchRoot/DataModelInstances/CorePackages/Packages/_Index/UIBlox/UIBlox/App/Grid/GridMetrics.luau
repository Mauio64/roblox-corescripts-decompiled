local parent = script.Parent.Parent.Parent.Parent
local t = require(parent.t)

local function getItemMetrics(p, p2, p3) -- 1 equivalent call inferred from this helper
	local v = math.floor((p + p2) / (p3.minimumItemWidth + p2))
	local itemsPerRow = math.max(p3.minimumItemsPerRow, v)
	return {
		itemsPerRow = itemsPerRow,
		itemWidth = math.floor((p - (itemsPerRow - 1) * p2) / itemsPerRow)
	}
end

local GridMetrics = {}

local strictInterface = t.strictInterface({
	minimumItemsPerRow = t.intersection(t.integer, t.numberMin(1)),
	minimumItemWidth = t.numberMin(0)
})

local tuple = t.tuple(t.numberMin(0), t.number)

function GridMetrics.makeCustomMetricsGetter(p)
	assert(strictInterface(p))

	return function(p2, p3)
		assert(tuple(p2, p3))
		return getItemMetrics(p2, p3, p) -- inferred equivalent call
	end
end

GridMetrics.getLargeMetrics = GridMetrics.makeCustomMetricsGetter({
	minimumItemsPerRow = 1,
	minimumItemWidth = 332
})
GridMetrics.getMediumMetrics = GridMetrics.makeCustomMetricsGetter({
	minimumItemsPerRow = 2,
	minimumItemWidth = 160
})

function GridMetrics.getSmallMetrics(p, p2)
	local itemsPerRow = GridMetrics.getMediumMetrics(p, p2).itemsPerRow + 1
	return {
		itemsPerRow = itemsPerRow,
		itemWidth = math.floor((p - (itemsPerRow - 1) * p2) / itemsPerRow)
	}
end

function GridMetrics.getMetricsForFixedColumns(p, p2, itemsPerRow)
	return {
		itemsPerRow = itemsPerRow,
		itemWidth = math.floor((p - (itemsPerRow - 1) * p2) / itemsPerRow)
	}
end

return GridMetrics
