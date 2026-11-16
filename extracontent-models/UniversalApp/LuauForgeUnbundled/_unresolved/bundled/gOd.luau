local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

return {
	fromRoute = function(p2)
		local fromAvatarRoute = p2 and p2.params and p2.params.fromAvatarRoute
		local current = fromAvatarRoute and fromAvatarRoute.current

		local v6 = if current and current.name == avatarScreen.CatalogSearch then current.key else nil
		return {
			searchUUID = v6,
			searchKeywordFromParams = p2 and p2.params and p2.params.searchParams and p2.params.searchParams.searchKeyword
		}
	end,
	equal = function(p2, p3): boolean
		return p2.searchUUID == p3.searchUUID and p2.searchKeywordFromParams == p3.searchKeywordFromParams
	end
}
