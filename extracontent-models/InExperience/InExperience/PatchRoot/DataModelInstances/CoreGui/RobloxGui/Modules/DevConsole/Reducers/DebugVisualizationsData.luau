local Immutable = require(script.Parent.Parent.Immutable)
local DebugVisualizationsUpdateSearchFilter = require(script.Parent.Parent.Actions.DebugVisualizationsUpdateSearchFilter)

return function(t1: {[any]: any}?, t2: {[any]: any}) -- line: 5
	-- upvalues: Immutable (copy), DebugVisualizationsUpdateSearchFilter (copy)
	local v5 = t1 or {
		debugVisualizationsSearchTerm = "",
		debugVisualizationsTypeFilters = {}
	}
	local v6 = if t2.filterTypes ~= nil then Immutable.JoinDictionaries(v5.debugVisualizationsTypeFilters, t2.filterTypes) else v5.debugVisualizationsTypeFilters

	if t2.type == DebugVisualizationsUpdateSearchFilter.name then
		local t3 = {
			debugVisualizationsSearchTerm = t2.searchTerm,
			debugVisualizationsTypeFilters = v6
		}

		return Immutable.JoinDictionaries(v5, t3)
	end

	return v5
end
