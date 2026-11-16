local AvatarExperienceActions = { ClearScreens = "ClearScreens" }

function AvatarExperienceActions.clearScreens(routeNames)
	return { type = AvatarExperienceActions.ClearScreens, routeNames = routeNames }
end

return AvatarExperienceActions
