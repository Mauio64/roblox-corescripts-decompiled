local ParentParent = script.Parent.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local Rodux = dependencies.Rodux
local Dash = dependencies.Dash
local ParentParent2 = script.Parent.Parent

require(ParentParent2.AnalyticsTypes)

local SessionIdUpdated = require(ParentParent2.Actions.SessionIdUpdated)
local t1 = {}

return function(_) -- line: 12
	-- upvalues: Rodux (copy), t1 (copy), SessionIdUpdated (copy), Dash (copy)
	return Rodux.createReducer(t1, {
		[SessionIdUpdated.name] = function(p2, p3) -- line: 14
			-- upvalues: Dash (copy), t1 (copy)
			local sessionKey = p3.payload.sessionKey
			local sessionId = p3.payload.sessionId

			return Dash.join(p2 or t1, {
				[sessionKey] = sessionId
			})
		end
	})
end
