local Songbird = script:FindFirstAncestor("Songbird")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Cryo = require(Songbird.Parent.Cryo)
local LoggingProtocol = require(Songbird.Parent.LoggingProtocol)

require(Songbird.types)

local getFIntSongbirdTelemetryThrottle = require(Songbird.Flags.getFIntSongbirdTelemetryThrottle)
local default = LoggingProtocol.default
local t1 = {
	eventName = "NowPlayingChromeWindowAnalytics",
	description = " Now Playing Chrome Window UI related analytics ",
	links = "https://roblox.atlassian.net/wiki/x/I4Fcqw",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = getFIntSongbirdTelemetryThrottle(),
	lastUpdated = {
		24,
		12,
		10
	}
}

local function sendChromeWindowAnalytics(p1) -- line: 30
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

return sendChromeWindowAnalytics
