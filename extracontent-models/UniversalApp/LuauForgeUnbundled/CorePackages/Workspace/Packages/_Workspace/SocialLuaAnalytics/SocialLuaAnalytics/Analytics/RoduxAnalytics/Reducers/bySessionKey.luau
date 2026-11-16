local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/dependencies")
local rodux = dependencies.Rodux
local dash = dependencies.Dash

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/RoduxAnalytics/AnalyticsTypes")
local SessionIdUpdated = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/RoduxAnalytics/Actions/SessionIdUpdated")

local v5 = {}

return function(p2)
	return rodux.createReducer(v5, {
		[SessionIdUpdated.name] = function(p3, p4)
			local sessionKey = p4.payload.sessionKey
			local sessionId = p4.payload.sessionId

			return dash.join(p3 or v5, { [sessionKey] = sessionId })
		end
	})
end
