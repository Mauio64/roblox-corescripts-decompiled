local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("UserTileIncludeProfileFrameProp", false)
	and getFFlagProfileFrameThumbnailEnabled()
