local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent

local Dash = require(parent.Dash)

require(script.Parent.Parent.Types)
local getEventInfo = require(script.Parent.getEventInfo)
local optionallyLog = require(script.Parent.optionallyLog)

local reportDiagEvent = require(script.Parent.reportDiagEvent)
local getFormattedDiagEventInfo = require(script.Parent.getFormattedDiagEventInfo)

local function fn(data)
	return `Fired Diag {data.type}: {data.name}, {data.value}`
end

return function(data)
	return function(p, p2)
		return Dash.pipe(
			getEventInfo(data.eventList),
			getFormattedDiagEventInfo(),
			reportDiagEvent(data.diagImpl),
			optionallyLog(data.loggerImpl, fn)
		)(
			p,
			p2
		)
	end
end
