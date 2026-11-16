local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)

local Constants = require(script.Parent.Constants)
local sendAXCounterV2 = require(script.Parent.sendAXCounterV2)

local AvatarBackground = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground

local v = {
	Equip = Constants.AVATAR_EVENT_COUNTER_NAME.AXEquipBackground,
	Unequip = Constants.AVATAR_EVENT_COUNTER_NAME.AXUnequipBackground,
	TryOn = Constants.AVATAR_EVENT_COUNTER_NAME.AXTryOnBackground,
	RemoveTryOn = Constants.AVATAR_EVENT_COUNTER_NAME.AXRemoveTryOnBackground
}

local ReportBackgroundUserActionCounter = {}

function ReportBackgroundUserActionCounter.report(p: string)
	sendAXCounterV2(v[p])
end

function ReportBackgroundUserActionCounter.reportIfAvatarBackgroundAsset(p: string, p2: string?, p3: string?)
	if AvatarBackground and p2 == "Asset" and p3 == AvatarBackground then
		ReportBackgroundUserActionCounter.report(p)
	end
end

return ReportBackgroundUserActionCounter
