local TelemetryService = game:GetService("TelemetryService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Cryo")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/LoggingProtocol")

local reportWarning = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/DiscoveryAnalytics").Points.reportWarning
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/t")

require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/VideoAnalyticsTypes")
local videoEngagementEvents = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/Enums").VideoEngagementEvents

local defineFastInt = game:DefineFastInt("VideoEngagementEventHundredthsPercent", 0)

local v5 = {}

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

local v6 = {
	eventName = "videoEngagementEvent",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 6, 25 },
	description = "Fire when video engagement event is triggered",
	links = ""
}

return {
	reportVideoAction = function(p2, p3, p4, p5)
		local v7, v8 = strictInterface(p4)

		if not v7 then
			reportWarning(LoggingProtocol.default, "EventLogging", v8)
		end

		if p5 then
			local v9, v10 = strictInterface2(p5)

			if not v9 then
				reportWarning(LoggingProtocol.default, "EventLogging", v10)
			end
		end

		local joined = Cryo.Dictionary.join(
			p4,
			{
				videoEngagementEventType = videoEngagementEvents.VIDEO_ACTION,
				actionType = p2
			},
			p5 or v5
		)

		TelemetryService:LogEvent(Cryo.Dictionary.join(v6, { eventContext = p3 }), {
			standardizedFields = { "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo },
			customFields = joined
		})
	end
}
