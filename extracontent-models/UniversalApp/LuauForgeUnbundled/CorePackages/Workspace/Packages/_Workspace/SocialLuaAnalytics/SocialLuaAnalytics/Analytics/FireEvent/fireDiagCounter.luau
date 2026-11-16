local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Dash")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Types")
local getEventInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/getEventInfo")
local optionallyLog = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/optionallyLog")

local reportCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/reportCounter")

local function fn(p2)
	return "Fired diagCounter: " .. p2.name .. ", count: " .. (p2.count and tostring(p2.count) or "1")
end

return function(data)
	return function(p2)
		return Dash.pipe(getEventInfo(data.eventList), optionallyLog(data.loggerImpl, fn), reportCounter(data.diagImpl))(p2)
	end
end
