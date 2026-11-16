local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local rodux = dependencies.Rodux
require(script.Parent.AnalyticsTypes)

local bySessionKey = require(script.bySessionKey)

return function(p)
	return rodux.combineReducers({ bySessionKey = bySessionKey(p) })
end
