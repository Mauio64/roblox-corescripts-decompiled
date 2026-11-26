local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local module2 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dKT")
require("@luauforge/bundled/dPs")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module3 = require("@luauforge/bundled/fCe")
require("@luauforge/bundled/dKU")

local v5 = {}

function v5.buildEquippedBodyStateMap(p2)
	local selectedInTryOnManagersByAssetType = {}

	for k, tryOnItem in p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if not (tryOnItem.itemType == module2.ItemType.Bundle and tryOnItem.bundleInfo and tryOnItem.itemId == tostring(module2.BlockyBundleId)) then
			continue
		end

		for k2, v6 in tryOnItem.bundleInfo do
			if module2.AssetTypeIdToCategory[v6.assetType] == module2.AssetCategories.Body then
				selectedInTryOnManagersByAssetType[v6.assetType] = tryOnItem.selectedInTryOnManager
			end
		end
	end

	return selectedInTryOnManagersByAssetType
end

function v5.shouldUnequipBodyBeforeTryOn(p2): boolean
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.ShouldTryOnWithoutEquippedItems == true
end

function v5.buildEquippedAssetMapByHumanoidDescriptionProp(p2)
	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local result = {}

	if not equippedAssets then
		return result
	end

	for k, equippedAsset in equippedAssets do
		local v6 = module2.AssetTypeIdStringToHumanoidDescriptionProp[k]

		if not v6 then
			continue
		end

		if not result[v6] then
			result[v6] = {}
		end

		table.insert(result[v6], equippedAsset)
	end

	return result
end

function v5.processBlockyBundleParts(items)
	local result = {
		[module2.AssetTypeIdStrings.Torso] = true,
		[module2.AssetTypeIdStrings.RightArm] = true,
		[module2.AssetTypeIdStrings.LeftArm] = true,
		[module2.AssetTypeIdStrings.LeftLeg] = true,
		[module2.AssetTypeIdStrings.RightLeg] = true,
		[module2.AssetTypeIdStrings.DynamicHead] = true,
		[module2.AssetTypeIdStrings.Head] = true
	}
	local v6 = 7

	for k, item in items do
		for k2, v7 in item.assetsInBundle do
			if not v7.isIncluded then
				continue
			end

			if
				tostring(v7.assetType) == module2.AssetTypeIdStrings.DynamicHead
				or tostring(v7.assetType) == module2.AssetTypeIdStrings.Head
			then
				result[module2.AssetTypeIdStrings.DynamicHead] = nil
				result[module2.AssetTypeIdStrings.Head] = nil
				v6 -= 2
			else
				result[tostring(v7.assetType)] = nil
				v6 -= 1
			end
		end
	end

	if result[module2.AssetTypeIdStrings.DynamicHead] and result[module2.AssetTypeIdStrings.Head] then
		result[module2.AssetTypeIdStrings.Head] = nil
		v6 -= 1
	end

	return result
end

function v5.buildBlockyLookDetailItem(p2, callback)
	local v6 = {
		itemType = widgetConstants.ContentType.Bundle,
		bundleType = 1,
		itemRestrictions = {},
		assetsInBundle = {},
		name = callback("Feature.Avatar.Label.DefaultBody"),
		description = "",
		id = tostring(module2.BlockyBundleId),
		productId = 0,
		isPurchasable = false,
		priceInRobux = 0,
		quantityOwned = 1,
		tryOnItemOrder = 0
	}

	local v7 = v5.processBlockyBundleParts(p2)
	local v8 = 1

	for k, v9 in v7 do
		table.insert(v6.assetsInBundle, {
			id = v8,
			assetType = tonumber(k) or 0,
			isIncluded = true
		})

		v8 += 1
	end

	if #v6.assetsInBundle == 0 then
		return nil
	end

	return v6
end

function v5.adjustTryOnItemOrderForBlockyBundle(items, items2, items3)
	local v6 = 0

	for k, item in items3 do
		if not module3.isItemSelectable(item) then
			v6 = k
		end
	end

	local v7 = v6 + 1

	for k, item in items do
		if item.tryOnItemOrder and v7 <= item.tryOnItemOrder then
			item.tryOnItemOrder += 1
		end
	end

	for k, item in items2 do
		if item.id == tostring(module2.BlockyBundleId) then
			item.tryOnItemOrder = v7
		elseif item.tryOnItemOrder and v7 <= item.tryOnItemOrder then
			item.tryOnItemOrder += 1
		end
	end
end

return v5
