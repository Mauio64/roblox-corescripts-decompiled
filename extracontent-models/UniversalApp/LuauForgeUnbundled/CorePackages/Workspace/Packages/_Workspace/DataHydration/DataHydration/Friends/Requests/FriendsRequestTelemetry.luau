local HttpService = game:GetService("HttpService")

local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SocialLuaAnalytics")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LoggingProtocol")

local supportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends

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
	name = "FriendsSortFeFindFriendsResponse",
	description = "User making a request to /FindFriends",
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

local telemetry2 = SocialLuaAnalytics.Telemetry.new({
	name = "FriendsSortFeGetAllOnlineFriendsResponse",
	description = "User making a request to /GetAllOnlineFriends",
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

local function safeEmit(p2, p3)
	pcall(function()
		emitter.emit(p2, p3)
	end)
end

return {
	generateRequestId = function()
		return string.format("friends-sort-%s", HttpService:GenerateGUID(false))
	end,
	getRequestOptions = function(p2)
		if p2 == nil then
			return nil
		end

		return {
			headers = { ["friends-sort"] = p2 }
		}
	end,
	emitFindFriendsResponse = function(p2, list)
		local v5 = telemetry
		local v6 = {
			requestId = p2,
			friendIds = table.concat(list, ","),
			sortType = "FriendScore"
		}
		pcall(function()
			emitter.emit(v5, v6)
		end)
	end,
	emitGetAllOnlineFriendsResponse = function(p2, list)
		local v5 = telemetry2
		local v6 = {
			requestId = p2,
			friendIds = table.concat(list, ","),
			sortType = "Carousel"
		}
		pcall(function()
			emitter.emit(v5, v6)
		end)
	end
}
