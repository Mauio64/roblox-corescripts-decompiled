local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("FriendsCommon").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local LoggingProtocol = require(Parent.LoggingProtocol)
local v6 = SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		links = "https://docs.google.com/document/d/1uRCdl8pEuiW9wDiOTL39JPMGLhgxtpvVgiXovE8Xof4",
		throttlingThousandths = game:DefineFastInt("FriendsCommonAnalyticsThrottlingThousandths", 10000)
	},
	getSharedInfo = function() -- line: 27
		return {}
	end
})
local v7 = SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeRtnMessage",
	description = "User received an rtn message v2",
	lastUpdated = {
		2026,
		6,
		18
	},
	backendsList = {{
		type = SupportedTelemetryBackends.EventIngest,
		format = function(t1: {[any]: any}, _: {[any]: any}) -- line: 39
			return t1
		end
	}}
})

local function fireFriendsSortFeRtnMessageReceived(s1: string?, t3: {[any]: any}?) -- line: 46
	-- upvalues: v6 (copy), v7 (copy), Players (copy)
	if s1 == nil or not t3 then
		return
	end

	pcall(function() -- line: 51
		-- upvalues: t3 (copy), v6 (copy), v7 (copy), s1 (copy), Players (copy)
		local t4 = {}

		for _, v in pairs(t3) do
			table.insert(t4, (tostring(v.userId)))
		end

		v6.emit(v7, {
			sortType = "Carousel",
			messageId = s1,
			userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil,
			friendIds = table.concat(t4, ",")
		})
	end)
end

return fireFriendsSortFeRtnMessageReceived
