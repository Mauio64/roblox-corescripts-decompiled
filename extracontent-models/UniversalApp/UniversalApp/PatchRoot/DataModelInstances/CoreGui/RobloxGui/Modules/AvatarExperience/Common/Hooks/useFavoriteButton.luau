local CorePackages = game:GetService("CorePackages")
local Images = require(CorePackages.Packages.UIBlox).App.ImageSet.Images
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local v4 = Images["icons/actions/favoriteOff"]
local v5 = Images["icons/actions/favoriteOn"]

local function useFavoriteButton(_: string?, b1: boolean, p1: ((...any) -> ...any)?) -- line: 11
	-- upvalues: useLocalization (copy), v5 (copy), v4 (copy)
	local v10 = useLocalization({
		favoriteAction = "Feature.Favorites.Label.Favorite"
	})

	return {
		icon = if not b1 then v4 else v5,
		text = v10.favoriteAction,
		onActivated = p1
	}
end

return useFavoriteButton
