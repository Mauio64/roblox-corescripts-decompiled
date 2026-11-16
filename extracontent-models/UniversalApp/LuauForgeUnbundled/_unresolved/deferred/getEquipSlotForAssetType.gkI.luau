local module = require("@luauforge/bundled/fuM")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module2 = require("@luauforge/bundled/dMx")
local slotEditorCategories = module.Constants.SlotEditorCategories
local categories = module.Enums.Categories

local v5 = {}

for k, slotEditorCategory in slotEditorCategories do
	for k2, slot in slotEditorCategory.slots do
		if slot.hide or not slot.assetTypes then
			continue
		end

		for k3, assetType in slot.assetTypes do
			v5[tostring(assetType.Value)] = {
				categoryKey = slotEditorCategory.nameTranslationKey,
				slotKey = slot.nameTranslationKey
			}
		end
	end
end

local nameTranslationKey = slotEditorCategories[categories.Makeup].nameTranslationKey
v5[module2.AssetTypeIdStrings.EyeMakeup] = {
	categoryKey = nameTranslationKey,
	slotKey = "Feature.Catalog.Label.EyeMakeup"
}

v5[module2.AssetTypeIdStrings.FaceMakeup] = {
	categoryKey = nameTranslationKey,
	slotKey = "Feature.Catalog.Label.FaceMakeup"
}

v5[module2.AssetTypeIdStrings.LipMakeup] = {
	categoryKey = nameTranslationKey,
	slotKey = "Feature.Catalog.Label.LipMakeup"
}

v5[module2.AssetTypeIdStrings.EmoteAnimation] = {
	categoryKey = slotEditorCategories[categories.Emotes].nameTranslationKey
}

local v6 = {
	[module2.BundleTypeIdStrings.BodyParts] = {
		categoryKey = slotEditorCategories[categories.Body].nameTranslationKey,
		slotKey = "Feature.Catalog.Label.FullBody"
	},
	[module2.BundleTypeIdStrings.DynamicHead] = {
		categoryKey = slotEditorCategories[categories.Body].nameTranslationKey,
		slotKey = "Feature.Avatar.Label.Head"
	},
	[module2.BundleTypeIdStrings.Shoes] = {
		categoryKey = slotEditorCategories[categories.Clothing].nameTranslationKey,
		slotKey = "Feature.Avatar.Label.Shoes"
	},
	[module2.BundleTypeIdStrings.Animations] = {
		categoryKey = slotEditorCategories[categories.Animations].nameTranslationKey,
		slotKey = "Feature.Avatar.Label.AnimationFullSet"
	}
}

local function getEquipSlotForAssetType(p2, p3)
	if p2 == module2.ItemType.Asset then
		return v5[p3]
	end

	if p2 == module2.ItemType.Bundle then
		return v6[p3]
	end

	return nil
end

return getEquipSlotForAssetType
