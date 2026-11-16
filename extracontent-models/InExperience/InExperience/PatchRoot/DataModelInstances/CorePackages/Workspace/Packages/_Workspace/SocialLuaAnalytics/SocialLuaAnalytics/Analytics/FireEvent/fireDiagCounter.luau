local parent = script.Parent.Parent.Parent.Parent

local Dash = require(parent.Dash)

require(script.Parent.Parent.Types)
local getEventInfo = require(script.Parent.getEventInfo)
local optionallyLog = require(script.Parent.optionallyLog)

local reportCounter = require(script.Parent.reportCounter)

local function fn(p)
	return "Fired diagCounter: " .. p.name .. ", count: " .. (p.count and tostring(p.count) or "1")
end

return function(data)
	return function(p)
		return Dash.pipe(getEventInfo(data.eventList), optionallyLog(data.loggerImpl, fn), reportCounter(data.diagImpl))(p)
	end
end
