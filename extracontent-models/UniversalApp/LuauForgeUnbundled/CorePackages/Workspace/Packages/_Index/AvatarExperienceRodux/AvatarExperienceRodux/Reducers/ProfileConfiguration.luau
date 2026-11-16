local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceFlags")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/RoduxTypes")
local ApplyProfileConfiguration = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/ApplyProfileConfiguration")

local characterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local fFlagAXBackgroundsPersistence = AvatarExperienceFlags.FFlagAXBackgroundsPersistence

return Rodux.createReducer({}, {
	[ApplyProfileConfiguration.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, p3.profileConfiguration)
	end,
	[characterHistoryStateChangeButtonActivated.name] = function(p2, p3)
		if fFlagAXBackgroundsPersistence and p3.equipped then
			return { BackgroundAssetId = p3.equipped.BackgroundAssetId }
		end

		return p2
	end
})
