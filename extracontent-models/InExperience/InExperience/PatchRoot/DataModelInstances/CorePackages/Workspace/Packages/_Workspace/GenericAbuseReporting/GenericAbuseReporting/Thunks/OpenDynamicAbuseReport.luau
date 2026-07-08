local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local CentralOverlayType = require(GenericAbuseReportingParent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(GenericAbuseReportingParent.CentralOverlay).Actions.SetCentralOverlay

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
require(GenericAbuseReporting.Enums.AbuseVector)

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
	return function(p1) -- line: 23
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), t1 (copy)
		p1:dispatch(SetCentralOverlay(CentralOverlayType.DynamicAbuseReport, t1))
	end
end
