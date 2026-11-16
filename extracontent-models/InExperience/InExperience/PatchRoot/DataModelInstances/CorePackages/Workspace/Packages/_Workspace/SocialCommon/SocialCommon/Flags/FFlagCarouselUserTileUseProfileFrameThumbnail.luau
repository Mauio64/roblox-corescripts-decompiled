local parent = script:FindFirstAncestor("SocialCommon").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("CarouselUserTileUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
