local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("FriendsCommon").Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local LoggingProtocol = require(parent.LoggingProtocol)

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
			type = SupportedTelemetryBackends.EventIngest,
			format = function(p, _)
				return p
			end
		}
	}
})

local function fireFriendsSortFeRtnMessageReceived(messageId: string?, items)
	if messageId == nil or not items then
		return
	end

	pcall(function()
		local userIds = {}

		for _, item in pairs(items) do
			table.insert(userIds, (tostring(item.userId)))
		end

		emitter.emit(telemetry, {
			messageId = messageId,
			userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil,
			friendIds = table.concat(userIds, ","),
			sortType = "Carousel"
		})
	end)
end

return fireFriendsSortFeRtnMessageReceived
