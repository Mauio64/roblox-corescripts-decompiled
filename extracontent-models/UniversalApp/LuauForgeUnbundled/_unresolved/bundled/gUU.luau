local CorePackages = game:GetService("CorePackages")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@luauforge/bundled/dKU")
require(CorePackages.Packages.Thumbnailing)
require("@luauforge/bundled/dPs")

return {
	AnimationTrackWithConnectionsTypes = {
		ToolHold = "ToolHold",
		LookAround = "LookAround",
		Mood = "Mood",
		MainBody = "MainBody",
		CameraStream = "CameraStream"
	}
}
