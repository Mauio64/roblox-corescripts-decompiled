local Immutable = require(script.Parent.Parent.Immutable)

local DataStoresUpdateSearchFilter = require(script.Parent.Parent.Actions.DataStoresUpdateSearchFilter)

return function(p, p2)
	local selected = p or { storesSearchTerm = "" }

	if p2.type == DataStoresUpdateSearchFilter.name then
		return (Immutable.Set(selected, "storesSearchTerm", p2.searchTerm))
	end

	return selected
end
