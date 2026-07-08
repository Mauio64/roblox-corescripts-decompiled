local ParentParent = script.Parent.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)

require(script.Parent.Parent.AnalyticsTypes)

return dependencies.Rodux.makeActionCreator(script.Name, function(p1) -- line: 7
	return {
		payload = p1
	}
end)
