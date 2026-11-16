local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("ControlBarUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
