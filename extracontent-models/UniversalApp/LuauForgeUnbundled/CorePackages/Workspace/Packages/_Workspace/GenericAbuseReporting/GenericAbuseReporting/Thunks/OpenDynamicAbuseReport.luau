local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/CentralOverlay").Actions.SetCentralOverlay

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")

return function(p2)
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.DynamicAbuseReport, p2))
	end
end
