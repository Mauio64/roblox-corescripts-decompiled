local CorePackages = game:GetService("CorePackages")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@luauforge/bundled/dHL")
require(CorePackages.Packages.Thumbnailing)
require("@luauforge/bundled/dMc")

return {
	AnimationTrackWithConnectionsTypes = {
		ToolHold = "ToolHold",
		LookAround = "LookAround",
		Mood = "Mood",
		MainBody = "MainBody",
		CameraStream = "CameraStream"
	}
}
