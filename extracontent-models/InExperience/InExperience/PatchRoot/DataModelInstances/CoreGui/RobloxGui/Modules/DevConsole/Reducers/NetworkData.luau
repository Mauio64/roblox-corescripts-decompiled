local Immutable = require(script.Parent.Parent.Immutable)

local ClientNetworkUpdateSearchFilter = require(script.Parent.Parent.Actions.ClientNetworkUpdateSearchFilter)
local ServerNetworkUpdateSearchFilter = require(script.Parent.Parent.Actions.ServerNetworkUpdateSearchFilter)

return function(p, p2)
	local selected = p or { clientSearchTerm = "", serverSearchTerm = "" }

	if p2.type == ClientNetworkUpdateSearchFilter.name then
		return (Immutable.Set(selected, "clientSearchTerm", p2.searchTerm))
	end

	if p2.type == ServerNetworkUpdateSearchFilter.name then
		return (Immutable.Set(selected, "serverSearchTerm", p2.searchTerm))
	end

	return selected
end
