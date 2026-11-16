local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("FlyoutAlternateEntryPointUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
