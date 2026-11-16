local TelemetryService = game:GetService("TelemetryService")
local VideoUtils = script:FindFirstAncestor("VideoUtils")

local parent = VideoUtils.Parent
local Cryo = require(parent.Cryo)
local LoggingProtocol = require(parent.LoggingProtocol)

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local reportWarning = DiscoveryAnalytics.Points.reportWarning
local t = require(parent.t)

require(VideoUtils.Analytics.VideoAnalyticsTypes)
local Enums = require(VideoUtils.Analytics.Enums)
local VideoEngagementEvents = Enums.VideoEngagementEvents

local defineFastInt = game:DefineFastInt("VideoEngagementEventHundredthsPercent", 0)

local v = {}

local strictInterface = t.strictInterface({
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

local strictInterface2 = t.strictInterface({
	loadTime = t.optional(t.number),
	scrubStartTime = t.optional(t.number),
	scrubEndTime = t.optional(t.number),
	destination = t.optional(t.string)
})

local v2 = {
	eventName = "videoEngagementEvent",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 6, 25 },
	description = "Fire when video engagement event is triggered",
	links = ""
}

return {
	reportVideoAction = function(actionType, eventContext: string?, p, p2)
		local v3, v4 = strictInterface(p)

		if not v3 then
			reportWarning(LoggingProtocol.default, "EventLogging", v4)
		end

		if p2 then
			local v5, v6 = strictInterface2(p2)

			if not v5 then
				reportWarning(LoggingProtocol.default, "EventLogging", v6)
			end
		end

		local joined = Cryo.Dictionary.join(
			p,
			{
				videoEngagementEventType = VideoEngagementEvents.VIDEO_ACTION,
				actionType = actionType
			},
			p2 or v
		)

		TelemetryService:LogEvent(Cryo.Dictionary.join(v2, { eventContext = eventContext }), {
			standardizedFields = { "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo },
			customFields = joined
		})
	end
}
