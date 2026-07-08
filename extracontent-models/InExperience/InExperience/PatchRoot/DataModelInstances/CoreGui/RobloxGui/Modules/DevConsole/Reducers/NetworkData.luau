local Immutable = require(script.Parent.Parent.Immutable)
local ClientNetworkUpdateSearchFilter = require(script.Parent.Parent.Actions.ClientNetworkUpdateSearchFilter)
local ServerNetworkUpdateSearchFilter = require(script.Parent.Parent.Actions.ServerNetworkUpdateSearchFilter)

return function(t1: {[any]: any}?, t2: {[any]: any}) -- line: 11
	-- upvalues: ClientNetworkUpdateSearchFilter (copy), Immutable (copy), ServerNetworkUpdateSearchFilter (copy)
	local v6 = t1 or {
		clientSearchTerm = "",
		serverSearchTerm = ""
	}

	if t2.type == ClientNetworkUpdateSearchFilter.name then
		return (Immutable.Set(v6, "clientSearchTerm", t2.searchTerm))
	end

	if t2.type == ServerNetworkUpdateSearchFilter.name then
		return (Immutable.Set(v6, "serverSearchTerm", t2.searchTerm))
	end

	return v6
end
