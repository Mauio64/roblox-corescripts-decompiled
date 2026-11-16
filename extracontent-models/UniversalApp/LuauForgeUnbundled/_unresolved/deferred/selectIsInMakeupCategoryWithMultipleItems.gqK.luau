local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local constants = AvatarExperienceCommon.Constants
local module2 = require("@luauforge/bundled/dMd")

local module3 = require("@luauforge/bundled/dOj")
local selectCurrentAvatarEditorCategory = AvatarExperienceCommon.State.Selectors.selectCurrentAvatarEditorCategory

local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType
local selectEquippedAssets = AvatarExperienceCommon.State.Selectors.selectEquippedAssets
local avatarEditorCategories = module2.Enums.AvatarEditorCategories

local MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON = constants.MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON

local function getEquippedMakeupCount(p2)
	local v5 = selectEquippedAssets(p2)

	if not v5 then
		return 0
	end

	local count = 0

	for k, v6 in v5 do
		if not isMakeupAssetType(k) then
			continue
		end

		for k2 in v6 do
			count += 1
		end
	end

	return count
end

local function selectIsInMakeupCategoryWithMultipleItems(p2): boolean
	local v5 = selectCurrentAvatarEditorCategory(p2)
	local v6 = module3()[v5]

	if v6 and v6.Id == avatarEditorCategories.Makeup then
		return MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON <= getEquippedMakeupCount(p2)
	end

	return false
end

return selectIsInMakeupCategoryWithMultipleItems
