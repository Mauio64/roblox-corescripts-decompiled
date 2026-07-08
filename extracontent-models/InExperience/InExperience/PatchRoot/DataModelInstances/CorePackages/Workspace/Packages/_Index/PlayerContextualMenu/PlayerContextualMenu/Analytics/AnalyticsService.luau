local ParentParent = script.Parent.Parent.Parent
local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Analytics = require(ParentParent.Analytics)
local v5 = Analytics.Analytics.new(RbxAnalyticsService)
local getPlatformTarget = Analytics.getPlatformTarget

return {
	Diag = v5.Diag,
	EventStream = {
		setRBXEventStream = function(_, s1: string, s2: string, t1: {[any]: any}?) -- line: 14
			-- upvalues: EventIngestService (copy), getPlatformTarget (copy)
			local v11 = t1 or {}

			EventIngestService:SetRBXEventStream(getPlatformTarget(), s1, s2, v11)
		end,
		sendEventDeferred = function(_, s3: string, s4: string, t2: {[any]: any}?) -- line: 19
			-- upvalues: EventIngestService (copy), getPlatformTarget (copy)
			local v16 = t2 or {}

			EventIngestService:SendEventDeferred(getPlatformTarget(), s3, s4, v16)
		end
	}
}
