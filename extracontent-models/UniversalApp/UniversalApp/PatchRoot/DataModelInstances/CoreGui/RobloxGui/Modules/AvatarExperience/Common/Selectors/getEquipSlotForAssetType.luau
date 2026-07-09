local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local SlotEditorCategories = AvatarExperienceSlotBasedEditor.Constants.SlotEditorCategories
local Categories = AvatarExperienceSlotBasedEditor.Enums.Categories
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local t1 = {}

for _, v11 in SlotEditorCategories do
	for _, v13 in v11.slots do
		if not v13.hide and v13.assetTypes then
			for _, v15 in v13.assetTypes do
				t1[tostring(v15.Value)] = {
					categoryKey = v11.nameTranslationKey,
					slotKey = v13.nameTranslationKey
				}
			end
		end
	end
end

if FFlagAXCustomizeMakeupSupport then
	local nameTranslationKey = SlotEditorCategories[Categories.Makeup].nameTranslationKey

	t1[Constants.AssetTypeIdStrings.EyeMakeup] = {
		slotKey = "Feature.Catalog.Label.EyeMakeup",
		categoryKey = nameTranslationKey
	}
	t1[Constants.AssetTypeIdStrings.FaceMakeup] = {
		slotKey = "Feature.Catalog.Label.FaceMakeup",
		categoryKey = nameTranslationKey
	}
	t1[Constants.AssetTypeIdStrings.LipMakeup] = {
		slotKey = "Feature.Catalog.Label.LipMakeup",
		categoryKey = nameTranslationKey
	}
end

t1[Constants.AssetTypeIdStrings.EmoteAnimation] = {
	categoryKey = SlotEditorCategories[Categories.Emotes].nameTranslationKey
}

local t2 = {
	[Constants.BundleTypeIdStrings.BodyParts] = {
		slotKey = "Feature.Catalog.Label.FullBody",
		categoryKey = SlotEditorCategories[Categories.Body].nameTranslationKey
	},
	[Constants.BundleTypeIdStrings.DynamicHead] = {
		slotKey = "Feature.Avatar.Label.Head",
		categoryKey = SlotEditorCategories[Categories.Body].nameTranslationKey
	},
	[Constants.BundleTypeIdStrings.Shoes] = {
		slotKey = "Feature.Avatar.Label.Shoes",
		categoryKey = SlotEditorCategories[Categories.Clothing].nameTranslationKey
	},
	[Constants.BundleTypeIdStrings.Animations] = {
		slotKey = "Feature.Avatar.Label.AnimationFullSet",
		categoryKey = SlotEditorCategories[Categories.Animations].nameTranslationKey
	}
}

local function getEquipSlotForAssetType(s1: string, s2: string) -- line: 88
	-- upvalues: Constants (copy), t1 (copy), t2 (copy)
	if s1 == Constants.ItemType.Asset then
		return t1[s2]
	end

	if s1 == Constants.ItemType.Bundle then
		return t2[s2]
	end

	return nil
end

return getEquipSlotForAssetType
