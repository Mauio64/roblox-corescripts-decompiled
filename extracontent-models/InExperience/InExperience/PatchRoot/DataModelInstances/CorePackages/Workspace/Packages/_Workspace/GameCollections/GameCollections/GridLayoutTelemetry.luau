local GameCollections = script:FindFirstAncestor("GameCollections")
local TelemetryService = game:GetService("TelemetryService")
local GameCollectionsParent = GameCollections.Parent

require(GameCollectionsParent.DiscoveryTypes)

local SharedFlags = require(GameCollectionsParent.SharedFlags)
local v5 = game:DefineFastFlag("LuaAppNullableGridLayoutTelemetryFields", false)
local FFlagLuaAppFixTotalColsBound = SharedFlags.FFlagLuaAppFixTotalColsBound
local t1 = {
	"addOSInfo",
	"addSessionInfo",
	"addSessionId"
}
local t2 = {
	eventName = "TileSkipped",
	description = "This is fired when a tile render gets skipped.",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("TileSkippedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		26,
		1,
		16
	}
}
local t3 = {
	eventName = "TilePlaced",
	description = "This is fired when a tile position has been determined.",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("TilePlacedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		26,
		1,
		16
	}
}

return {
	logTileSkipped = function(s1: string?, s2: string?, p1, s3: string, n1: number, n2: number, n3: number, n4: number?, s4: string?) -- line: 40
		-- upvalues: v5 (copy), TelemetryService (copy), t2 (copy), t1 (copy)
		local t4 = {
			adId = if not v5 then s1 or "" else s1,
			universeId = if not v5 then s2 or "" else s2,
			tileType = p1,
			pageContext = s3,
			numColumns = n1,
			numRows = n2,
			originalFeedIndex = n3,
			sortIndex = if not v5 then n4 or -1 else n4,
			topicId = if not v5 then s4 or "" else s4
		}

		TelemetryService:LogEvent(t2, {
			standardizedFields = t1,
			customFields = t4
		})
	end,
	logTilePlaced = function(s5: string?, s6: string?, p2, s7: string, n5: number, n6: number, n7: number, n8: number, n9: number?, s8: string?, n10: number?) -- line: 69
		-- upvalues: v5 (copy), FFlagLuaAppFixTotalColsBound (copy), TelemetryService (copy), t3 (copy), t1 (copy)
		local t5 = {
			adId = if not v5 then s5 or "" else s5,
			universeId = if not v5 then s6 or "" else s6,
			tileType = p2,
			pageContext = s7,
			numColumns = n5,
			numRows = n6,
			originalFeedIndex = n7,
			finalFeedIndex = n8,
			sortIndex = n9,
			topicId = s8,
			totalFilledColumns = if not FFlagLuaAppFixTotalColsBound then nil else n10
		}

		TelemetryService:LogEvent(t3, {
			standardizedFields = t1,
			customFields = t5
		})
	end
}
