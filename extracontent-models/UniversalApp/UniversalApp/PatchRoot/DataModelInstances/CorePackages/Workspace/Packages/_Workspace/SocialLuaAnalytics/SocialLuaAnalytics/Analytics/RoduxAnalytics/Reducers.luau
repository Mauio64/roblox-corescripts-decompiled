local ParentParent = script.Parent.Parent.Parent
local Rodux = require(ParentParent.dependencies).Rodux

require(script.Parent.AnalyticsTypes)

local bySessionKey = require(script.bySessionKey)

return function(p1) -- line: 8
	-- upvalues: Rodux (copy), bySessionKey (copy)
	return Rodux.combineReducers({
		bySessionKey = bySessionKey(p1)
	})
end
