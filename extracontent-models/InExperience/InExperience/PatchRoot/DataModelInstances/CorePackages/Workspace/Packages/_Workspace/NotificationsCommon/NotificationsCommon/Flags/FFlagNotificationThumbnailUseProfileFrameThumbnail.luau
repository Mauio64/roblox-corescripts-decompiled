local parent = script.Parent.Parent.Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("NotificationThumbnailUseProfileFrameThumbnail", false)
	and GetFFlagProfileFrameThumbnailEnabled()
