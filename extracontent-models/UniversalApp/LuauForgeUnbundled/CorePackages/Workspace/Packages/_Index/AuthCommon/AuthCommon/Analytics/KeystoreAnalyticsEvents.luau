local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/dependencies")
local KeystoreEventConstants = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Analytics/KeystoreEventConstants")
local EventIngestService = game:GetService("EventIngestService")
local eventIngest = dependencies.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)

return {
	sendPageLoadEvent = function(p2, value)
		eventIngest:sendEventDeferred(KeystoreEventConstants.ctx.keystoreLogin, KeystoreEventConstants.eventNames.pageLoad, {
			origin = p2,
			state = value or ""
		})
	end
}
