local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

require(ViewRecycler.Core.Types)

local v = {
	Edge = table.freeze({ Start = "start", End = "end" })
}

function v.resolve(p)
	local startItems = p == nil and 0 or p.startItems or 0
	local endItems = p == nil and 0 or p.endItems or 0
	local v2 = startItems >= 0 and startItems % 1 == 0
	assert(v2, "DataPrefetch: startItems must be a non-negative integer")
	local v3 = endItems >= 0 and endItems % 1 == 0
	assert(v3, "DataPrefetch: endItems must be a non-negative integer")
	return { startItems = startItems, endItems = endItems }
end

return table.freeze(v)
