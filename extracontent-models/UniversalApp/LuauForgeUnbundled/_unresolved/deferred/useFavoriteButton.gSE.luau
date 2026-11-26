local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local iconsactionsfavoriteOff = images["icons/actions/favoriteOff"]
local iconsactionsfavoriteOn = images["icons/actions/favoriteOn"]

local function useFavoriteButton(p2, p3, onActivated)
	return {
		icon = if p3 then iconsactionsfavoriteOn else iconsactionsfavoriteOff,
		text = useLocalization({ favoriteAction = "Feature.Favorites.Label.Favorite" }).favoriteAction,
		onActivated = onActivated
	}
end

return useFavoriteButton
