local ParentParent = script.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)
local t1 = {
	minimumItemsPerRow = 2,
	minimumItemWidth = 160
}
local t2 = {
	minimumItemsPerRow = 1,
	minimumItemWidth = 332
}

local function getItemMetrics(p1, p2, p3) -- line: 24
	local v12 = math.floor((p1 + p2) / (p3.minimumItemWidth + p2))
	local v13 = math.max(p3.minimumItemsPerRow, v12)
	local v14 = math.floor((p1 - (v13 - 1) * p2) / v13)

	return {
		itemsPerRow = v13,
		itemWidth = v14
	}
end

local t3 = {}
local v7 = t.strictInterface({
	minimumItemsPerRow = t.intersection(t.integer, t.numberMin(1)),
	minimumItemWidth = t.numberMin(0)
})
local v8 = t.tuple(t.numberMin(0), t.number)

function t3.makeCustomMetricsGetter(p4) -- line: 48
	-- upvalues: v7 (copy), v8 (copy)
	assert(v7(p4))

	return function(p5, p6) -- line: 51
		-- upvalues: v8 (copy), p4 (copy)
		assert(v8(p5, p6))

		local v26 = p4
		local v27 = math.floor((p5 + p6) / (v26.minimumItemWidth + p6))
		local v28 = math.max(v26.minimumItemsPerRow, v27)
		local v29 = math.floor((p5 - (v28 - 1) * p6) / v28)

		return {
			itemsPerRow = v28,
			itemWidth = v29
		}
	end
end

t3.getLargeMetrics = t3.makeCustomMetricsGetter(t2)
t3.getMediumMetrics = t3.makeCustomMetricsGetter(t1)

function t3.getSmallMetrics(p7, p8) -- line: 60
	-- upvalues: t3 (copy)
	local v18 = t3.getMediumMetrics(p7, p8).itemsPerRow + 1
	local v19 = math.floor((p7 - (v18 - 1) * p8) / v18)

	return {
		itemsPerRow = v18,
		itemWidth = v19
	}
end
function t3.getMetricsForFixedColumns(p9, p10, p11) -- line: 73
	local v23 = math.floor((p9 - (p11 - 1) * p10) / p11)

	return {
		itemsPerRow = p11,
		itemWidth = v23
	}
end

return t3
