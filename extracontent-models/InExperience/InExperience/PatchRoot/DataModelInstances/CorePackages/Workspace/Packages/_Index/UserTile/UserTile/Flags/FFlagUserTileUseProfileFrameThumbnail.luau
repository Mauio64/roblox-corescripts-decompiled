local Parent = script:FindFirstAncestor("UserTile").Parent
local GetFFlagProfileFrameThumbnailEnabled = require(Parent.SharedFlags).GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("UserTileUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
