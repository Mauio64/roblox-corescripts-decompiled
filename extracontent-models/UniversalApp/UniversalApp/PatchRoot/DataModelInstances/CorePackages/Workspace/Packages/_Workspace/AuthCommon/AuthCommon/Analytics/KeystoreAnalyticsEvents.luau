local AuthCommon = script:FindFirstAncestor("AuthCommon")
local dependencies = require(AuthCommon.dependencies)
local KeystoreEventConstants = require(script.Parent.KeystoreEventConstants)
local EventIngestService = game:GetService("EventIngestService")
local v5 = dependencies.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)

return {
	sendPageLoadEvent = function(s1: string, s2: string?) -- line: 8
		-- upvalues: v5 (copy), KeystoreEventConstants (copy)
		v5:sendEventDeferred(KeystoreEventConstants.ctx.keystoreLogin, KeystoreEventConstants.eventNames.pageLoad, {
			origin = s1,
			state = s2 or ""
		})
	end
}
