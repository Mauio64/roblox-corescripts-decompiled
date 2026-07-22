local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)
local Constants = require(script.Parent.Constants)
local reportAvatarEventCounterV1 = require(script.Parent.reportAvatarEventCounterV1)
local AvatarBackground = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground
local t1 = {
	Equip = Constants.AVATAR_EVENT_COUNTER_NAME.AXEquipBackground,
	Unequip = Constants.AVATAR_EVENT_COUNTER_NAME.AXUnequipBackground,
	TryOn = Constants.AVATAR_EVENT_COUNTER_NAME.AXTryOnBackground,
	RemoveTryOn = Constants.AVATAR_EVENT_COUNTER_NAME.AXRemoveTryOnBackground
}
local t2 = {
	report = function(s1: string) -- line: 24
		-- upvalues: reportAvatarEventCounterV1 (copy), t1 (copy)
		reportAvatarEventCounterV1(t1[s1])
	end
}

function t2.reportIfAvatarBackgroundAsset(s2: string, s3: string?, s4: string?) -- line: 29
	-- upvalues: AvatarBackground (copy), t2 (copy)
	if AvatarBackground and (s3 == "Asset" and s4 == AvatarBackground) then
		t2.report(s2)
	end
end

return t2
