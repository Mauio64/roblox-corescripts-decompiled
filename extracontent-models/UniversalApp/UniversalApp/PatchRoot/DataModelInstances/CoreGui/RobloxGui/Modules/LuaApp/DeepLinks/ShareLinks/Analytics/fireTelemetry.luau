local CorePackages = game:GetService("CorePackages")
local SocialLuaAnalytics = require(CorePackages.Workspace.Packages.SocialLuaAnalytics)
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local fireTelemetry = SocialLuaAnalytics.Analytics.FireEvent.fireTelemetry

require(script.Parent.EventNames)

local TelemetryActionList = require(script.Parent.TelemetryActionList)
local v6 = fireTelemetry({
	telemetryImpl = LoggingProtocol.default,
	eventList = TelemetryActionList
})

return function(p1, p2) -- line: 16
	-- upvalues: TelemetryActionList (copy), v6 (copy)
	if TelemetryActionList[p1] then
		v6(p1, p2)
	end
end
