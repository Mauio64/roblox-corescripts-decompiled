local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceNavigation").Enums.AvatarScreen

return {
	resolve = function(p2)
		if not p2.getParam then
			return nil, nil
		end

		local param = p2.getParam("entryOrigin")

		if param and param.screenName then
			return param.screenName, param.screenParams
		end

		return p2.getParam("prevNavPage"), nil
	end,
	park = function(p2, p3)
		if p2.navigate == nil then
			return
		end

		local navigate = p2.navigate
		local v5 = if p3 == avatarScreen.AvatarExperienceLandingPage then avatarScreen.AvatarExperienceLandingPage else avatarScreen.Catalog
		navigate(v5)
	end
}
