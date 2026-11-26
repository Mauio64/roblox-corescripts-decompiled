local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("CurrencyTransferUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
