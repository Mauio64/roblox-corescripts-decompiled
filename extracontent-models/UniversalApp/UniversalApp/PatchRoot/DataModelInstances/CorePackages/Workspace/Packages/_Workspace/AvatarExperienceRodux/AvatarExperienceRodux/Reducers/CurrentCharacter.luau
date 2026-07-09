local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local AvatarExperienceRoduxParent = AvatarExperienceRodux.Parent
local Rodux = require(AvatarExperienceRoduxParent.Rodux)
local SetCurrentCharacter = require(AvatarExperienceRodux.Actions.SetCurrentCharacter)

return Rodux.createReducer(nil, {
	[SetCurrentCharacter.name] = function(_, p2) -- line: 12
		return p2.currentCharacter
	end
})
