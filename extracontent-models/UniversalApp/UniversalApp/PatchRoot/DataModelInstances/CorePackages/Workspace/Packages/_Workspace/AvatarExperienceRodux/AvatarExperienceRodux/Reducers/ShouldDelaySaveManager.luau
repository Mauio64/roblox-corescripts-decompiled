local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local AvatarExperienceRoduxParent = AvatarExperienceRodux.Parent
local Rodux = require(AvatarExperienceRoduxParent.Rodux)
local AddSaveDelay = require(AvatarExperienceRodux.Actions.AddSaveDelay)
local RemoveSaveDelay = require(AvatarExperienceRodux.Actions.RemoveSaveDelay)

return Rodux.createReducer(false, {
	[AddSaveDelay.name] = function(_, _) -- line: 21
		return true
	end,
	[RemoveSaveDelay.name] = function(_, _) -- line: 25
		return false
	end
})
