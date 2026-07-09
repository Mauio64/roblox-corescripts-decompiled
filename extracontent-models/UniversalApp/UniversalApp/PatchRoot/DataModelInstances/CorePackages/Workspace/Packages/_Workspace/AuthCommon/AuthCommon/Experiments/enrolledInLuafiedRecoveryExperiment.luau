local Parent = script:FindFirstAncestor("AuthCommon").Parent
local IXPServiceWrapper = require(Parent.IXPServiceWrapper).IXPServiceWrapper
local AppBtidLayers = require(Parent.ExperimentLayers).AppBtidLayers

local function enrolledInLuafiedRecoveryExperiment() -- line: 7
	-- upvalues: IXPServiceWrapper (copy), AppBtidLayers (copy)
	local BTIDLayerData = IXPServiceWrapper:GetBTIDLayerData(AppBtidLayers.AccountRecoveryUILayer)

	IXPServiceWrapper:LogBrowserTrackerLayerExposure(AppBtidLayers.AccountRecoveryUILayer)

	if not BTIDLayerData then
		return false
	end

	return BTIDLayerData.shouldShowLuafiedRecoveryFlow or false
end

return enrolledInLuafiedRecoveryExperiment
