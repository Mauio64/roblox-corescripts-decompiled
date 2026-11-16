local CorePackages = game:GetService("CorePackages")
local ExperimentLayers = require(CorePackages.Workspace.Packages.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers

game:DefineFastString("InExperienceMenuIXPLayer", AppUserLayers.ExperienceMenuSettingsExposureLayer)

return function()
	return game:GetFastString("InExperienceMenuIXPLayer")
end
