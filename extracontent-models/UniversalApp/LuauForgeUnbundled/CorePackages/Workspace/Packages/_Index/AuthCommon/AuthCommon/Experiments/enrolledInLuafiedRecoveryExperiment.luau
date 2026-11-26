local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/IxpServiceWrapper").IXPServiceWrapper
local appBtidLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/ExperimentLayers").AppBtidLayers

local function enrolledInLuafiedRecoveryExperiment()
	local btidLayerData = ixpServiceWrapper:GetBTIDLayerData(appBtidLayers.AccountRecoveryUILayer)
	ixpServiceWrapper:LogBrowserTrackerLayerExposure(appBtidLayers.AccountRecoveryUILayer)

	if btidLayerData then
		return btidLayerData.shouldShowLuafiedRecoveryFlow or false
	end

	return false
end

return enrolledInLuafiedRecoveryExperiment
