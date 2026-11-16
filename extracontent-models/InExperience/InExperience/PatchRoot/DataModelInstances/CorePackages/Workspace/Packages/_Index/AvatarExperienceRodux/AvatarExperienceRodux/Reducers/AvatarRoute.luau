local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local parent = AvatarExperienceRodux.Parent
local Rodux = require(parent.Rodux)

local SetAvatarSceneRoute = require(AvatarExperienceRodux.Actions.SetAvatarSceneRoute)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute.new({})

return Rodux.createReducer(avatarRoute, {
	[SetAvatarSceneRoute.name] = function(_, p)
		return p.avatarRoute
	end
})
