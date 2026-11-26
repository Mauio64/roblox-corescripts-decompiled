local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("CarouselUserTileUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
