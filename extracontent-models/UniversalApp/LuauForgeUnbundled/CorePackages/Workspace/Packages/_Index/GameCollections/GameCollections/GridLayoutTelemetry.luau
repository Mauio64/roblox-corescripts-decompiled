local TelemetryService = game:GetService("TelemetryService")

require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags")

local defineFastFlag = game:DefineFastFlag("LuaAppNullableGridLayoutTelemetryFields", false)
local fFlagLuaAppFixTotalColsBound = SharedFlags.FFlagLuaAppFixTotalColsBound

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
	logTileSkipped = function(value, value2, p2, p3, p4, p5, p6, value3, value4)
		TelemetryService:LogEvent(v6, {
			standardizedFields = v5,
			customFields = {
				adId = not defineFastFlag and (value or "") or value,
				universeId = not defineFastFlag and (value2 or "") or value2,
				tileType = p2,
				pageContext = p3,
				numColumns = p4,
				numRows = p5,
				originalFeedIndex = p6,
				sortIndex = not defineFastFlag and (value3 or -1) or value3,
				topicId = not defineFastFlag and (value4 or "") or value4
			}
		})
	end,
	logTilePlaced = function(value, value2, p2, p3, p4, p5, p6, p7, p8, p9, totalFilledColumns)
		local v8 = {
			adId = not defineFastFlag and (value or "") or value,
			universeId = not defineFastFlag and (value2 or "") or value2,
			tileType = p2,
			pageContext = p3,
			numColumns = p4,
			numRows = p5,
			originalFeedIndex = p6,
			finalFeedIndex = p7,
			sortIndex = p8,
			topicId = p9,
			totalFilledColumns = nil
		}

		if not fFlagLuaAppFixTotalColsBound then
			totalFilledColumns = nil
		end

		v8.totalFilledColumns = totalFilledColumns

		TelemetryService:LogEvent(v7, { standardizedFields = v5, customFields = v8 })
	end
}
