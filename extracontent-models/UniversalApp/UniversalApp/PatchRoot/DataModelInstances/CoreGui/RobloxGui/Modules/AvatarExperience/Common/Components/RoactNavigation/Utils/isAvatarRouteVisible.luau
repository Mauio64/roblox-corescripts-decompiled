local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local function isSamePage(p1, p2) -- line: 6
	return p1.state.key == p2.key
end
local function isInPreviousPages(p3, t1: {[any]: any}) -- line: 10
	for _, v10 in t1 do
		if p3.state.key == v10.key then
			return true
		end
	end

	return false
end
local function isAvatarRouteVisible(p4) -- line: 19
	local avatarRoute = p4.avatarRoute
	local navigation = p4.navigation
	local current = avatarRoute.current
	local v15 = navigation.state.key == current.key
	local g19 = nil
	local v18 = nil

	for _, v17 in avatarRoute.previousPages do
		if navigation.state.key == v17.key then
			v18 = true
			g19 = true
		end

		if g19 then
			break
		end
	end

	if not g19 then
		v18 = false
	end

	g19 = false

	local opaque = avatarRoute.opaque
	local v21 = navigation.state.key == opaque.key

	return v15 or (v18 or v21)
end

return isAvatarRouteVisible
