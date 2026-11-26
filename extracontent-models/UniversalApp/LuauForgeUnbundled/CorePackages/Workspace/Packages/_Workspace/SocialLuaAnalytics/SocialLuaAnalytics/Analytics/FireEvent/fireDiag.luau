local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Dash")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Types")
local getEventInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/getEventInfo")
local optionallyLog = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/optionallyLog")

local reportDiagEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/reportDiagEvent")
local getFormattedDiagEventInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/getFormattedDiagEventInfo")

local function fn(data)
	return `Fired Diag {data.type}: {data.name}, {data.value}`
end

return function(data)
	return function(p2, p3)
		return Dash.pipe(
			getEventInfo(data.eventList),
			getFormattedDiagEventInfo(),
			reportDiagEvent(data.diagImpl),
			optionallyLog(data.loggerImpl, fn)
		)(
			p2,
			p3
		)
	end
end
