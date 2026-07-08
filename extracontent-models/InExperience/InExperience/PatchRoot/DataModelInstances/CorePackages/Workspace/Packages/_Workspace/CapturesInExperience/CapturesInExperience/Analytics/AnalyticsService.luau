local ParentParent = script.Parent.Parent.Parent
local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Analytics = require(ParentParent.Analytics)
local LoggingProtocol = require(ParentParent.LoggingProtocol)
local v6 = Analytics.Analytics.new(RbxAnalyticsService)
local getPlatformTarget = Analytics.getPlatformTarget

return {
	Diag = v6.Diag,
	EventStream = {
		setRBXEventStream = function(_, s1: string, s2: string, t1: {[any]: any}?) -- line: 15
			-- upvalues: EventIngestService (copy), getPlatformTarget (copy)
			local v12 = t1 or {}

			EventIngestService:SetRBXEventStream(getPlatformTarget(), s1, s2, v12)
		end
	},
	Telemetry = LoggingProtocol.default
}
