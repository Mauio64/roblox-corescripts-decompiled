local Actions = require(script.Actions)
local Selectors = require(script.Selectors)
local Reducers = require(script.Reducers)
require(script.AnalyticsTypes)

return {
	config = function(p)
		return {
			installReducer = function()
				return Reducers(p)
			end,
			Actions = Actions(p),
			Selectors = Selectors(p)
		}
	end
}
