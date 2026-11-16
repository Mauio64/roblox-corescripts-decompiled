local parent = script:FindFirstAncestor("SocialCarousel").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("FriendsCarouselProfileFrameEnabled", false) and GetFFlagProfileFrameThumbnailEnabled()
