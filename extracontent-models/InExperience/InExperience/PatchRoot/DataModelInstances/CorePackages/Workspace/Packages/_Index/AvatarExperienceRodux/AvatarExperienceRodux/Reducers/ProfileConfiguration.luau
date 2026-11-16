local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local parent = AvatarExperienceRodux.Parent
local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

require(AvatarExperienceRodux.Types.RoduxTypes)
local ApplyProfileConfiguration = require(AvatarExperienceRodux.Actions.ApplyProfileConfiguration)

local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local FFlagAXBackgroundsPersistence = AvatarExperienceFlags.FFlagAXBackgroundsPersistence

return Rodux.createReducer({}, {
	[ApplyProfileConfiguration.name] = function(p, p2)
		return Cryo.Dictionary.join(p, p2.profileConfiguration)
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(p, p2)
		if FFlagAXBackgroundsPersistence and p2.equipped then
			return { BackgroundAssetId = p2.equipped.BackgroundAssetId }
		end

		return p
	end
})
