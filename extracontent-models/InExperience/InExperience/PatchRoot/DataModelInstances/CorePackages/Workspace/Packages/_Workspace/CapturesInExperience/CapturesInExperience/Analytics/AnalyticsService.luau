local parent = script.Parent.Parent.Parent

local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local Analytics = require(parent.Analytics)
local LoggingProtocol = require(parent.LoggingProtocol)

local analytics = Analytics.Analytics.new(RbxAnalyticsService)
local getPlatformTarget = Analytics.getPlatformTarget

return {
	Diag = analytics.Diag,
	EventStream = {
		setRBXEventStream = function(_, p: string, p2: string, options)
			EventIngestService:SetRBXEventStream(getPlatformTarget(), p, p2, options or {})
		end
	},
	Telemetry = LoggingProtocol.default
}
