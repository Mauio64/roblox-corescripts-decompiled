local ParentParent = script.Parent.Parent.Parent
local GetFFlagProfileFrameThumbnailEnabled = require(ParentParent.SharedFlags).GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("NotificationThumbnailUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
