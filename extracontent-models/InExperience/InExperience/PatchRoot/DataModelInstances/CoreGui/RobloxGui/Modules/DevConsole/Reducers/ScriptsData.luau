local Immutable = require(script.Parent.Parent.Immutable)

local ClientScriptsUpdateSearchFilter = require(script.Parent.Parent.Actions.ClientScriptsUpdateSearchFilter)
local ServerScriptsUpdateSearchFilter = require(script.Parent.Parent.Actions.ServerScriptsUpdateSearchFilter)

return function(p, data)
	local selected = p
		or {
			clientSearchTerm = "",
			clientTypeFilters = {},
			serverSearchTerm = "",
			serverTypeFilters = {}
		}

	if data.type == ClientScriptsUpdateSearchFilter.name then
		local v = {
			clientSearchTerm = data.searchTerm,
			clientTypeFilters = Immutable.JoinDictionaries(selected.clientTypeFilters, data.filterTypes)
		}

		return (Immutable.JoinDictionaries(selected, v))
	end

	if data.type ~= ServerScriptsUpdateSearchFilter.name then
		return selected
	end

	local v = {
		serverSearchTerm = data.searchTerm,
		serverTypeFilters = Immutable.JoinDictionaries(selected.serverTypeFilters, data.filterTypes)
	}

	return (Immutable.JoinDictionaries(selected, v))
end
