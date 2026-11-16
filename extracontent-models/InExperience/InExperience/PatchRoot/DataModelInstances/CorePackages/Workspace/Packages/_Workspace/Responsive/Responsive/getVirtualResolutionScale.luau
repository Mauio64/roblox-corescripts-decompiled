local parent = script:FindFirstAncestor("Responsive").Parent
local AppCommonLib = require(parent.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface
local SharedFlags = require(parent.SharedFlags)
local GetFFlagApplyResolutionScale = SharedFlags.GetFFlagApplyResolutionScale

function getVirtualResolutionScale(): nil | number
	if not GetFFlagApplyResolutionScale() then
		return nil
	end

	return if isTenFootInterface() then 1.5 else 1
end

return getVirtualResolutionScale
