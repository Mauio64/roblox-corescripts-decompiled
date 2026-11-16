local parent = script.Parent.Parent.Parent

require(parent.LeaderboardStore)

local function computeStatColumns(p, p2: number)
	if not p then
		return {}
	end

	local v = {}
	p.iterateData(function(name, p3)
		table.insert(v, { name = name, order = p3.order(false) })
	end, false)

	table.sort(v, function(a, b): boolean
		return a.order < b.order
	end)

	local result = {}

	for i, v2 in ipairs(v) do
		if p2 < i then
			break
		end

		table.insert(result, { name = v2.name, order = v2.order })
	end

	return result
end

return computeStatColumns
