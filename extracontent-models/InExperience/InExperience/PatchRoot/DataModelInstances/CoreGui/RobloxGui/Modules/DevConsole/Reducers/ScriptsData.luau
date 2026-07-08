local Immutable = require(script.Parent.Parent.Immutable)
local ClientScriptsUpdateSearchFilter = require(script.Parent.Parent.Actions.ClientScriptsUpdateSearchFilter)
local ServerScriptsUpdateSearchFilter = require(script.Parent.Parent.Actions.ServerScriptsUpdateSearchFilter)

return function(t1: {[any]: any}?, t2: {[any]: any}) -- line: 13
	-- upvalues: ClientScriptsUpdateSearchFilter (copy), Immutable (copy), ServerScriptsUpdateSearchFilter (copy)
	local v6 = t1 or {
		clientSearchTerm = "",
		serverSearchTerm = "",
		clientTypeFilters = {},
		serverTypeFilters = {}
	}

	if t2.type == ClientScriptsUpdateSearchFilter.name then
		local t3 = {
			clientSearchTerm = t2.searchTerm,
			clientTypeFilters = Immutable.JoinDictionaries(v6.clientTypeFilters, t2.filterTypes)
		}

		return (Immutable.JoinDictionaries(v6, t3))
	end

	if t2.type == ServerScriptsUpdateSearchFilter.name then
		local t4 = {
			serverSearchTerm = t2.searchTerm,
			serverTypeFilters = Immutable.JoinDictionaries(v6.serverTypeFilters, t2.filterTypes)
		}

		return (Immutable.JoinDictionaries(v6, t4))
	end

	return v6
end
