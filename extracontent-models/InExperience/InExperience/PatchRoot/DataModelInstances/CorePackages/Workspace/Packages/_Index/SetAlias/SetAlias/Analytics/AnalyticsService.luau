local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)

local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local analytics = dependencies.Analytics
local analytics2 = analytics.Analytics.new(RbxAnalyticsService)
local getPlatformTarget = analytics.getPlatformTarget

return {
	Diag = analytics2.Diag,
	EventStream = {
		setRBXEventStream = function(_, p: string, p2: string, options)
			EventIngestService:SetRBXEventStream(getPlatformTarget(), p, p2, options or {})
		end
	}
}
