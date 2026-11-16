local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/dependencies")
local EventIngestService = game:GetService("EventIngestService")
local eventIngest = dependencies.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)
local eventStreamConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AuthAnalytics").EventStreamConstants

return {
	sendImmediatelyPageLoadEvent = function(p2, value)
		local nows = {
			origin = p2,
			state = value or ""
		}
		nows[eventStreamConstants.EventTimingKeys.OsClock] = tostring(os.clock())
		nows[eventStreamConstants.EventTimingKeys.OsTime] = tostring(os.time())

		eventIngest:sendEventImmediately(
			eventStreamConstants.Context.InvoluntaryLogout,
			eventStreamConstants.AuthEventName.AuthPageLoad,
			nows
		)
	end
}
