local ParentParent = script.Parent.Parent.Parent
local EventIngestService = game:GetService("EventIngestService")
local Analytics = require(ParentParent.Analytics)
local LoggingProtocol = require(ParentParent.LoggingProtocol)
local getPlatformTarget = Analytics.getPlatformTarget

return {
	EventStream = {
		setRBXEventStream = function(_, s1: string, s2: string, t1: {[any]: any}?) -- line: 13
			-- upvalues: EventIngestService (copy), getPlatformTarget (copy)
			local v10 = t1 or {}

			EventIngestService:SetRBXEventStream(getPlatformTarget(), s1, s2, v10)
		end
	},
	Telemetry = LoggingProtocol.default
}
