local parent = script:FindFirstAncestor("UserList").Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

return SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		throttlingThousandths = game:DefineFastInt("UserListAnalyticsThrottlingThousandths", 10000),
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/user_list_interactions.proto"
	},
	getSharedInfo = function()
		return {}
	end
})
