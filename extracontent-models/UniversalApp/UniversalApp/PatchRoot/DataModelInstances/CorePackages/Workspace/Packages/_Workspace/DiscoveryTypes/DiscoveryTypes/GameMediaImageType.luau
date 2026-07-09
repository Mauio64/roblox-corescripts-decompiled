local Parent = script:FindFirstAncestor("DiscoveryTypes").Parent
local FFlagLuaAppEdpMediaGalleryVideoPreview = require(Parent.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview

return {
	Image = 1,
	YouTubeVideo = 33,
	GamePreviewVideo = 86,
	Video = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else 62
}
