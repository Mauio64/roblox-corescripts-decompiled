local Parent = script:FindFirstAncestor("EditProfile").Parent
local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Analytics = require(Parent.Analytics)
local v5 = Analytics.Analytics.new(RbxAnalyticsService)
local getPlatformTarget = Analytics.getPlatformTarget

return {
	Diag = v5.Diag,
	EventStream = {
		setRBXEventStream = function(_, s1: string, s2: string, t1: {[any]: any}?) -- line: 13
			-- upvalues: EventIngestService (copy), getPlatformTarget (copy)
			local v11 = t1 or {}

			EventIngestService:SetRBXEventStream(getPlatformTarget(), s1, s2, v11)
		end
	}
}
