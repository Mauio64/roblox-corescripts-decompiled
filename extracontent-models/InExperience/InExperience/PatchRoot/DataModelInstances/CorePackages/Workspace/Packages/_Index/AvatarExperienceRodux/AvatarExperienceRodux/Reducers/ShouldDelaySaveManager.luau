local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local parent = AvatarExperienceRodux.Parent
local Rodux = require(parent.Rodux)

local AddSaveDelay = require(AvatarExperienceRodux.Actions.AddSaveDelay)
local RemoveSaveDelay = require(AvatarExperienceRodux.Actions.RemoveSaveDelay)

return Rodux.createReducer(false, {
	[AddSaveDelay.name] = function(_, _): boolean
		return true
	end,
	[RemoveSaveDelay.name] = function(_, _): boolean
		return false
	end
})
