local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("SquadsUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
