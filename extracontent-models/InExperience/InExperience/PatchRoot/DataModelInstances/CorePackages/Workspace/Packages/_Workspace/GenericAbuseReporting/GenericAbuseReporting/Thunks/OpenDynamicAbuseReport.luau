local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
require(GenericAbuseReporting.Enums.AbuseVector)

return function(p)
	return function(object)
		object:dispatch(SetCentralOverlay(CentralOverlayType.DynamicAbuseReport, p))
	end
end
