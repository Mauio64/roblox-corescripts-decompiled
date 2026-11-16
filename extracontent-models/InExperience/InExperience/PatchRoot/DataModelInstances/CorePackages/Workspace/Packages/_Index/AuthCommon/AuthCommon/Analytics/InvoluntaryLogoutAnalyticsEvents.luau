local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent
local dependencies = require(AuthCommon.dependencies)
local EventIngestService = game:GetService("EventIngestService")
local eventIngest = dependencies.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)
local AuthAnalytics = require(parent.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants

return {
	sendImmediatelyPageLoadEvent = function(origin: string, value: string?)
		local nows = {
			origin = origin,
			state = value or ""
		}
		nows[EventStreamConstants.EventTimingKeys.OsClock] = tostring(os.clock())
		nows[EventStreamConstants.EventTimingKeys.OsTime] = tostring(os.time())

		eventIngest:sendEventImmediately(
			EventStreamConstants.Context.InvoluntaryLogout,
			EventStreamConstants.AuthEventName.AuthPageLoad,
			nows
		)
	end
}
