local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("UserTileUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
