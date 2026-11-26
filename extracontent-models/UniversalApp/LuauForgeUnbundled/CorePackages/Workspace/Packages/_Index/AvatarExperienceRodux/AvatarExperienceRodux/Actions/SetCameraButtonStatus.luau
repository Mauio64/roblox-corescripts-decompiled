local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/ArgCheck")
return require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux").makeActionCreator("SetCameraButtonStatus", function(p2)
	ArgCheck.isType(p2, "boolean", "Actions.SetCameraButton.status")
	return { status = p2 }
end)
