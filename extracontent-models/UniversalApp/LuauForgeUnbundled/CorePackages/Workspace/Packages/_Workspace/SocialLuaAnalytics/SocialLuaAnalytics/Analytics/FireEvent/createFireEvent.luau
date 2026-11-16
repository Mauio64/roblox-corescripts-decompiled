local fireEventStream = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/fireEventStream")
local fireDiag = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/fireDiag")
local fireTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/fireTelemetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Types")

local function setupFireEvent(data, data2)
	local v5

	if data.analytics.EventStream and data2.EventStream then
		v5 = fireEventStream({
			eventStreamImpl = data.analytics.EventStream,
			eventList = data2.EventStream,
			infoForAllEvents = data.infoForAllEvents,
			getInfoForAllEvents = data.getInfoForAllEvents,
			loggerImpl = data.loggerImpl
		})
	else
		v5 = nil
	end

	local v6

	if data.analytics.Diag and data2.Diag then
		v6 = fireDiag({
			diagImpl = data.analytics.Diag,
			eventList = data2.Diag,
			loggerImpl = data.loggerImpl
		})
	else
		v6 = nil
	end

	local v7

	if data.analytics.Telemetry and data2.Telemetry then
		v7 = fireTelemetry({
			telemetryImpl = data.analytics.Telemetry,
			eventList = data2.Telemetry,
			getInfoForAllEvents = data.getInfoForAllEvents,
			loggerImpl = data.loggerImpl
		})
	else
		v7 = nil
	end

	return function(p2, p3)
		if v6 and data2.Diag and data2.Diag[p2] then
			v6(p2, p3)
		end

		if v5 and data2.EventStream and data2.EventStream[p2] then
			v5(p2, p3)
		end

		if v7 and data2.Telemetry and data2.Telemetry[p2] then
			v7(p2, p3)
		end

		return p2, p3
	end
end

local function createFireEvent(p2)
	return function(p3)
		return setupFireEvent(p3, p2)
	end
end

return createFireEvent
