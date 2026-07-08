local Immutable = require(script.Parent.Parent.Immutable)
local DataStoresUpdateSearchFilter = require(script.Parent.Parent.Actions.DataStoresUpdateSearchFilter)

return function(t1: {[any]: any}?, t2: {[any]: any}) -- line: 9
	-- upvalues: DataStoresUpdateSearchFilter (copy), Immutable (copy)
	local v5 = t1 or {
		storesSearchTerm = ""
	}

	if t2.type == DataStoresUpdateSearchFilter.name then
		return (Immutable.Set(v5, "storesSearchTerm", t2.searchTerm))
	end

	return v5
end
