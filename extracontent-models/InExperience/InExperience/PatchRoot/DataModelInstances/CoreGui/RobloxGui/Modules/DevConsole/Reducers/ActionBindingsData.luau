local Immutable = require(script.Parent.Parent.Immutable)

local ActionBindingsUpdateSearchFilter = require(script.Parent.Parent.Actions.ActionBindingsUpdateSearchFilter)

return function(p, p2)
	local selected = p or { bindingsSearchTerm = "" }

	if p2.type == ActionBindingsUpdateSearchFilter.name then
		return (Immutable.Set(selected, "bindingsSearchTerm", p2.searchTerm))
	end

	return selected
end
