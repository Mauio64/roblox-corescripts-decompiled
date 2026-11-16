local parent = script:FindFirstAncestor("AuthCommon").Parent

local IXPServiceWrapper = require(parent.IXPServiceWrapper)
local ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
local ExperimentLayers = require(parent.ExperimentLayers)
local AppBtidLayers = ExperimentLayers.AppBtidLayers

local function enrolledInLuafiedRecoveryExperiment()
	local btidLayerData = ixpServiceWrapper:GetBTIDLayerData(AppBtidLayers.AccountRecoveryUILayer)
	ixpServiceWrapper:LogBrowserTrackerLayerExposure(AppBtidLayers.AccountRecoveryUILayer)

	if btidLayerData then
		return btidLayerData.shouldShowLuafiedRecoveryFlow or false
	end

	return false
end

return enrolledInLuafiedRecoveryExperiment
