local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/UserList/LoggingProtocol")
return require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SocialLuaAnalytics").Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		throttlingThousandths = game:DefineFastInt("UserListAnalyticsThrottlingThousandths", 10000),
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/user_list_interactions.proto"
	},
	getSharedInfo = function()
		return {}
	end
})
