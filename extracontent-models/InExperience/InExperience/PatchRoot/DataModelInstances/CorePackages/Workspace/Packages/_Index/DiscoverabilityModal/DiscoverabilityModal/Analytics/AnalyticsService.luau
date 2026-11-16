local parent = script:FindFirstAncestor("DiscoverabilityModal").Parent
local EventIngestService = game:GetService("EventIngestService")

local Analytics = require(parent.Analytics)
local analytics = Analytics.Analytics.new(game:GetService("RbxAnalyticsService"))
local setupSetRbxEventStream = require(script.Parent.setupSetRbxEventStream)

return {
	EventStream = {
		setRBXEventStream = setupSetRbxEventStream(EventIngestService)
	},
	Diag = analytics.Diag
}
