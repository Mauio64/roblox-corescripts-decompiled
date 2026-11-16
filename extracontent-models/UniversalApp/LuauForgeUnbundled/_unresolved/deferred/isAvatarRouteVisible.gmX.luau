require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local function isSamePage(p2, p3): boolean
	return p2.state.key == p3.key
end

local function isInPreviousPages(p2, items): boolean
	for k, item in items do
		if p2.state.key == item.key then
			return true
		end
	end

	return false
end

local function isAvatarRouteVisible(p2)
	local avatarRoute = p2.avatarRoute
	local navigation = p2.navigation
	local current = avatarRoute.current
	local v5 = navigation.state.key == current.key
	local flag = true
	local v6

	for k, previousPage in avatarRoute.previousPages do
		if navigation.state.key == previousPage.key then
			v6 = true
			flag = false
			break
		end
	end

	if flag then
		v6 = false
	end

	local opaque = avatarRoute.opaque
	local v7 = navigation.state.key == opaque.key

	return v5 or v6 or v7
end

return isAvatarRouteVisible
