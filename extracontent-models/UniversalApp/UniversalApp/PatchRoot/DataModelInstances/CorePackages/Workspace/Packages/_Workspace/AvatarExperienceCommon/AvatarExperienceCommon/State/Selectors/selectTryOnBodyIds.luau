local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local ItemTypeEnum = require(AvatarExperienceCommon.Enums.ItemTypeEnum)
local Constants = require(AvatarExperienceCommon.Constants)

local function getBodiesInTryOns(t1: {[any]: any}) -- line: 6
	-- upvalues: ItemTypeEnum (copy), Constants (copy)
	local t2 = {}

	for _, v9 in t1 do
		if v9.itemType == ItemTypeEnum.Bundle and v9.itemSubType == Constants.BODY_BUNDLE_TYPE_ID then
			table.insert(t2, v9.itemId)
		end
	end

	return t2
end
local function selectTryOnBodyIds(p1) -- line: 19
	-- upvalues: getBodiesInTryOns (copy)
	local OutfitTryOn = p1.AvatarExperience.AvatarScene.OutfitTryOn

	if OutfitTryOn and OutfitTryOn.TryOnItems then
		return (getBodiesInTryOns(OutfitTryOn.TryOnItems))
	end

	return {}
end

return selectTryOnBodyIds
