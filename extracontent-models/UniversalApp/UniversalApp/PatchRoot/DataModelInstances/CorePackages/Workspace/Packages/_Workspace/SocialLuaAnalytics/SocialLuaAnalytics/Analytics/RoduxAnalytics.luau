local Actions = require(script.Actions)
local Selectors = require(script.Selectors)
local Reducers = require(script.Reducers)

require(script.AnalyticsTypes)

return {
	config = function(p1) -- line: 7
		-- upvalues: Reducers (copy), Actions (copy), Selectors (copy)
		return {
			installReducer = function() -- line: 9
				-- upvalues: Reducers (copy), p1 (copy)
				return Reducers(p1)
			end,
			Actions = Actions(p1),
			Selectors = Selectors(p1)
		}
	end
}
