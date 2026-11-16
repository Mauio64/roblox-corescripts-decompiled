local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SocialLuaAnalytics")

require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local supportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends

return SocialLuaAnalytics.Telemetry.new({
	name = "UserListInteraction",
	description = "A user interacted with a user-list row",
	lastUpdated = { 2026, 9, 14 },
	backendsList = {
		{
			type = supportedTelemetryBackends.EventIngest,
			standardizedFields = { "addSessionInfo", "addSessionId" },
			format = function(p2, p3)
				return p2
			end
		}
	}
})
