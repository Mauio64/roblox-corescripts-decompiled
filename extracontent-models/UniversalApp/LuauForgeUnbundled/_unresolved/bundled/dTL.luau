local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("AvatarHeadshotIconUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
