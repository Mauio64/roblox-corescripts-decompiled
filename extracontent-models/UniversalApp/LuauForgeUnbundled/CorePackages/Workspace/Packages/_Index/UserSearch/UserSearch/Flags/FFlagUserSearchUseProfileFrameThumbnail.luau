local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("UserSearchUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
