local parent = script.Parent.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local rodux = dependencies.Rodux
local dash = dependencies.Dash

local parent2 = script.Parent.Parent
require(parent2.AnalyticsTypes)
local SessionIdUpdated = require(parent2.Actions.SessionIdUpdated)

local v = {}

return function(_)
	return rodux.createReducer(v, {
		[SessionIdUpdated.name] = function(p, p2)
			local sessionKey = p2.payload.sessionKey
			local sessionId = p2.payload.sessionId

			return dash.join(p or v, { [sessionKey] = sessionId })
		end
	})
end
