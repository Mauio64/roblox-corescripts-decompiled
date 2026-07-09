local Parent = script:FindFirstAncestor("PageLoadTracker").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local PageLoadConfig = require(script.Parent.PageLoadConfig)

require(script.Parent.PageLoadTypes)

local default = LoggingProtocol.default

function recordMilestone(p1) -- line: 10
	-- upvalues: default (copy), PageLoadConfig (copy)
	default:logRobloxTelemetryEvent(PageLoadConfig.PAGE_LOAD_SUMMARY_CONFIG, { default.StandardizedFields.addOsInfo }, p1)
end

return recordMilestone
