require(script.Parent.AnalyticsTypes)

local getSessionIdByKey = require(script.getSessionIdByKey)

return function(p1) -- line: 4
	-- upvalues: getSessionIdByKey (copy)
	return {
		getSessionIdByKey = getSessionIdByKey(p1)
	}
end
