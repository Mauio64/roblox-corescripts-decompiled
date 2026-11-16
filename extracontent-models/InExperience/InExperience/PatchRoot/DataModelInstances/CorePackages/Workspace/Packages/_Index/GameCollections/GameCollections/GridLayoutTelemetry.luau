local GameCollections = script:FindFirstAncestor("GameCollections")
local TelemetryService = game:GetService("TelemetryService")
local parent = GameCollections.Parent

require(parent.DiscoveryTypes)
local SharedFlags = require(parent.SharedFlags)

local defineFastFlag = game:DefineFastFlag("LuaAppNullableGridLayoutTelemetryFields", false)
local FFlagLuaAppFixTotalColsBound = SharedFlags.FFlagLuaAppFixTotalColsBound

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

function GridLayoutTelemetry.logTileSkipped(value: string?, value2: string?, tileType, pageContext: string, numColumns: number, numRows: number, originalFeedIndex: number, value3: number?, value4: string?)
	TelemetryService:LogEvent(v, {
		standardizedFields = standardizedFields,
		customFields = {
			adId = not defineFastFlag and (value or "") or value,
			universeId = not defineFastFlag and (value2 or "") or value2,
			tileType = tileType,
			pageContext = pageContext,
			numColumns = numColumns,
			numRows = numRows,
			originalFeedIndex = originalFeedIndex,
			sortIndex = not defineFastFlag and (value3 or -1) or value3,
			topicId = not defineFastFlag and (value4 or "") or value4
		}
	})
end

function GridLayoutTelemetry.logTilePlaced(value: string?, value2: string?, tileType, pageContext: string, numColumns: number, numRows: number, originalFeedIndex: number, finalFeedIndex: number, sortIndex: number?, topicId: string?, totalFilledColumns: number?)
	local customFields = {
		adId = not defineFastFlag and (value or "") or value,
		universeId = not defineFastFlag and (value2 or "") or value2,
		tileType = tileType,
		pageContext = pageContext,
		numColumns = numColumns,
		numRows = numRows,
		originalFeedIndex = originalFeedIndex,
		finalFeedIndex = finalFeedIndex,
		sortIndex = sortIndex,
		topicId = topicId,
		totalFilledColumns = nil
	}

	if not FFlagLuaAppFixTotalColsBound then
		totalFilledColumns = nil
	end

	customFields.totalFilledColumns = totalFilledColumns

	TelemetryService:LogEvent(v2, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end

return GridLayoutTelemetry
