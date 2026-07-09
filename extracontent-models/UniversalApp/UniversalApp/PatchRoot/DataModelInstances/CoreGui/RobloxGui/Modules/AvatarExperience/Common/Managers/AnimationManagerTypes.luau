local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
require(CorePackages.Packages.Thumbnailing)
require(Modules.AvatarExperience.Common.Types)

return {
	AnimationTrackWithConnectionsTypes = {
		ToolHold = "ToolHold",
		LookAround = "LookAround",
		Mood = "Mood",
		MainBody = "MainBody",
		CameraStream = "CameraStream"
	}
}
