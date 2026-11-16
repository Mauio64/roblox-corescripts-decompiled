local AuthCommon = script:FindFirstAncestor("AuthCommon")
local dependencies = require(AuthCommon.dependencies)
local KeystoreEventConstants = require(script.Parent.KeystoreEventConstants)
local EventIngestService = game:GetService("EventIngestService")
local eventIngest = dependencies.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)

return {
	sendPageLoadEvent = function(origin: string, value: string?)
		eventIngest:sendEventDeferred(
			KeystoreEventConstants.ctx.keystoreLogin,
			KeystoreEventConstants.eventNames.pageLoad,
			{
				origin = origin,
				state = value or ""
			}
		)
	end
}
