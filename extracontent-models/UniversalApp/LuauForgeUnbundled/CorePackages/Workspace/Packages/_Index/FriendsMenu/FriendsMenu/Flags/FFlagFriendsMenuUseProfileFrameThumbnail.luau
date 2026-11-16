local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("FriendsMenuUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
