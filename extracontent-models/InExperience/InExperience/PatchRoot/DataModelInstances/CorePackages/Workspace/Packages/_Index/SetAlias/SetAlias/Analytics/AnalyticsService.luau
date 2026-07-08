local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Analytics = dependencies.Analytics
local v6 = Analytics.Analytics.new(RbxAnalyticsService)
local getPlatformTarget = Analytics.getPlatformTarget

return {
	Diag = v6.Diag,
	EventStream = {
		setRBXEventStream = function(_, s1: string, s2: string, t1: {[any]: any}?) -- line: 13
			-- upvalues: EventIngestService (copy), getPlatformTarget (copy)
			local v12 = t1 or {}

			EventIngestService:SetRBXEventStream(getPlatformTarget(), s1, s2, v12)
		end
	}
}
