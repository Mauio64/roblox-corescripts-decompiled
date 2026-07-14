local EventNames = require(script.EventNames)
local FunnelEventNames = require(script.FunnelEventNames)
local RecommendationSource = require(script.RecommendationSource)
local SessionManager = require(script.SessionManager)

require(script.Types)

local fireAnalyticsEvent = require(script.fireAnalyticsEvent)
local fireFunnelAnalyticsEvent = require(script.fireFunnelAnalyticsEvent)
local reportMomentSkip = require(script.reportMomentSkip)

return {
	EventNames = EventNames,
	FunnelEventNames = FunnelEventNames,
	RecommendationSource = RecommendationSource,
	SessionManager = SessionManager,
	fireAnalyticsEvent = fireAnalyticsEvent,
	fireFunnelAnalyticsEvent = fireFunnelAnalyticsEvent,
	reportMomentSkip = reportMomentSkip
}
