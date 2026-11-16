local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

require(UserList.Common.Types)

local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends

return SocialLuaAnalytics.Telemetry.new({
	name = "UserListInteraction",
	description = "A user interacted with a user-list row",
	lastUpdated = { 2026, 9, 14 },
	backendsList = {
		{
			type = SupportedTelemetryBackends.EventIngest,
			standardizedFields = { "addSessionInfo", "addSessionId" },
			format = function(p, _)
				return p
			end
		}
	}
})
