local Immutable = require(script.Parent.Parent.Immutable)

local DebugVisualizationsUpdateSearchFilter = require(script.Parent.Parent.Actions.DebugVisualizationsUpdateSearchFilter)

return function(p, data)
	local v = p or { debugVisualizationsSearchTerm = "", debugVisualizationsTypeFilters = {} }
	local debugVisualizationsTypeFilters

	if data.filterTypes == nil then
		debugVisualizationsTypeFilters = v.debugVisualizationsTypeFilters
	else
		debugVisualizationsTypeFilters = Immutable.JoinDictionaries(v.debugVisualizationsTypeFilters, data.filterTypes)
	end

	if data.type ~= DebugVisualizationsUpdateSearchFilter.name then
		return v
	end

	local v2 = {
		debugVisualizationsSearchTerm = data.searchTerm,
		debugVisualizationsTypeFilters = debugVisualizationsTypeFilters
	}

	return Immutable.JoinDictionaries(v, v2)
end
