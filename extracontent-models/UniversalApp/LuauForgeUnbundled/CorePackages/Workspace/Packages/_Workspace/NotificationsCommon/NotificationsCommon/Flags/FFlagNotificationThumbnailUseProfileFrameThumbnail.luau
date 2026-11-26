local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("NotificationThumbnailUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
