local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/LoggingProtocol")
local PageLoadConfig = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/PageLoadConfig")

require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/PageLoadTypes")

local default = LoggingProtocol.default

function LUAUFORGE_MODULE_GLOBALS_dCT_recordMilestone(p2)
	default:logRobloxTelemetryEvent(
		PageLoadConfig.PAGE_LOAD_SUMMARY_CONFIG,
		{ default.StandardizedFields.addOsInfo },
		p2
	)
end

return LUAUFORGE_MODULE_GLOBALS_dCT_recordMilestone
