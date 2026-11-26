local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/ArgCheck")
return require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux").makeActionCreator("SetCameraButtonErrorOccurred", function(p2)
	ArgCheck.isType(p2, "boolean", "Actions.SetCameraButton.errorOccurred")
	return { errorOccurred = p2 }
end)
