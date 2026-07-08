local Parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local Dash = require(Parent.Dash)

require(script.Parent.Parent.Types)

local getEventInfo = require(script.Parent.getEventInfo)
local optionallyLog = require(script.Parent.optionallyLog)
local reportDiagEvent = require(script.Parent.reportDiagEvent)
local getFormattedDiagEventInfo = require(script.Parent.getFormattedDiagEventInfo)

local function v7(p1) -- line: 13
	return `Fired Diag { p1.type }: { p1.name }, { p1.value }`
end

return function(t1: {[any]: any}) -- line: 17
	-- upvalues: Dash (copy), getEventInfo (copy), getFormattedDiagEventInfo (copy), reportDiagEvent (copy), optionallyLog (copy), v7 (copy)
	return function(p2, p3) -- line: 18
		-- upvalues: Dash (copy), getEventInfo (copy), t1 (copy), getFormattedDiagEventInfo (copy), reportDiagEvent (copy), optionallyLog (copy), v7 (copy)
		return Dash.pipe(getEventInfo(t1.eventList), getFormattedDiagEventInfo(), reportDiagEvent(t1.diagImpl), optionallyLog(t1.loggerImpl, v7))(p2, p3)
	end
end
