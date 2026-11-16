local parent = script:FindFirstAncestor("UserTile").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("UserTileUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
