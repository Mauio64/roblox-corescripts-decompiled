local Immutable = require(script.Parent.Parent.Immutable)
local ActionBindingsUpdateSearchFilter = require(script.Parent.Parent.Actions.ActionBindingsUpdateSearchFilter)

return function(t1: {[any]: any}?, t2: {[any]: any}) -- line: 9
	-- upvalues: ActionBindingsUpdateSearchFilter (copy), Immutable (copy)
	local v5 = t1 or {
		bindingsSearchTerm = ""
	}

	if t2.type == ActionBindingsUpdateSearchFilter.name then
		return (Immutable.Set(v5, "bindingsSearchTerm", t2.searchTerm))
	end

	return v5
end
