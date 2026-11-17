local GameCollections = script:FindFirstAncestor("GameCollections")
local TelemetryService = game:GetService("TelemetryService")
local parent = GameCollections.Parent

require(parent.DiscoveryTypes)

local standardizedFields = { "addOSInfo", "addSessionInfo", "addSessionId" }

local v = {
	eventName = "TileSkipped",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("TileSkippedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 1, 16 },
	description = "This is fired when a tile render gets skipped."
}

local v2 = {
	eventName = "TilePlaced",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("TilePlacedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 1, 16 },
	description = "This is fired when a tile position has been determined."
}
local GridLayoutTelemetry = {}

function GridLayoutTelemetry.logTileSkipped(adId: string?, universeId: string?, tileType, pageContext: string, numColumns: number, numRows: number, originalFeedIndex: number, sortIndex: number?, topicId: string?)
	TelemetryService:LogEvent(v, {
		standardizedFields = standardizedFields,
		customFields = {
			adId = adId,
			universeId = universeId,
			tileType = tileType,
			pageContext = pageContext,
			numColumns = numColumns,
			numRows = numRows,
			originalFeedIndex = originalFeedIndex,
			sortIndex = sortIndex,
			topicId = topicId
		}
	})
end

function GridLayoutTelemetry.logTilePlaced(adId: string?, universeId: string?, tileType, pageContext: string, numColumns: number, numRows: number, originalFeedIndex: number, finalFeedIndex: number, sortIndex: number?, topicId: string?, totalFilledColumns: number?)
	TelemetryService:LogEvent(v2, {
		standardizedFields = standardizedFields,
		customFields = {
			adId = adId,
			universeId = universeId,
			tileType = tileType,
			pageContext = pageContext,
			numColumns = numColumns,
			numRows = numRows,
			originalFeedIndex = originalFeedIndex,
			finalFeedIndex = finalFeedIndex,
			sortIndex = sortIndex,
			topicId = topicId,
			totalFilledColumns = totalFilledColumns
		}
	})
end

return GridLayoutTelemetry
