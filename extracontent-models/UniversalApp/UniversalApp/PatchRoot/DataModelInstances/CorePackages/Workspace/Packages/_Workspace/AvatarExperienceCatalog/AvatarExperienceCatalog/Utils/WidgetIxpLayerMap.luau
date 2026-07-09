local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers

return {
	TrendingWidget = AppUserLayers.AvatarMarketplaceALGOONLYTrendingWidget,
	ThemedAvatarItemsWidget = AppUserLayers.AvatarMarketplaceALGOONLYThematicWidget,
	PersonalizedAvatarLooksWidget = AppUserLayers.AvatarMarketplaceALGOONLYAvatarWidget,
	PopularAmongFriendsWidget = AppUserLayers.AvatarMarketplaceALGOONLYFriendsWidget,
	CurationWidget = AppUserLayers.AvatarMarketplaceALGOONLYCurationWidget
}
