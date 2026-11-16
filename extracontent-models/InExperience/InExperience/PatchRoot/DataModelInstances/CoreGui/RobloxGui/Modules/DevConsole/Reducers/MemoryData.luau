local Immutable = require(script.Parent.Parent.Immutable)

local ClientMemoryUpdateSearchFilter = require(script.Parent.Parent.Actions.ClientMemoryUpdateSearchFilter)
local ServerMemoryUpdateSearchFilter = require(script.Parent.Parent.Actions.ServerMemoryUpdateSearchFilter)

return function(p, p2)
	local selected = p or { clientSearchTerm = "", serverSearchTerm = "" }

	if p2.type == ClientMemoryUpdateSearchFilter.name then
		return (Immutable.Set(selected, "clientSearchTerm", p2.searchTerm))
	end

	if p2.type == ServerMemoryUpdateSearchFilter.name then
		return (Immutable.Set(selected, "serverSearchTerm", p2.searchTerm))
	end

	return selected
end
