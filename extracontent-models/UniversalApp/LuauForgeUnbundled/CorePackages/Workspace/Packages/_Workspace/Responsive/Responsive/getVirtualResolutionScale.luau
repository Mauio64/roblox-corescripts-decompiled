local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/AppCommonLib").isTenFootInterface
local getFFlagApplyResolutionScale = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/SharedFlags").GetFFlagApplyResolutionScale

function LUAUFORGE_MODULE_GLOBALS_Aq_getVirtualResolutionScale(): nil | number
	if not getFFlagApplyResolutionScale() then
		return nil
	end

	if isTenFootInterface() then
		return 1.5
	end

	return 1
end

return LUAUFORGE_MODULE_GLOBALS_Aq_getVirtualResolutionScale
