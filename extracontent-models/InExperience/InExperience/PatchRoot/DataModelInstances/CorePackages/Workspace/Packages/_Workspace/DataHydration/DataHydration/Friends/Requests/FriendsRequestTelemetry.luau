local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpService = game:GetService("HttpService")

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local LoggingProtocol = require(parent.LoggingProtocol)

local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends

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
			type = SupportedTelemetryBackends.EventIngest,
			format = function(p, _)
				return p
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
			type = SupportedTelemetryBackends.EventIngest,
			format = function(p, _)
				return p
			end
		}
	}
})

local function safeEmit(telemetry3, p) -- 2 equivalent calls inferred from this helper
	pcall(function()
		emitter.emit(telemetry3, p)
	end)
end

local FriendsRequestTelemetry = {}

function FriendsRequestTelemetry.generateRequestId()
	return string.format("friends-sort-%s", HttpService:GenerateGUID(false))
end

function FriendsRequestTelemetry.getRequestOptions(friendssort: string?)
	if friendssort == nil then
		return nil
	end

	return {
		headers = { ["friends-sort"] = friendssort }
	}
end

function FriendsRequestTelemetry.emitFindFriendsResponse(requestId: string, list)
	safeEmit(telemetry, { -- inferred equivalent call
		requestId = requestId,
		friendIds = table.concat(list, ","),
		sortType = "FriendScore"
	})
end

function FriendsRequestTelemetry.emitGetAllOnlineFriendsResponse(requestId: string, list)
	safeEmit(telemetry2, { -- inferred equivalent call
		requestId = requestId,
		friendIds = table.concat(list, ","),
		sortType = "Carousel"
	})
end

return FriendsRequestTelemetry
