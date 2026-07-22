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
local t4 = {
	eventName = "SponsoredAdUnload",
	description = "\t\tFires once per served sponsored ad when its viewability session reaches a terminal\n\t\tboundary, carrying the session's dwell and in-view duration summary.\n\t",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("LuaAppSponsoredAdUnloadTelemetryThrottlingHundredthsPercent", 0),
	lastUpdated = {
		26,
		6,
		25
	}
}

local function buildGeometryFields(p1) -- line: 57
	local adSize = p1.adSize
	local viewportBounds = p1.viewportBounds

	return {
		adWidth = if not (adSize.X > 0) then nil else adSize.X,
		adHeight = if not (adSize.Y > 0) then nil else adSize.Y,
		viewportWidth = viewportBounds.max.X - viewportBounds.min.X,
		viewportHeight = viewportBounds.max.Y - viewportBounds.min.Y
	}
end

return {
	logSponsoredAdLoad = function(p2, p3, n1: number) -- line: 69
		-- upvalues: buildGeometryFields (copy), TelemetryService (copy), t2 (copy), t1 (copy)
		local v13 = buildGeometryFields(p3)

		TelemetryService:LogEvent(t2, {
			standardizedFields = t1,
			customFields = {
				encryptedAdTrackingData = p2.encryptedAdTrackingData,
				tileType = p2.tileType,
				viewabilitySessionStartTimestampMs = n1,
				adWidth = v13.adWidth,
				adHeight = v13.adHeight,
				viewportWidth = v13.viewportWidth,
				viewportHeight = v13.viewportHeight
			}
		})
	end,
	logSponsoredAdViewableImpression = function(p4, p5) -- line: 90
		-- upvalues: buildGeometryFields (copy), TelemetryService (copy), t3 (copy), t1 (copy)
		local v16 = buildGeometryFields(p5.geometry)

		TelemetryService:LogEvent(t3, {
			standardizedFields = t1,
			customFields = {
				encryptedAdTrackingData = p4.encryptedAdTrackingData,
				tileType = p4.tileType,
				milestoneLabel = p5.milestoneLabel,
				viewabilitySessionStartTimestampMs = p5.viewabilitySessionStartTimestampMs,
				adWidth = v16.adWidth,
				adHeight = v16.adHeight,
				viewportWidth = v16.viewportWidth,
				viewportHeight = v16.viewportHeight,
				cumulative30PercentInViewDurationMs = p5.cumulative30PercentInViewDurationMs,
				cumulative50PercentInViewDurationMs = p5.cumulative50PercentInViewDurationMs,
				cumulative100PercentInViewDurationMs = p5.cumulative100PercentInViewDurationMs,
				maxContinuous30PercentInViewDurationMs = p5.maxContinuous30PercentInViewDurationMs,
				maxContinuous50PercentInViewDurationMs = p5.maxContinuous50PercentInViewDurationMs,
				maxContinuous100PercentInViewDurationMs = p5.maxContinuous100PercentInViewDurationMs
			}
		})
	end,
	logSponsoredAdUnload = function(p6, p7, s1: string) -- line: 114
		-- upvalues: buildGeometryFields (copy), TelemetryService (copy), t4 (copy), t1 (copy)
		local v20 = buildGeometryFields(p7.geometry)

		TelemetryService:LogEvent(t4, {
			standardizedFields = t1,
			customFields = {
				encryptedAdTrackingData = p6.encryptedAdTrackingData,
				tileType = p6.tileType,
				adWidth = v20.adWidth,
				adHeight = v20.adHeight,
				viewportWidth = v20.viewportWidth,
				viewportHeight = v20.viewportHeight,
				viewabilitySessionStartTimestampMs = p7.viewabilitySessionStartTimestampMs,
				cumulative30PercentInViewDurationMs = p7.cumulative30PercentInViewDurationMs,
				cumulative50PercentInViewDurationMs = p7.cumulative50PercentInViewDurationMs,
				cumulative100PercentInViewDurationMs = p7.cumulative100PercentInViewDurationMs,
				maxContinuous30PercentInViewDurationMs = p7.maxContinuous30PercentInViewDurationMs,
				maxContinuous50PercentInViewDurationMs = p7.maxContinuous50PercentInViewDurationMs,
				maxContinuous100PercentInViewDurationMs = p7.maxContinuous100PercentInViewDurationMs,
				dwellDurationMs = p7.dwellDurationMs,
				averagePercentSeen = p7.averagePercentSeen,
				minPercentSeen = p7.minPercentSeen,
				maxPercentSeen = p7.maxPercentSeen,
				averageOnScreenRealEstate = p7.averageOnScreenRealEstate,
				viewabilitySessionEndTimestampMs = p7.viewabilitySessionEndTimestampMs,
				unloadReason = s1
			}
		})
	end
}
