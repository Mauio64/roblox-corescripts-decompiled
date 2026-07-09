local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local AvatarExperienceRoduxParent = AvatarExperienceRodux.Parent
local Cryo = require(AvatarExperienceRoduxParent.Cryo)
local Rodux = require(AvatarExperienceRoduxParent.Rodux)
local AvatarExperienceCommon = require(AvatarExperienceRoduxParent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(AvatarExperienceRoduxParent.AvatarExperienceFlags)

require(AvatarExperienceRodux.Types.RoduxTypes)

local ApplyProfileConfiguration = require(AvatarExperienceRodux.Actions.ApplyProfileConfiguration)
local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local FFlagAXBackgroundsPersistence = AvatarExperienceFlags.FFlagAXBackgroundsPersistence

return Rodux.createReducer({}, {
	[ApplyProfileConfiguration.name] = function(p1, p2) -- line: 37
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, p2.profileConfiguration)
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(p3, p4) -- line: 43
		-- upvalues: FFlagAXBackgroundsPersistence (copy)
		if FFlagAXBackgroundsPersistence and p4.equipped then
			return {
				BackgroundAssetId = p4.equipped.BackgroundAssetId
			}
		end

		return p3
	end
})
