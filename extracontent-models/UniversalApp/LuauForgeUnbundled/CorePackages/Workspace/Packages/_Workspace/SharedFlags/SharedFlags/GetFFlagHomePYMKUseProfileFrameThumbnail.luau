local GetFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagProfileFrameThumbnailEnabled")

game:DefineFastFlag("HomePYMKUseProfileFrameThumbnail", false)

return function()
	return game:GetFastFlag("HomePYMKUseProfileFrameThumbnail") and GetFFlagProfileFrameThumbnailEnabled()
end
