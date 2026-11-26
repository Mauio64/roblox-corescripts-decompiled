local CorePackages = game:GetService("CorePackages")
local appBtidLayers = require("@luauforge/bundled/dPQ").AppBtidLayers
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useBrowserTrackerExperiment = RoactAppExperiment.useBrowserTrackerExperiment

local function useIosAuthServiceExperiment()
	return (useBrowserTrackerExperiment({ appBtidLayers.IosPasswordSavingLayer }, function(p2)
		return {
			enableNewIosPasswordSaving = (p2[appBtidLayers.IosPasswordSavingLayer] or {}).enableNewIosPasswordSaving or false
		}
	end))
end

return {
	useIsIosAuthServiceEnabled = function()
		return useBrowserTrackerExperiment({ appBtidLayers.IosPasswordSavingLayer }, function(p2)
			return {
				enableNewIosPasswordSaving = (p2[appBtidLayers.IosPasswordSavingLayer] or {}).enableNewIosPasswordSaving or false
			}
		end).enableNewIosPasswordSaving
	end
}
