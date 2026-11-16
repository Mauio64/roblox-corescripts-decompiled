local parent = script.Parent.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
require(script.Parent.Parent.AnalyticsTypes)

return dependencies.Rodux.makeActionCreator(script.Name, function(payload)
	return { payload = payload }
end)
