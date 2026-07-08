local Immutable = require(script.Parent.Parent.Immutable)
local ClientMemoryUpdateSearchFilter = require(script.Parent.Parent.Actions.ClientMemoryUpdateSearchFilter)
local ServerMemoryUpdateSearchFilter = require(script.Parent.Parent.Actions.ServerMemoryUpdateSearchFilter)

return function(t1: {[any]: any}?, t2: {[any]: any}) -- line: 11
	-- upvalues: ClientMemoryUpdateSearchFilter (copy), Immutable (copy), ServerMemoryUpdateSearchFilter (copy)
	local v6 = t1 or {
		clientSearchTerm = "",
		serverSearchTerm = ""
	}

	if t2.type == ClientMemoryUpdateSearchFilter.name then
		return (Immutable.Set(v6, "clientSearchTerm", t2.searchTerm))
	end

	if t2.type == ServerMemoryUpdateSearchFilter.name then
		return (Immutable.Set(v6, "serverSearchTerm", t2.searchTerm))
	end

	return v6
end
