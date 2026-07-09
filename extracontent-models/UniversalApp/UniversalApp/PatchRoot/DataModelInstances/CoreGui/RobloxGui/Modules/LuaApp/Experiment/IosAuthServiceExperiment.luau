local CorePackages = game:GetService("CorePackages")
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local useBrowserTrackerExperiment = require(CorePackages.Packages.RoactAppExperiment).useBrowserTrackerExperiment

local function useIosAuthServiceExperiment() -- line: 9
	-- upvalues: useBrowserTrackerExperiment (copy), AppBtidLayers (copy)
	return (useBrowserTrackerExperiment({ AppBtidLayers.IosPasswordSavingLayer }, function(p1) -- line: 12
		-- upvalues: AppBtidLayers (copy)
		return {
			enableNewIosPasswordSaving = (p1[AppBtidLayers.IosPasswordSavingLayer] or {}).enableNewIosPasswordSaving or false
		}
	end))
end

return {
	useIsIosAuthServiceEnabled = function() -- line: 23
		-- upvalues: useBrowserTrackerExperiment (copy), AppBtidLayers (copy)
		return useBrowserTrackerExperiment({ AppBtidLayers.IosPasswordSavingLayer }, function(p2) -- line: 12
			-- upvalues: AppBtidLayers (copy)
			return {
				enableNewIosPasswordSaving = (p2[AppBtidLayers.IosPasswordSavingLayer] or {}).enableNewIosPasswordSaving or false
			}
		end).enableNewIosPasswordSaving
	end
}
