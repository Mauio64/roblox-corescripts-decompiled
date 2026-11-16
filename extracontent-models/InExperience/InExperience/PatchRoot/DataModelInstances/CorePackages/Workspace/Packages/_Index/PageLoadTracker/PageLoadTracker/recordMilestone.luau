local parent = script:FindFirstAncestor("PageLoadTracker").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local PageLoadConfig = require(script.Parent.PageLoadConfig)

require(script.Parent.PageLoadTypes)

local default = LoggingProtocol.default

function recordMilestone(p)
	default:logRobloxTelemetryEvent(
		PageLoadConfig.PAGE_LOAD_SUMMARY_CONFIG,
		{ default.StandardizedFields.addOsInfo },
		p
	)
end

return recordMilestone
