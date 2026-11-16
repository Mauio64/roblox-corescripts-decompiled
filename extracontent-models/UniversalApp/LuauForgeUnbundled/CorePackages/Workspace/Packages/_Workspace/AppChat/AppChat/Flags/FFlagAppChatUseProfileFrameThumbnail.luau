local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("AppChatUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
