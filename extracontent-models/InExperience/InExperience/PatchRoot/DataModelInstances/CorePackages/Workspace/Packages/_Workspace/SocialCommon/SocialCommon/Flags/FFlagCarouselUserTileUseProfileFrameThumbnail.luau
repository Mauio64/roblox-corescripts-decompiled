local Parent = script:FindFirstAncestor("SocialCommon").Parent
local GetFFlagProfileFrameThumbnailEnabled = require(Parent.SharedFlags).GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("CarouselUserTileUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
