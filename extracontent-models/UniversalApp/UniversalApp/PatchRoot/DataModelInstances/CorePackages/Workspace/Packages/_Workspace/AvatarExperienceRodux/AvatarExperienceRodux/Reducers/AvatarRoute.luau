local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local AvatarExperienceRoduxParent = AvatarExperienceRodux.Parent
local Rodux = require(AvatarExperienceRoduxParent.Rodux)
local SetAvatarSceneRoute = require(AvatarExperienceRodux.Actions.SetAvatarSceneRoute)
local v5 = require(AvatarExperienceRoduxParent.AvatarExperienceNavigation).AvatarRoute.AvatarRoute.new({})

return Rodux.createReducer(v5, {
	[SetAvatarSceneRoute.name] = function(_, p2) -- line: 16
		return p2.avatarRoute
	end
})
