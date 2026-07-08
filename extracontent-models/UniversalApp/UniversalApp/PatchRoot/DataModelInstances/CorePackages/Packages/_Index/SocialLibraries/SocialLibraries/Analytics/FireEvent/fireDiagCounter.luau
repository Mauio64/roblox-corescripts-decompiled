require(script.Parent.Types)

local getEventInfo = require(script.Parent.getEventInfo)
local optionallyLog = require(script.Parent.optionallyLog)
local compose = require(script.Parent.Parent.Parent.RoduxTools.compose)
local reportCounter = require(script.Parent.reportCounter)

local function v5(p1) -- line: 8
	return "Fired diagCounter: " .. p1.name .. ", count: " .. (p1.count and tostring(p1.count) or "1")
end

return function(t1: {[any]: any}) -- line: 15
	-- upvalues: compose (copy), reportCounter (copy), optionallyLog (copy), v5 (copy), getEventInfo (copy)
	return function(p2) -- line: 16
		-- upvalues: compose (copy), reportCounter (copy), t1 (copy), optionallyLog (copy), v5 (copy), getEventInfo (copy)
		return compose(reportCounter(t1.diagImpl), optionallyLog(t1.loggerImpl, v5), getEventInfo(t1.eventList))(p2)
	end
end
