require(script.Parent.Types)
local getEventInfo = require(script.Parent.getEventInfo)
local optionallyLog = require(script.Parent.optionallyLog)
local compose = require(script.Parent.Parent.Parent.RoduxTools.compose)
local reportCounter = require(script.Parent.reportCounter)

local function fn(p)
	return "Fired diagCounter: " .. p.name .. ", count: " .. (p.count and tostring(p.count) or "1")
end

return function(data)
	return function(p)
		return compose(reportCounter(data.diagImpl), optionallyLog(data.loggerImpl, fn), getEventInfo(data.eventList))(p)
	end
end
