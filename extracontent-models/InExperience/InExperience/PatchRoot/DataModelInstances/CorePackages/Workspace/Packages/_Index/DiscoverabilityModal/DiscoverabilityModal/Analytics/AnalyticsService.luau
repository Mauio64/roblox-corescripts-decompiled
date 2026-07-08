local Parent = script:FindFirstAncestor("DiscoverabilityModal").Parent
local EventIngestService = game:GetService("EventIngestService")
local v3 = require(Parent.Analytics).Analytics.new(game:GetService("RbxAnalyticsService"))

return {
	EventStream = {
		setRBXEventStream = require(script.Parent.setupSetRbxEventStream)(EventIngestService)
	},
	Diag = v3.Diag
}
