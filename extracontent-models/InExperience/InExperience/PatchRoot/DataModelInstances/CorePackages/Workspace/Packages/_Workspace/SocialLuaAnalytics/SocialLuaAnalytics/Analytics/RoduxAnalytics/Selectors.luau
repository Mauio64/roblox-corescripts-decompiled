require(script.Parent.AnalyticsTypes)
local getSessionIdByKey = require(script.getSessionIdByKey)

return function(p)
	return { getSessionIdByKey = getSessionIdByKey(p) }
end
