local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Constants = AvatarExperienceCommon.Constants
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local selectCurrentAvatarEditorCategory = AvatarExperienceCommon.State.Selectors.selectCurrentAvatarEditorCategory
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType
local selectEquippedAssets = AvatarExperienceCommon.State.Selectors.selectEquippedAssets
local AvatarEditorCategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorCategories
local FFlagAXMakeupEquipping = AvatarExperienceFlags.FFlagAXMakeupEquipping
local MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON = Constants.MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON

local function getEquippedMakeupCount(p1) -- line: 20
	-- upvalues: FFlagAXMakeupEquipping (copy), selectEquippedAssets (copy), isMakeupAssetType (copy)
	if not FFlagAXMakeupEquipping then
		return 0
	end

	local v17 = selectEquippedAssets(p1)

	if not v17 then
		return 0
	end

	local n1 = 0

	for v19, v20 in v17 do
		if isMakeupAssetType(v19) then
			for _ in v20 do
				n1 += 1
			end
		end
	end

	return n1
end
local function selectIsInMakeupCategoryWithMultipleItems(p2) -- line: 41
	-- upvalues: FFlagAXMakeupEquipping (copy), selectCurrentAvatarEditorCategory (copy), GetAvatarEditorCategories (copy), AvatarEditorCategories (copy), getEquippedMakeupCount (copy), MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON (copy)
	if not FFlagAXMakeupEquipping then
		return false
	end

	local v23 = selectCurrentAvatarEditorCategory(p2)
	local v24 = GetAvatarEditorCategories()[v23]

	if not v24 or v24.Id ~= AvatarEditorCategories.Makeup then
		return false
	end

	return getEquippedMakeupCount(p2) >= MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON
end

return selectIsInMakeupCategoryWithMultipleItems
