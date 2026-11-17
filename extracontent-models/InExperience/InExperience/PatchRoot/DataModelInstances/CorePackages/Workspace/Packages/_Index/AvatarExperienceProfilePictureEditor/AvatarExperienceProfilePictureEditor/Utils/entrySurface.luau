local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local EntrySurface = {}

function EntrySurface.resolve(p)
	if not p.getParam then
		return nil, nil
	end

	local param = p.getParam("entryOrigin")

	if param and param.screenName then
		return param.screenName, param.screenParams
	end

	return p.getParam("prevNavPage"), nil
end

function EntrySurface.park(p, p2: string?)
	if p.navigate == nil then
		return
	end

	local navigate = p.navigate
	local v

	if p2 == AvatarScreen.AvatarExperienceLandingPage then
		v = AvatarScreen.AvatarExperienceLandingPage
	else
		v = AvatarScreen.Catalog
	end

	navigate(v)
end

return EntrySurface
