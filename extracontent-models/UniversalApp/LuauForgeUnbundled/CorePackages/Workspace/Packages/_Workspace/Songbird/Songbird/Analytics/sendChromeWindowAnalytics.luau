local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Cryo")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/LoggingProtocol")

require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/types")

local getFIntSongbirdTelemetryThrottle = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Flags/getFIntSongbirdTelemetryThrottle")

local default = LoggingProtocol.default

local v5 = {
	eventName = "NowPlayingChromeWindowAnalytics",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = getFIntSongbirdTelemetryThrottle(),
	lastUpdated = { 24, 12, 10 },
	description = " Now Playing Chrome Window UI related analytics ",
	links = "https://roblox.atlassian.net/wiki/x/I4Fcqw"
}

local function sendChromeWindowAnalytics(p2): nil
	local v6 = {
		placeid = tostring(game.PlaceId),
		sessionid = RbxAnalyticsService:GetSessionId(),
		universeid = tostring(game.GameId)
	}

	default:logRobloxTelemetryEvent(v5, nil, (Cryo.Dictionary.join(p2, v6)))

	return nil
end

return sendChromeWindowAnalytics
