local CorePackages = game:GetService("CorePackages")
local ExperimentLayers = require(CorePackages.Workspace.Packages.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers

game:DefineFastString("ExitModalIXPLayer", AppUserLayers.ExperienceMenuExitModalLayer)

return function()
	return game:GetFastString("ExitModalIXPLayer")
end
