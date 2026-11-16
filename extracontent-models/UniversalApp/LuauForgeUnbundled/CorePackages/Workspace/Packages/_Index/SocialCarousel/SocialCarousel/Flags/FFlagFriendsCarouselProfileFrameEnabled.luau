local getFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("FriendsCarouselProfileFrameEnabled", false)
	and getFFlagProfileFrameThumbnailEnabled()
