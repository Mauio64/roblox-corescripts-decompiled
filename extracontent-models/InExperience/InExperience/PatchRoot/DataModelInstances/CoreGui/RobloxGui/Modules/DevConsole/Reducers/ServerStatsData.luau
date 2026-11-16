local Immutable = require(script.Parent.Parent.Immutable)

local ServerStatsUpdateSearchFilter = require(script.Parent.Parent.Actions.ServerStatsUpdateSearchFilter)

return function(p, p2)
	local selected = p or { statsSearchTerm = "" }

	if p2.type == ServerStatsUpdateSearchFilter.name then
		return (Immutable.Set(selected, "statsSearchTerm", p2.searchTerm))
	end

	return selected
end
