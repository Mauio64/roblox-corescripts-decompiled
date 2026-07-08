local TelemetryService = game:GetService("TelemetryService")

require(script.Parent.sponsoredAdViewabilityRegistry)
require(script.Parent.sponsoredAdViewabilityState)

local t1 = {
	"addSessionInfo",
	"addSessionId",
	"addOSInfo"
}
local t2 = {
	eventName = "SponsoredAdLoad",
	description = "\t\tFires once per served sponsored ad when its tile begins to render on a surface.\n\t",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("LuaAppSponsoredAdLoadTelemetryThrottlingHundredthsPercent", 0),
	lastUpdated = {
		26,
		6,
		11
	}
}
local t3 = {
	eventName = "SponsoredAdViewableImpression",
	description = "\t\tFires once per IAB viewable-impression milestone reached by a served sponsored ad\n\t\t(standard 50% / 1s, large display 30% / 1s, full view 100% / 1s).\n\t",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("LuaAppSponsoredAdViewableImpressionTelemetryThrottlingHundredthsPercent", 0),
	lastUpdated = {
		26,
		6,
		16
	}
}

local function buildGeometryFields(p1) -- line: 42
	local adSize = p1.adSize
	local viewportBounds = p1.viewportBounds
	local v9 = viewportBounds.max.X - viewportBounds.min.X
	local v10 = viewportBounds.max.Y - viewportBounds.min.Y

	return {
		adWidth = if not (adSize.X > 0) then nil else adSize.X,
		adHeight = if not (adSize.Y > 0) then nil else adSize.Y,
		viewportWidth = if not (v9 > 0) then nil else v9,
		viewportHeight = if not (v10 > 0) then nil else v10
	}
end

return {
	logSponsoredAdLoad = function(p2, p3, n1: number) -- line: 56
		-- upvalues: buildGeometryFields (copy), TelemetryService (copy), t2 (copy), t1 (copy)
		local v14 = buildGeometryFields(p3)

		TelemetryService:LogEvent(t2, {
			standardizedFields = t1,
			customFields = {
				encryptedAdTrackingData = p2.encryptedAdTrackingData,
				tileType = p2.tileType,
				viewabilitySessionStartTimestampMs = n1,
				adWidth = v14.adWidth,
				adHeight = v14.adHeight,
				viewportWidth = v14.viewportWidth,
				viewportHeight = v14.viewportHeight
			}
		})
	end,
	logSponsoredAdViewableImpression = function(p4, p5) -- line: 77
		-- upvalues: buildGeometryFields (copy), TelemetryService (copy), t3 (copy), t1 (copy)
		local v17 = buildGeometryFields(p5.geometry)

		TelemetryService:LogEvent(t3, {
			standardizedFields = t1,
			customFields = {
				encryptedAdTrackingData = p4.encryptedAdTrackingData,
				tileType = p4.tileType,
				milestoneLabel = p5.milestoneLabel,
				viewabilitySessionStartTimestampMs = p5.viewabilitySessionStartTimestampMs,
				adWidth = v17.adWidth,
				adHeight = v17.adHeight,
				viewportWidth = v17.viewportWidth,
				viewportHeight = v17.viewportHeight
			}
		})
	end
}
