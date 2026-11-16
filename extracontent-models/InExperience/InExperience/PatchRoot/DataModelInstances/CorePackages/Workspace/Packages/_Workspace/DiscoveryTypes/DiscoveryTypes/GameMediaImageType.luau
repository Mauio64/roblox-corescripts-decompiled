local parent = script:FindFirstAncestor("DiscoveryTypes").Parent

local SharedFlags = require(parent.SharedFlags)
return {
	Image = 1,
	YouTubeVideo = 33,
	Video = SharedFlags.FFlagLuaAppEdpMediaGalleryVideoPreview and 62 or nil,
	GamePreviewVideo = 86
}
