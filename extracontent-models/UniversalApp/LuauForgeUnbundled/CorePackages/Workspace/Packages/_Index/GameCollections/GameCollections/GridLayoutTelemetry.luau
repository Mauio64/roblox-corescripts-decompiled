local TelemetryService = game:GetService("TelemetryService")

require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes")

local v5 = { "addOSInfo", "addSessionInfo", "addSessionId" }

local v6 = {
	eventName = "TileSkipped",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("TileSkippedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 1, 16 },
	description = "This is fired when a tile render gets skipped."
}

local v7 = {
	eventName = "TilePlaced",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("TilePlacedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 1, 16 },
	description = "This is fired when a tile position has been determined."
}

return {
	logTileSkipped = function(p2, p3, p4, p5, p6, p7, p8, p9, p10)
		TelemetryService:LogEvent(v6, {
			standardizedFields = v5,
			customFields = {
				adId = p2,
				universeId = p3,
				tileType = p4,
				pageContext = p5,
				numColumns = p6,
				numRows = p7,
				originalFeedIndex = p8,
				sortIndex = p9,
				topicId = p10
			}
		})
	end,
	logTilePlaced = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
		TelemetryService:LogEvent(v7, {
			standardizedFields = v5,
			customFields = {
				adId = p2,
				universeId = p3,
				tileType = p4,
				pageContext = p5,
				numColumns = p6,
				numRows = p7,
				originalFeedIndex = p8,
				finalFeedIndex = p9,
				sortIndex = p10,
				topicId = p11,
				totalFilledColumns = p12
			}
		})
	end
}
