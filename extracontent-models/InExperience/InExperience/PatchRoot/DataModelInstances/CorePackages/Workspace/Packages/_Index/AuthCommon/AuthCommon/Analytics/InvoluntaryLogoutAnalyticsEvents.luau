local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local dependencies = require(AuthCommon.dependencies)
local EventIngestService = game:GetService("EventIngestService")
local v5 = dependencies.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)
local EventStreamConstants = require(AuthCommonParent.AuthAnalytics).EventStreamConstants

return {
	sendImmediatelyPageLoadEvent = function(s1: string, s2: string?) -- line: 10
		-- upvalues: EventStreamConstants (copy), v5 (copy)
		local t1 = {
			origin = s1,
			state = s2 or "",
			[EventStreamConstants.EventTimingKeys.OsClock] = tostring(os.clock()),
			[EventStreamConstants.EventTimingKeys.OsTime] = tostring(os.time())
		}

		v5:sendEventImmediately(EventStreamConstants.Context.InvoluntaryLogout, EventStreamConstants.AuthEventName.AuthPageLoad, t1)
	end
}
