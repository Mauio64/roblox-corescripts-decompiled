local Songbird = script:FindFirstAncestor("Songbird")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local Cryo = require(Songbird.Parent.Cryo)
local LoggingProtocol = require(Songbird.Parent.LoggingProtocol)

require(Songbird.types)

local getFIntSongbirdTelemetryThrottle = require(Songbird.Flags.getFIntSongbirdTelemetryThrottle)

local default = LoggingProtocol.default

local v = {
	eventName = "NowPlayingChromeWindowAnalytics",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = getFIntSongbirdTelemetryThrottle(),
	lastUpdated = { 24, 12, 10 },
	description = " Now Playing Chrome Window UI related analytics ",
	links = "https://roblox.atlassian.net/wiki/x/I4Fcqw"
}

local function sendChromeWindowAnalytics(p): nil
	local v2 = {
		placeid = tostring(game.PlaceId),
		sessionid = RbxAnalyticsService:GetSessionId(),
		universeid = tostring(game.GameId)
	}

	default:logRobloxTelemetryEvent(v, nil, (Cryo.Dictionary.join(p, v2)))

	return nil
end

return sendChromeWindowAnalytics
