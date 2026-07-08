local ParentParent = script.Parent.Parent.Parent.Parent
local Dash = require(ParentParent.Dash)

require(script.Parent.Parent.Types)

local getEventInfo = require(script.Parent.getEventInfo)
local optionallyLog = require(script.Parent.optionallyLog)
local reportCounter = require(script.Parent.reportCounter)

local function v6(p1) -- line: 12
	return "Fired diagCounter: " .. p1.name .. ", count: " .. (p1.count and tostring(p1.count) or "1")
end

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: Dash (copy), getEventInfo (copy), optionallyLog (copy), v6 (copy), reportCounter (copy)
	return function(p2) -- line: 24
		-- upvalues: Dash (copy), getEventInfo (copy), t1 (copy), optionallyLog (copy), v6 (copy), reportCounter (copy)
		return Dash.pipe(getEventInfo(t1.eventList), optionallyLog(t1.loggerImpl, v6), reportCounter(t1.diagImpl))(p2)
	end
end
