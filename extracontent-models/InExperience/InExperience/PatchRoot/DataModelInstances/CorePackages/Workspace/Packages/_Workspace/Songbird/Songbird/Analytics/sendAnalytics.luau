local Songbird = script:FindFirstAncestor("Songbird")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Cryo = require(Songbird.Parent.Cryo)
local LoggingProtocol = require(Songbird.Parent.LoggingProtocol)

require(Songbird.types)

local getFIntSongbirdTelemetryThrottle = require(Songbird.Flags.getFIntSongbirdTelemetryThrottle)
local default = LoggingProtocol.default
local t1 = {
	eventName = "NowPlayingPeekAnalytics",
	description = " Peek UI related analytics ",
	links = "https://roblox.atlassian.net/l/cp/VLpzDBz5",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = getFIntSongbirdTelemetryThrottle(),
	lastUpdated = {
		24,
		30,
		9
	}
}

local function sendAnalytics(p1) -- line: 30
	-- upvalues: RbxAnalyticsService (copy), Cryo (copy), default (copy), t1 (copy)
	local t2 = {
		placeid = tostring(game.PlaceId),
		sessionid = RbxAnalyticsService:GetSessionId(),
		universeid = tostring(game.GameId)
	}
	local v11 = Cryo.Dictionary.join(p1, t2)

	default:logRobloxTelemetryEvent(t1, nil, v11)

	return nil
end

return sendAnalytics
