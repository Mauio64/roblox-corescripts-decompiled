local Immutable = require(script.Parent.Parent.Immutable)
local ServerStatsUpdateSearchFilter = require(script.Parent.Parent.Actions.ServerStatsUpdateSearchFilter)

return function(t1: {[any]: any}?, t2: {[any]: any}) -- line: 9
	-- upvalues: ServerStatsUpdateSearchFilter (copy), Immutable (copy)
	local v5 = t1 or {
		statsSearchTerm = ""
	}

	if t2.type == ServerStatsUpdateSearchFilter.name then
		return (Immutable.Set(v5, "statsSearchTerm", t2.searchTerm))
	end

	return v5
end
