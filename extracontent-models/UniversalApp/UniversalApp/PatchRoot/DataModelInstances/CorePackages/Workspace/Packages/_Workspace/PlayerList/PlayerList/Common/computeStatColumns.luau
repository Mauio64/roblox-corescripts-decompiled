local ParentParent = script.Parent.Parent.Parent

require(ParentParent.LeaderboardStore)

local function computeStatColumns(p1, n1: number) -- line: 19
	if not p1 then
		return {}
	end

	local t1 = {}

	p1.iterateData(function(p2, p3) -- line: 25
		-- upvalues: t1 (copy)
		table.insert(t1, {
			name = p2,
			order = p3.order(false)
		})
	end, false)
	table.sort(t1, function(p4, p5) -- line: 29
		return p4.order < p5.order
	end)

	local t2 = {}

	for i, v in ipairs(t1) do
		if n1 < i then
			return t2
		end

		table.insert(t2, {
			name = v.name,
			order = v.order
		})
	end

	return t2
end

return computeStatColumns
