local Players = game:GetService("Players")

local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SocialLuaAnalytics")
local supportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCommon/LoggingProtocol")

local emitter = SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		throttlingThousandths = game:DefineFastInt("FriendsCommonAnalyticsThrottlingThousandths", 10000),
		links = "https://docs.google.com/document/d/1uRCdl8pEuiW9wDiOTL39JPMGLhgxtpvVgiXovE8Xof4"
	},
	getSharedInfo = function()
		return {}
	end
})

local telemetry = SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeRtnMessage",
	description = "User received an rtn message v2",
	lastUpdated = { 2026, 6, 18 },
	backendsList = {
		{
			type = supportedTelemetryBackends.EventIngest,
			format = function(p2, p3)
				return p2
			end
		}
	}
})

local function fireFriendsSortFeRtnMessageReceived(p2, items)
	if p2 == nil or not items then
		return
	end

	pcall(function()
		local userIds = {}

		for k, item in pairs(items) do
			table.insert(userIds, (tostring(item.userId)))
		end

		emitter.emit(telemetry, {
			messageId = p2,
			userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil,
			friendIds = table.concat(userIds, ","),
			sortType = "Carousel"
		})
	end)
end

return fireFriendsSortFeRtnMessageReceived
