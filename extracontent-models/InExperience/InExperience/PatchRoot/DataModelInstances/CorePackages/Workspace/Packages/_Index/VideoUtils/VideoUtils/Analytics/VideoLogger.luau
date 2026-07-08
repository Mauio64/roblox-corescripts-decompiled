local TelemetryService = game:GetService("TelemetryService")
local VideoUtils = script:FindFirstAncestor("VideoUtils")
local VideoUtilsParent = VideoUtils.Parent
local Cryo = require(VideoUtilsParent.Cryo)
local LoggingProtocol = require(VideoUtilsParent.LoggingProtocol)
local reportWarning = require(VideoUtilsParent.DiscoveryAnalytics).Points.reportWarning
local t = require(VideoUtilsParent.t)

require(VideoUtils.Analytics.VideoAnalyticsTypes)

local VideoEngagementEvents = require(VideoUtils.Analytics.Enums).VideoEngagementEvents
local v9 = game:DefineFastInt("VideoEngagementEventHundredthsPercent", 0)
local t1 = {}
local v11 = t.strictInterface({
	videoAssetId = t.string,
	source = t.string,
	sourceId = t.string,
	impressionId = t.optional(t.string),
	playbackSessionId = t.optional(t.string),
	videoAssetDuration = t.optional(t.number),
	isVisible = t.optional(t.boolean),
	isAudible = t.optional(t.boolean),
	isFullscreen = t.optional(t.boolean),
	volumeLevel = t.optional(t.number)
})
local v12 = t.strictInterface({
	loadTime = t.optional(t.number),
	scrubStartTime = t.optional(t.number),
	scrubEndTime = t.optional(t.number),
	destination = t.optional(t.string)
})
local t2 = {
	eventName = "videoEngagementEvent",
	description = "Fire when video engagement event is triggered",
	links = "",
	backends = {
		LoggingProtocol.TelemetryBackends.Points,
		LoggingProtocol.TelemetryBackends.EventIngest
	},
	throttlingPercentage = v9,
	lastUpdated = {
		25,
		6,
		25
	}
}

return {
	reportVideoAction = function(p1, s1: string?, p2, p3) -- line: 59
		-- upvalues: v11 (copy), reportWarning (copy), LoggingProtocol (copy), v12 (copy), Cryo (copy), VideoEngagementEvents (copy), t1 (copy), t2 (copy), TelemetryService (copy)
		local v18, v19 = v11(p2)

		if not v18 then
			reportWarning(LoggingProtocol.default, "EventLogging", v19)
		end

		if p3 then
			local v20, v21 = v12(p3)

			if not v20 then
				reportWarning(LoggingProtocol.default, "EventLogging", v21)
			end
		end

		local v22 = Cryo.Dictionary.join(p2, {
			videoEngagementEventType = VideoEngagementEvents.VIDEO_ACTION,
			actionType = p1
		}, p3 or t1)
		local v23 = Cryo.Dictionary.join(t2, {
			eventContext = s1
		})

		TelemetryService:LogEvent(v23, {
			standardizedFields = {
				"addSessionInfo",
				LoggingProtocol.StandardizedFields.addOsInfo
			},
			customFields = v22
		})
	end
}
