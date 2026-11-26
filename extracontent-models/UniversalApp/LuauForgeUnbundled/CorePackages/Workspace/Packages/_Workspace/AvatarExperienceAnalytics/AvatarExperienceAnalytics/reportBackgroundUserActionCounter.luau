local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceCommon")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Constants")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendAXCounterV2")

local avatarBackground = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground

local v5 = {
	Equip = Constants.AVATAR_EVENT_COUNTER_NAME.AXEquipBackground,
	Unequip = Constants.AVATAR_EVENT_COUNTER_NAME.AXUnequipBackground,
	TryOn = Constants.AVATAR_EVENT_COUNTER_NAME.AXTryOnBackground,
	RemoveTryOn = Constants.AVATAR_EVENT_COUNTER_NAME.AXRemoveTryOnBackground
}

local v6 = {}

function v6.report(p2)
	sendAXCounterV2(v5[p2])
end

function v6.reportIfAvatarBackgroundAsset(p2, p3, p4)
	if avatarBackground and p3 == "Asset" and p4 == avatarBackground then
		v6.report(p2)
	end
end

return v6
