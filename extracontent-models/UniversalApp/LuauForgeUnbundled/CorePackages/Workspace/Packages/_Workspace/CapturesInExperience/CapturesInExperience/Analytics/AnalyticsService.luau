local EventIngestService = game:GetService("EventIngestService")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/Analytics")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/LoggingProtocol")

local getPlatformTarget = Analytics.getPlatformTarget

return {
	EventStream = {
		setRBXEventStream = function(self, p3, p4, options)
			EventIngestService:SetRBXEventStream(getPlatformTarget(), p3, p4, options or {})
		end
	},
	Telemetry = LoggingProtocol.default
}
