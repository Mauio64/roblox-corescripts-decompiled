local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers

return {
	TrendingWidget = AppUserLayers.AvatarMarketplaceALGOONLYTrendingWidget,
	ThemedAvatarItemsWidget = AppUserLayers.AvatarMarketplaceALGOONLYThematicWidget,
	PersonalizedAvatarLooksWidget = AppUserLayers.AvatarMarketplaceALGOONLYAvatarWidget,
	PopularAmongFriendsWidget = AppUserLayers.AvatarMarketplaceALGOONLYFriendsWidget,
	CurationWidget = AppUserLayers.AvatarMarketplaceALGOONLYCurationWidget
}
