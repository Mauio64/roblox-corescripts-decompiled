local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local parent = AvatarExperienceRodux.Parent
local Rodux = require(parent.Rodux)

local SetCurrentCharacter = require(AvatarExperienceRodux.Actions.SetCurrentCharacter)

return Rodux.createReducer(nil, {
	[SetCurrentCharacter.name] = function(_, p)
		return p.currentCharacter
	end
})
