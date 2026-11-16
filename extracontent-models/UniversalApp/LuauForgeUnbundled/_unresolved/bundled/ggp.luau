local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/fvh")
local assetTypeToAssetCategory = require("@luauforge/bundled/dHL").Constants.AssetTypeToAssetCategory
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@luauforge/bundled/dHK")
local module4 = require("@luauforge/bundled/dMx")
local module5 = require("@luauforge/bundled/fuD")
require("@luauforge/bundled/dMc")

local module6 = require("@luauforge/bundled/ggq")
local module7 = require("@luauforge/bundled/ggr")
local setMakeupDescriptions = AvatarExperienceCommon.Utils.setMakeupDescriptions
local destroyMakeupDescriptions = AvatarExperienceCommon.Utils.destroyMakeupDescriptions

local getMakeupDescriptionsFromHumanoidDescription = AvatarExperienceCommon.Utils.getMakeupDescriptionsFromHumanoidDescription
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local MAX_MAKEUP_LAYERS = AvatarExperienceCommon.Constants.MAX_MAKEUP_LAYERS

local module8 = require("@luauforge/bundled/dOD")
local module9 = require("@luauforge/bundled/ggo")

local module10 = require("@luauforge/bundled/ggs")

local module11 = require("@luauforge/bundled/ggt")
local fFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local fFlagEnableHeadShapeForCharacterManager = AvatarExperienceFlags.FFlagEnableHeadShapeForCharacterManager
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType
local fFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local fFlagFixHeadShapeColorSlider = AvatarExperienceFlags.FFlagFixHeadShapeColorSlider
local fFlagAXFixR6DefaultHeadShape = AvatarExperienceFlags.FFlagAXFixR6DefaultHeadShape
local fFlagAXPhotoboothMomentsPage = AvatarExperienceFlags.FFlagAXPhotoboothMomentsPage
local fFlagAXTryOnWithoutEquippedBody = AvatarExperienceFlags.FFlagAXTryOnWithoutEquippedBody

local fFlagAXUseSignalsForLayeredClothingCurrentSort = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingCurrentSort
local getLayeredClothingCurrentSortStore

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	getLayeredClothingCurrentSortStore = AvatarExperienceCommon.Stores.getLayeredClothingCurrentSortStore
else
	getLayeredClothingCurrentSortStore = nil
end

local module12 = require("@luauforge/bundled/ggu")

local v5 = {}

function v5.shouldTryOnWithoutEquippedBody(p2): boolean
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.ShouldTryOnWithoutEquippedBody == true
end

function v5.isTryingOnWholeAvatar(p2): boolean
	local outfitTryOn = p2.AvatarExperience.AvatarScene.OutfitTryOn

	if fFlagAXPhotoboothMomentsPage and outfitTryOn.OutfitId ~= nil then
		return true
	end

	return outfitTryOn.LookId ~= nil
end

local function getIsInLCSortIsRemovedTuple(p2, p3)
	if fFlagAXUseSignalsForLayeredClothingCurrentSort then
		local layeredClothingCurrentSortStore = getLayeredClothingCurrentSortStore(false)
		local v6 = layeredClothingCurrentSortStore.getOrderedList(false) or {}
		local v7 = layeredClothingCurrentSortStore.getRemovedList(false) or {}
		return module8.createAssetIdToOrderMapping(v6)[p3], v7[p3]
	else
		local layeredClothingSort = p2.AvatarExperience and p2.AvatarExperience.LayeredClothingSort
		local currentSort = layeredClothingSort and layeredClothingSort.CurrentSort

		if fFlagHeadRefinementFacialAnimationToggle then
			if not currentSort then
				return false, false
			end

			local orderedList = currentSort.OrderedList or {}
			local removedList = currentSort.RemovedList or {}
			return module8.createAssetIdToOrderMapping(orderedList)[p3], removedList[p3]
		else
			local orderedList = p2.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList
			local removedList = p2.AvatarExperience.LayeredClothingSort.CurrentSort.RemovedList
			return module8.createAssetIdToOrderMapping(orderedList)[p3], removedList[p3]
		end
	end
end

function v5.tryApplyClassicHeadShapeTryOn(p2, p3)
	local v6

	if fFlagAXPhotoboothMomentsPage then
		v6 = v5.isTryingOnWholeAvatar(p2)
	else
		v6 = p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId ~= nil
	end

	local tryingOnDynamicHead = module5.isTryingOnDynamicHead(p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems)
	local v7 = module12(p2)

	if v6 or tryingOnDynamicHead or not v7 then
		return
	end

	p3.Head = v7
end

local function updateHumanoidDescriptionTryOnFromNormalizedAssets(object, p2, list, p3)
	if not list or #list == 0 then
		return p2
	end

	table.sort(list, function(a, b): boolean
		if a.itemRecency and b.itemRecency then
			return a.itemRecency < b.itemRecency
		end

		return false
	end)

	for k, v6 in module4.AssetTypeIdStringToHumanoidDescriptionProp do
		if module4.AssetTypeIdToCategory[k] ~= module4.AssetCategories.Body then
			continue
		end

		local v7 = p3[v6]

		if v7 == nil then
			continue
		end

		for k2, v8 in v7 do
			for k3, v9 in v8 do
				object[v6] = k3
			end
		end
	end

	for k, item in list do
		if
			item.isRemovedInLCSort
			or item.assetTypeId == module4.AssetTypeIdStrings.Gear
			or not item.assetId
		then
			continue
		end

		local v6 = module4.AssetTypeIdStringToHumanoidDescriptionProp[item.assetTypeId]

		if module4.AssetTypeIdToAccessoryTypeEnum[item.assetTypeId] then
			local defaultHumanoidDescriptionAccessoryInfo = module5.createDefaultHumanoidDescriptionAccessoryInfo(
				item.assetTypeId,
				item.assetId
			)

			if item.order ~= nil then
				defaultHumanoidDescriptionAccessoryInfo.Order = item.order
			end

			defaultHumanoidDescriptionAccessoryInfo.Position = item.position
			defaultHumanoidDescriptionAccessoryInfo.Rotation = item.rotation
			defaultHumanoidDescriptionAccessoryInfo.Scale = item.scale

			local lookId = item.lookId or fFlagAXPhotoboothMomentsPage and item.outfitId ~= nil

			if not (p2[item.assetTypeId] and lookId) then
				p2[item.assetTypeId] = {}
			end

			table.insert(p2[item.assetTypeId], defaultHumanoidDescriptionAccessoryInfo)
		elseif v6 then
			object[v6] = item.lookId and item.bundleId == tostring(module4.BlockyBundleId) and 0
				or item.assetId
		end
	end

	return p2
end

local function updateHumanoidDescriptionTryOnOutfitAsset(p2, sortOutfitTryOnItem, itemId, defaultHumanoidDescriptionAccessoryInfos, object)
	if not sortOutfitTryOnItem.selectedInTryOnManager then
		return
	end

	local itemSubType = sortOutfitTryOnItem.itemSubType

	if itemId and itemSubType ~= module4.AssetTypeIdStrings.Gear then
		local v6 = module4.AssetTypeIdStringToHumanoidDescriptionProp[itemSubType]

		if module4.AssetTypeIdToAccessoryTypeEnum[itemSubType] then
			local defaultHumanoidDescriptionAccessoryInfo = module5.createDefaultHumanoidDescriptionAccessoryInfo(
				itemSubType,
				itemId
			)

			if
				sortOutfitTryOnItem.order ~= nil
				and (not module11() or defaultHumanoidDescriptionAccessoryInfo.IsLayered)
			then
				defaultHumanoidDescriptionAccessoryInfo.Order = sortOutfitTryOnItem.order
			end

			defaultHumanoidDescriptionAccessoryInfo.Position = sortOutfitTryOnItem.position
			defaultHumanoidDescriptionAccessoryInfo.Rotation = sortOutfitTryOnItem.rotation
			defaultHumanoidDescriptionAccessoryInfo.Scale = sortOutfitTryOnItem.scale

			local isInLCSortIsRemovedTuple, v7 = getIsInLCSortIsRemovedTuple(p2, itemId)

			if not v7 then
				table.insert(
					defaultHumanoidDescriptionAccessoryInfos,
					defaultHumanoidDescriptionAccessoryInfo
				)
			end
		elseif v6 then
			object[v6] = itemId
		end
	end
end

local function updateHumanoidDescriptionTryOnOutfitBundle(p2, outfitInfoFromBundleId, sortOutfitTryOnItem, humanoidDescriptionAccessoryInfos, object)
	for k, asset in outfitInfoFromBundleId.assets do
		local v6 = module4.AssetTypeIdStringToHumanoidDescriptionProp[k]
		local v7 = v6 and k ~= module4.AssetTypeIdStrings.Gear

		if module4.AssetTypeIdToAccessoryTypeEnum[k] then
			for k2, v8 in asset do
				local humanoidDescriptionAccessoryInfo = module5.createHumanoidDescriptionAccessoryInfo(k, k2, v8)
				local bundleInfo = sortOutfitTryOnItem.bundleInfo

				if
					bundleInfo
					and bundleInfo[k2]
					and bundleInfo[k2].order ~= nil
					and (not module11() or humanoidDescriptionAccessoryInfo.IsLayered)
				then
					humanoidDescriptionAccessoryInfo.Order = bundleInfo[k2].order
				end

				if bundleInfo and bundleInfo[k2] then
					humanoidDescriptionAccessoryInfo.Position = bundleInfo[k2].position
					humanoidDescriptionAccessoryInfo.Rotation = bundleInfo[k2].rotation
					humanoidDescriptionAccessoryInfo.Scale = bundleInfo[k2].scale
				end

				local isInLCSortIsRemovedTuple, v9 = getIsInLCSortIsRemovedTuple(p2, k2)

				if not v9 then
					table.insert(humanoidDescriptionAccessoryInfos, humanoidDescriptionAccessoryInfo)
				end
			end
		elseif v7 then
			local keys = Cryo.Dictionary.keys(asset)
			object[v6] = table.concat(keys, ",")
		end
	end
end

local function updateHumanoidDescriptionTryOnItemBundle(p2, sortOutfitTryOnItem, defaultHumanoidDescriptionAccessoryInfos, object)
	local equippedAssetMapByHumanoidDescriptionProp = module9.buildEquippedAssetMapByHumanoidDescriptionProp(p2)

	assert(sortOutfitTryOnItem.bundleInfo, "tryOnBundleItem.bundleInfo is non-nil. Silence type checker.")

	for k, v6 in sortOutfitTryOnItem.bundleInfo do
		local v7 = module4.AssetTypeIdStringToHumanoidDescriptionProp[v6.assetType]

		local v8 = v7 and v6.assetType ~= module4.AssetTypeIdStrings.Gear

		if module4.AssetTypeIdToAccessoryTypeEnum[v6.assetType] then
			if sortOutfitTryOnItem.selectedInTryOnManager then
				local defaultHumanoidDescriptionAccessoryInfo = module5.createDefaultHumanoidDescriptionAccessoryInfo(
					v6.assetType,
					k
				)

				if v6.order ~= nil then
					defaultHumanoidDescriptionAccessoryInfo.Order = v6.order
				end

				local isInLCSortIsRemovedTuple, v9 = getIsInLCSortIsRemovedTuple(p2, k)

				if not v9 then
					table.insert(
						defaultHumanoidDescriptionAccessoryInfos,
						defaultHumanoidDescriptionAccessoryInfo
					)
				end
			end
		elseif v8 then
			object[v7] = sortOutfitTryOnItem.itemId == tostring(module4.BlockyBundleId) and 0 or k

			if not sortOutfitTryOnItem.selectedInTryOnManager then
				local equippedAsset = equippedAssetMapByHumanoidDescriptionProp[v7]

				object[v7] = 0

				if equippedAsset ~= nil then
					for k2, v9 in equippedAsset do
						for k3, v10 in v9 do
							object[v7] = k3
						end
					end
				end
			end
		end
	end
end

local function updateHumanoidDescriptionTryOnOutfitBundleNoUserOutfit(p2, sortOutfitTryOnItem, bundleInfoFromState, defaultHumanoidDescriptionAccessoryInfos)
	local assetInfos = p2.AvatarExperience.Common.AssetInfos
	local v6 = false

	if bundleInfoFromState.items == nil then
		return
	end

	assert(bundleInfoFromState.items, "bundleInfo.items is non-nil. Silence type checker.")

	for k, item in bundleInfoFromState.items do
		local assetInfo = assetInfos[item.id]

		if not (assetInfo and assetInfo.assetType) then
			v6 = true
		end
	end

	if not v6 then
		for k, item in bundleInfoFromState.items do
			local assetType = assetInfos[item.id].assetType

			local defaultHumanoidDescriptionAccessoryInfo = module5.createDefaultHumanoidDescriptionAccessoryInfo(
				assetType,
				item.id
			)
			local bundleInfo = sortOutfitTryOnItem.bundleInfo

			if
				bundleInfo
				and bundleInfo[item.id]
				and bundleInfo[item.id].order ~= nil
				and (not module11() or defaultHumanoidDescriptionAccessoryInfo.IsLayered)
			then
				defaultHumanoidDescriptionAccessoryInfo.Order = bundleInfo[item.id].order
			end

			local isInLCSortIsRemovedTuple, v7 = getIsInLCSortIsRemovedTuple(p2, item.id)

			if not v7 then
				table.insert(
					defaultHumanoidDescriptionAccessoryInfos,
					defaultHumanoidDescriptionAccessoryInfo
				)
			end
		end
	end
end

local function isHumanoidDescriptionPropertyEmpty(p2): boolean
	return p2 == "" or p2 == 0
end

function v5.isDHBundle(p2): boolean
	return p2.itemType == module4.ItemType.Bundle
		and (p2.itemSubType == Enum.BundleType.DynamicHead.Name or p2.itemSubType == module4.BundleTypeIdStrings.DynamicHead)
end

function v5.isDHBundleTryOn(p2): boolean
	for k, tryOnItem in p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if v5.isDHBundle(tryOnItem) then
			return true
		end
	end

	return false
end

function v5.isClassicHeadOrClassicFaceTryOn(p2): boolean
	for k, tryOnItem in p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if
			tryOnItem.itemSubType == module4.AssetTypeIdStrings.Head
			or tryOnItem.itemSubType == module4.AssetTypeIdStrings.Face
		then
			return true
		end
	end

	return false
end

local function setAccessoriesFromTryOn(p2, clone, humanoidDescription)
	local accessories = clone:GetAccessories(true)

	local accessories2 = humanoidDescription:GetAccessories(true)
	local v6

	if fFlagAXUseSignalsForLayeredClothingCurrentSort then
		v6 = getLayeredClothingCurrentSortStore(false).getRemovedList(false)
	else
		v6 = p2.AvatarExperience.LayeredClothingSort.CurrentSort.RemovedList
	end

	local set = {}
	local set2 = {}

	for k, accessory in accessories2 do
		local v8 = assetTypeToAssetCategory[module4.AccessoryTypeEnumToAssetTypeId[accessory.AccessoryType]]

		set[accessory.AccessoryType] = true

		if v8 then
			set2[v8] = true
		end
	end

	for k, v7 in v6 do
		local accessoryTypeEnum = module4.AssetTypeIdToAccessoryTypeEnum[v7]
		local v8 = assetTypeToAssetCategory[v7]

		if accessoryTypeEnum then
			set[accessoryTypeEnum] = true
		end

		if v8 then
			set2[v8] = true
		end
	end

	for k, accessory in accessories do
		local v7 = module4.AccessoryTypeEnumToAssetTypeId[accessory.AccessoryType]

		local v8 = not set[accessory.AccessoryType]

		local v9 = assetTypeToAssetCategory[v7]

		if v9 then
			v8 = not set2[v9]
		end

		if v5.isDHBundleTryOn(p2) and module4.DynamicHeadAssetTypes[v7] then
			v8 = false
		end

		if v8 then
			table.insert(accessories2, accessory)
		end
	end

	clone:SetAccessories(accessories2, true)
end

local function getTryOnsBundleOutfitInfo(p2)
	for k, tryOnItem in p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if not (tryOnItem.itemType == module4.ItemType.Bundle and tryOnItem.itemSubType == module4.BundleTypeIdStrings.BodyParts) then
			continue
		end

		local outfitInfoFromBundleId = module5.getOutfitInfoFromBundleId(p2, tryOnItem.itemId)

		if outfitInfoFromBundleId then
			return outfitInfoFromBundleId
		end
	end

	return nil
end

local function normalizeTryOnAsset(sortOutfitTryOnItem, p2)
	local isInLCSortIsRemovedTuple, v6 = getIsInLCSortIsRemovedTuple(p2, sortOutfitTryOnItem.itemId)
	local tryOnAsset = {
		assetId = sortOutfitTryOnItem.itemId,
		assetTypeId = sortOutfitTryOnItem.itemSubType,
		itemRecency = sortOutfitTryOnItem.itemRecency,
		lookId = sortOutfitTryOnItem.lookId,
		outfitId = 0,
		order = 0,
		isRemovedInLCSort = 0,
		position = 0,
		rotation = 0,
		scale = 0
	}
	local v7 = if fFlagAXPhotoboothMomentsPage then sortOutfitTryOnItem.outfitId else nil
	tryOnAsset.outfitId = v7
	tryOnAsset.order = sortOutfitTryOnItem.order
	tryOnAsset.isRemovedInLCSort = v6
	tryOnAsset.position = sortOutfitTryOnItem.position
	tryOnAsset.rotation = sortOutfitTryOnItem.rotation
	tryOnAsset.scale = sortOutfitTryOnItem.scale
	return tryOnAsset
end

local function getNormalizedAssetsFromTryOnBundle(data, p2)
	local outfitInfoFromBundleId = module5.getOutfitInfoFromBundleId(p2, data.itemId)
	local normalizedAssets = {}

	if data.bundleInfo and data.lookId ~= nil then
		for k, v6 in data.bundleInfo do
			local isInLCSortIsRemovedTuple, v7 = getIsInLCSortIsRemovedTuple(p2, k)
			local v8 = {
				assetId = k,
				assetTypeId = v6.assetType,
				itemRecency = data.itemRecency,
				lookId = data.lookId,
				order = v6.order,
				isRemovedInLCSort = v7,
				position = v6.position,
				rotation = v6.rotation,
				scale = v6.scale,
				bundleId = data.itemId,
				headShape = 0,
				staticFacialAnimation = 0
			}
			local v9 = if fFlagEnableHeadShapeForCharacterManager then v6.headShape else nil
			v8.headShape = v9

			local v10 = if fFlagHeadRefinementFacialAnimationToggle then v6.staticFacialAnimation else nil
			v8.staticFacialAnimation = v10
			table.insert(normalizedAssets, v8)
		end
	elseif outfitInfoFromBundleId and outfitInfoFromBundleId.assets then
		for k, asset in outfitInfoFromBundleId.assets do
			for k2, v6 in asset do
				local isInLCSortIsRemovedTuple, v7 = getIsInLCSortIsRemovedTuple(p2, k2)
				local v8 = not (data.bundleInfo and data.bundleInfo[k2]) and {} or data.bundleInfo[k2]
				local v9 = {
					assetId = k2,
					assetTypeId = k,
					itemRecency = data.itemRecency,
					lookId = data.lookId,
					order = v8.order,
					isRemovedInLCSort = v7,
					position = v8.position,
					rotation = v8.rotation,
					scale = v8.scale,
					bundleId = data.itemId,
					headShape = 0,
					staticFacialAnimation = 0
				}
				local v10 = if fFlagEnableHeadShapeForCharacterManager then v6.headShape else nil
				v9.headShape = v10

				local v11 = if fFlagHeadRefinementFacialAnimationToggle then v6.staticFacialAnimation else nil
				v9.staticFacialAnimation = v11
				table.insert(normalizedAssets, v9)
			end
		end
	elseif data.bundleInfo then
		for k, v6 in data.bundleInfo do
			local isInLCSortIsRemovedTuple, v7 = getIsInLCSortIsRemovedTuple(p2, k)
			local v8 = {
				assetId = k,
				assetTypeId = v6.assetType,
				itemRecency = data.itemRecency,
				lookId = data.lookId,
				order = v6.order,
				isRemovedInLCSort = v7,
				position = v6.position,
				rotation = v6.rotation,
				scale = v6.scale,
				bundleId = data.itemId,
				headShape = 0,
				staticFacialAnimation = 0
			}
			local v9 = if fFlagEnableHeadShapeForCharacterManager then v6.headShape else nil
			v8.headShape = v9

			local v10 = if fFlagHeadRefinementFacialAnimationToggle then v6.staticFacialAnimation else nil
			v8.staticFacialAnimation = v10
			table.insert(normalizedAssets, v8)
		end
	end

	return normalizedAssets
end

function v5:setAvatarTryOnProperties(p3)
	local bodyColor3s = p3.AvatarExperience.AvatarScene.OutfitTryOn.BodyColor3s
	local scale = p3.AvatarExperience.AvatarScene.OutfitTryOn.Scale

	local v6 = module6(p3)
	local v7 = module7(p3)

	if not v6 then
		v7 = bodyColor3s
	end

	if v7 then
		module.setHumanoidDescriptionColorsFromBodyColor3s(self, v7)
	end

	if scale ~= nil then
		for k, v8 in scale do
			self[module4.HumanoidDescriptionScaleToName[k]] = v8
		end
	end
end

function v5:resetHumanoidDescriptionProperties()
	for k, v6 in module4.AssetTypeIdStringToHumanoidDescriptionProp do
		local typeName = typeof(self[v6])

		if typeName == "string" then
			self[v6] = ""
		elseif typeName == "number" then
			self[v6] = 0
		end
	end
end

if fFlagEnableHeadShapeForCharacterManager then
	function v5.getHeadShapeFromTryOn(p2)
		local tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
		local lookId = p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId
		local v6 = false

		for k, tryOnItem in tryOnItems do
			local outfitInfoFromBundleId = module5.getOutfitInfoFromBundleId(p2, tryOnItem.itemId)
			local bundleInfo = tryOnItem.bundleInfo
			local v7

			if fFlagAXMISEnableMultiShopping then
				v7 = getNormalizedAssetsFromTryOnBundle(tryOnItem, p2)
			end

			if outfitInfoFromBundleId and lookId == nil then
				for k2, asset in outfitInfoFromBundleId.assets do
					if k2 ~= module4.AssetTypeIdStrings.DynamicHead then
						continue
					end

					v6 = true

					for k3, v8 in asset do
						if v8.headShape then
							return v8.headShape, v6
						end
					end
				end
			end

			if fFlagAXMISEnableMultiShopping and v7 then
				for k2, v8 in v7 do
					if v8.assetTypeId ~= module4.AssetTypeIdStrings.DynamicHead then
						continue
					end

					v6 = true

					if v8.headShape then
						return v8.headShape, true
					end
				end
			end

			if bundleInfo then
				for k2, v8 in bundleInfo do
					if v8.assetType ~= module4.AssetTypeIdStrings.DynamicHead then
						continue
					end

					v6 = true

					if v8.headShape then
						return v8.headShape, true
					end
				end
			end

			if not (fFlagAXTryOnWithoutEquippedBody and tryOnItem.outfitId ~= nil and tryOnItem.itemType == module4.ItemType.Asset and tryOnItem.itemSubType == module4.AssetTypeIdStrings.DynamicHead) then
				continue
			end

			v6 = true

			if tryOnItem.headShape then
				return tryOnItem.headShape, true
			end
		end

		return nil, v6
	end

	function v5.getHeadShapeFromEquippedAssets(p2)
		local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets

		if not equippedAssets then
			return nil
		end

		for k, equippedAsset in equippedAssets do
			if k ~= module4.AssetTypeIdStrings.DynamicHead then
				continue
			end

			for k2, v6 in equippedAsset do
				return v6.headShape
			end
		end

		return nil
	end

	if fFlagHeadRefinementFacialAnimationToggle then
		function v5.getStaticFacialAnimationFromEquippedAssets(p2)
			local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets

			if not equippedAssets then
				return nil
			end

			local equippedAsset = equippedAssets[module4.AssetTypeIdStrings.DynamicHead]

			if equippedAsset then
				for k, v6 in equippedAsset do
					return v6.staticFacialAnimation
				end
			end

			return nil
		end

		function v5.getStaticFacialAnimationFromTryOn(p2)
			for k, tryOnItem in p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
				local outfitInfoFromBundleId = module5.getOutfitInfoFromBundleId(p2, tryOnItem.itemId)
				local bundleInfo = tryOnItem.bundleInfo
				local v6

				if fFlagAXMISEnableMultiShopping then
					v6 = getNormalizedAssetsFromTryOnBundle(tryOnItem, p2)
				end

				if outfitInfoFromBundleId then
					for k2, asset in outfitInfoFromBundleId.assets do
						if k2 ~= module4.AssetTypeIdStrings.DynamicHead then
							continue
						end

						for k3, v7 in asset do
							if v7.staticFacialAnimation ~= nil then
								return v7.staticFacialAnimation
							end
						end
					end
				end

				if fFlagAXMISEnableMultiShopping and v6 then
					for k2, v7 in v6 do
						if
							v7.assetTypeId == module4.AssetTypeIdStrings.DynamicHead
							and v7.staticFacialAnimation ~= nil
						then
							return v7.staticFacialAnimation
						end
					end
				end

				if bundleInfo then
					for k2, v7 in bundleInfo do
						if
							v7.assetType == module4.AssetTypeIdStrings.DynamicHead
							and v7.staticFacialAnimation ~= nil
						then
							return v7.staticFacialAnimation
						end
					end
				end

				if
					fFlagAXTryOnWithoutEquippedBody
					and tryOnItem.outfitId ~= nil
					and tryOnItem.itemType == module4.ItemType.Asset
					and tryOnItem.itemSubType == module4.AssetTypeIdStrings.DynamicHead
					and tryOnItem.staticFacialAnimation ~= nil
				then
					return tryOnItem.staticFacialAnimation
				end
			end

			return nil
		end
	end

	if fFlagFixHeadShapeColorSlider then
		function v5.getHeadShapeFromAssetMetadata(items)
			for k, item in items do
				if item.headShape and (not fFlagAXFixR6DefaultHeadShape or item.headShape ~= "Default") then
					return item.headShape
				end
			end

			return nil
		end

		function v5.applyHeadShapeFromAssetMetadata(instance, p2)
			local keys = Cryo.Dictionary.keys(p2)

			for i, bodyPartDescription in instance:GetChildren() do
				if not (bodyPartDescription:IsA("BodyPartDescription") and bodyPartDescription.BodyPart == Enum.BodyPart.Head) then
					continue
				end

				local headShapeFromAssetMetadata = v5.getHeadShapeFromAssetMetadata(p2)

				if headShapeFromAssetMetadata then
					bodyPartDescription.HeadShape = headShapeFromAssetMetadata
				end

				bodyPartDescription.AssetId = tonumber(keys[1]) or 0
			end
		end
	end

	function v5:applyHeadShapeToHumanoidDescription(p2)
		local headShapeFromTryOn, v6 = v5.getHeadShapeFromTryOn(p2)
		local headShapeFromEquippedAssets = v5.getHeadShapeFromEquippedAssets(p2)
		local v7 = nil
		local v8

		if fFlagAXTryOnWithoutEquippedBody then
			v8 = v5.shouldTryOnWithoutEquippedBody(p2)

			if v8 then
				for i, bodyPartDescription in self:GetChildren() do
					if not (bodyPartDescription:IsA("BodyPartDescription") and bodyPartDescription.BodyPart == Enum.BodyPart.Head) then
						continue
					end

					bodyPartDescription.AssetId = self.Head

					bodyPartDescription.HeadShape = ""
				end
			end
		else
			v8 = false
		end

		if fFlagHeadRefinementFacialAnimationToggle then
			local v9 = if v6 then v5.getStaticFacialAnimationFromTryOn(p2) else nil

			if fFlagAXTryOnWithoutEquippedBody then
				if v9 == nil then
					v9 = not v8 and v5.getStaticFacialAnimationFromEquippedAssets(p2)
				end
			elseif v9 == nil then
				v9 = v5.getStaticFacialAnimationFromEquippedAssets(p2)
			end

			if v9 ~= nil then
				self[module4.StaticFacialAnimation] = v9
			end
		end

		if fFlagAXTryOnWithoutEquippedBody then
			if v6 then
				v7 = headShapeFromTryOn
			elseif not v8 then
				v7 = headShapeFromEquippedAssets
			end
		else
			v7 = if v6 then headShapeFromTryOn else headShapeFromEquippedAssets
		end

		if v7 == "Default" then
			v7 = nil
		end

		if v7 then
			for i, bodyPartDescription in self:GetChildren() do
				if
					bodyPartDescription:IsA("BodyPartDescription")
					and bodyPartDescription.BodyPart == Enum.BodyPart.Head
					and v7
				then
					bodyPartDescription.HeadShape = v7
				end
			end
		end
	end
end

function v5.updateHumanoidDescriptionUsingOutfitTryOn(p2, object, items)
	if module10() then
		v5.resetHumanoidDescriptionProperties(object)
	else
		for k, v6 in module4.AssetTypeIdStringToHumanoidDescriptionProp do
			object[v6] = ""
		end
	end

	object:SetAccessories({}, true)

	local tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local lookType = p2.AvatarExperience.AvatarScene.OutfitTryOn.LookType

	local sortOutfitTryOnItemsByRecency = module5.sortOutfitTryOnItemsByRecency(tryOnItems, false)

	local v6 = {}
	local v7 = {}

	for k, tryOnItem in tryOnItems do
		if not (tryOnItem.selectedInTryOnManager and tryOnItem.itemType == module4.ItemType.Asset) then
			continue
		end

		local itemSubType = tryOnItem.itemSubType

		if not isMakeupAssetType(itemSubType) then
			continue
		end

		if not v6[itemSubType] then
			v6[itemSubType] = {}
		end

		v6[itemSubType][tryOnItem.itemId] = tryOnItem
	end

	setMakeupDescriptions(object, v6)

	if fFlagAXMISEnableMultiShopping then
		local itemIdSet = {}

		if items then
			for k, item in items do
				itemIdSet[item.itemId] = true
			end
		end

		local v8 = {}

		for k, sortOutfitTryOnItem in sortOutfitTryOnItemsByRecency do
			if not (sortOutfitTryOnItem.selectedInTryOnManager ~= false and (not items or itemIdSet[sortOutfitTryOnItem.itemId])) then
				continue
			end

			if sortOutfitTryOnItem.itemType == module4.ItemType.Asset then
				table.insert(v8, normalizeTryOnAsset(sortOutfitTryOnItem, p2))
			elseif sortOutfitTryOnItem.itemType == module4.ItemType.Bundle then
				local normalizedAssetsFromTryOnBundle = getNormalizedAssetsFromTryOnBundle(sortOutfitTryOnItem, p2)

				for k2, v10 in normalizedAssetsFromTryOnBundle do
					table.insert(v8, v10)
				end
			end
		end

		local v10

		if fFlagAXTryOnWithoutEquippedBody then
			v10 = v5.shouldTryOnWithoutEquippedBody(p2) and {}
				or module9.buildEquippedAssetMapByHumanoidDescriptionProp(p2)
		else
			v10 = module9.buildEquippedAssetMapByHumanoidDescriptionProp(p2)
		end

		local v11 = updateHumanoidDescriptionTryOnFromNormalizedAssets(object, {}, v8, v10)

		v5.tryApplyClassicHeadShapeTryOn(p2, object)

		local v12 = {}

		for k, v13 in v11 do
			for k2, v14 in v13 do
				table.insert(v12, v14)
			end
		end

		object:SetAccessories(v12, true)
	else
		for k, sortOutfitTryOnItem in sortOutfitTryOnItemsByRecency do
			if not (sortOutfitTryOnItem.selectedInTryOnManager or lookType == module4.LookType.Avatar and (not fFlagAXCatalogMakeupSupport or lookType == module4.LookType.Makeup)) then
				continue
			end

			if sortOutfitTryOnItem.itemType == module4.ItemType.Asset then
				updateHumanoidDescriptionTryOnOutfitAsset(
					p2,
					sortOutfitTryOnItem,
					sortOutfitTryOnItem.itemId,
					v7,
					object
				)
			elseif sortOutfitTryOnItem.itemType == module4.ItemType.Bundle then
				local bundleInfoFromState = module5.getBundleInfoFromState(p2, sortOutfitTryOnItem.itemId)
				local outfitInfoFromBundleId = module5.getOutfitInfoFromBundleId(
					p2,
					sortOutfitTryOnItem.itemId
				)

				if outfitInfoFromBundleId then
					updateHumanoidDescriptionTryOnOutfitBundle(
						p2,
						outfitInfoFromBundleId,
						sortOutfitTryOnItem,
						v7,
						object
					)
				elseif
					sortOutfitTryOnItem.bundleInfo == nil
					or lookType ~= module4.LookType.Avatar
					and (not fFlagAXCatalogMakeupSupport or lookType ~= module4.LookType.Makeup)
				then
					if bundleInfoFromState then
						updateHumanoidDescriptionTryOnOutfitBundleNoUserOutfit(
							p2,
							sortOutfitTryOnItem,
							bundleInfoFromState,
							v7
						)
					end
				else
					updateHumanoidDescriptionTryOnItemBundle(p2, sortOutfitTryOnItem, v7, object)
				end
			end
		end

		v5.tryApplyClassicHeadShapeTryOn(p2, object)

		object:SetAccessories(v7, true)
	end
end

function v5.makeupAssetsTryOn(p2, parent, p3)
	local makeupDescriptionsFromHumanoidDescription = getMakeupDescriptionsFromHumanoidDescription(p3)

	if #makeupDescriptionsFromHumanoidDescription == 0 then
		return
	end

	local tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	local makeupDescriptionsFromHumanoidDescription2 = getMakeupDescriptionsFromHumanoidDescription(parent)

	if fFlagAXUseSignalsForLayeredClothingCurrentSort then
		local orderedList = getLayeredClothingCurrentSortStore(false).getOrderedList(false)

		if #orderedList > 0 then
			makeupDescriptionsFromHumanoidDescription2 = Cryo.List.filter(
				makeupDescriptionsFromHumanoidDescription2,
				function(p4): boolean
					for k, ordered in orderedList do
						if tostring(ordered.id) == tostring(p4.AssetId) then
							return true
						end
					end

					return false
				end
			)
		end
	elseif
		p2.AvatarExperience.LayeredClothingSort
		and p2.AvatarExperience.LayeredClothingSort.CurrentSort
		and #p2.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList > 0
	then
		local orderedList = p2.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList

		makeupDescriptionsFromHumanoidDescription2 = Cryo.List.filter(
			makeupDescriptionsFromHumanoidDescription2,
			function(p4): boolean
				for k, ordered in orderedList do
					if tostring(ordered.id) == tostring(p4.AssetId) then
						return true
					end
				end

				return false
			end
		)
	end

	table.sort(makeupDescriptionsFromHumanoidDescription2, function(a, b): boolean
		return a.Order < b.Order
	end)

	local assetIdSet = {}

	for k, v6 in makeupDescriptionsFromHumanoidDescription2 do
		assetIdSet[v6.AssetId] = true
	end

	local v6 = {}

	for k, v7 in makeupDescriptionsFromHumanoidDescription do
		if assetIdSet[v7.AssetId] then
			continue
		end

		local tryOnItem = tryOnItems[getTryOnItemReducerKey(tostring(v7.AssetId), module4.ItemType.Asset)]

		local v8 = if tryOnItem then tryOnItem.order else MAX_MAKEUP_LAYERS
		v7.Order = v8
		table.insert(v6, v7)
	end

	local v7 = not (#makeupDescriptionsFromHumanoidDescription2 + #v6 <= MAX_MAKEUP_LAYERS)
		and { table.unpack(
				makeupDescriptionsFromHumanoidDescription2,
				#makeupDescriptionsFromHumanoidDescription2 + #v6 - MAX_MAKEUP_LAYERS + 1
			) }
		or makeupDescriptionsFromHumanoidDescription2

	for k, v8 in v6 do
		table.insert(v7, v8)
	end

	table.sort(v7, function(a, b): boolean
		if a.Order ~= b.Order then
			return a.Order < b.Order
		end

		local tryOnItemReducerKey = getTryOnItemReducerKey(tostring(a.AssetId), module4.ItemType.Asset)
		local tryOnItemReducerKey2 = getTryOnItemReducerKey(tostring(b.AssetId), module4.ItemType.Asset)

		if not (tryOnItems[tryOnItemReducerKey] or tryOnItems[tryOnItemReducerKey2]) then
			return false
		end

		if not tryOnItems[tryOnItemReducerKey] then
			return true
		end

		if tryOnItems[tryOnItemReducerKey2] then
			return tryOnItems[tryOnItemReducerKey].itemRecency < tryOnItems[tryOnItemReducerKey2].itemRecency
		end

		return false
	end)

	local clones = {}

	for k, v8 in v7 do
		table.insert(clones, v8:Clone())
	end

	destroyMakeupDescriptions(parent)

	for k, v8 in clones do
		v8.Order = k - 1
		v8.Parent = parent
	end
end

function v5.singleMakeupAssetTryOn(p2, parent, p3)
	local v6 = getMakeupDescriptionsFromHumanoidDescription(p3)[1]

	if not v6 then
		return
	end

	local tryOnItem = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems[getTryOnItemReducerKey(
		tostring(v6.AssetId),
		module4.ItemType.Asset
	)]

	local makeupDescriptionsFromHumanoidDescription = getMakeupDescriptionsFromHumanoidDescription(parent)

	table.sort(makeupDescriptionsFromHumanoidDescription, function(a, b): boolean
		return a.Order < b.Order
	end)

	for k, v7 in makeupDescriptionsFromHumanoidDescription do
		if v7.AssetId == v6.AssetId then
			return
		end
	end

	if not (#makeupDescriptionsFromHumanoidDescription < MAX_MAKEUP_LAYERS) then
		table.remove(makeupDescriptionsFromHumanoidDescription, 1)
	end

	local order = if tryOnItem then tryOnItem.order else nil
	local v7 = #makeupDescriptionsFromHumanoidDescription

	if order ~= nil then
		v7 = math.max(0, (math.min(order, v7)))
	end

	local v8 = {}

	for k, v9 in makeupDescriptionsFromHumanoidDescription do
		table.insert(v8, v9:Clone())
	end

	table.insert(v8, v7 + 1, v6)

	destroyMakeupDescriptions(parent)

	for k, v9 in v8 do
		v9.Order = k - 1
		v9.Parent = parent
	end
end

function v5.lookMakeupTryOn(parent, p2)
	destroyMakeupDescriptions(parent)

	for k, v6 in getMakeupDescriptionsFromHumanoidDescription(p2) do
		local clone = v6:Clone()
		clone.Parent = parent
	end
end

function v5.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn(p2, p3)
	local humanoidDescription = Instance.new("HumanoidDescription")
	v5.updateHumanoidDescriptionUsingOutfitTryOn(p2, humanoidDescription, p3)

	local clone = module.getHumanoidDescriptionFromState(p2.AvatarExperience):Clone()

	local lookId = p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId
	local v6

	if fFlagAXPhotoboothMomentsPage then
		v6 = v5.isTryingOnWholeAvatar(p2)
	else
		v6 = p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId ~= nil
	end

	local v7 = v6 and p2.AvatarExperience.AvatarScene.OutfitTryOn.LookType == module4.LookType.Makeup
	local v8

	if fFlagAXMISEnableMultiShopping then
		v7 = p2.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId ~= nil

		v8 = p2.AvatarExperience.AvatarScene.OutfitTryOn.ShouldTryOnWithoutEquippedItems
	else
		v8 = v6 and not v7
	end

	if v8 then
		clone:SetAccessories({}, true)
		clone.GraphicTShirt = 0
		clone.Shirt = 0
		clone.Pants = 0

		if fFlagAXCatalogMakeupSupport then
			destroyMakeupDescriptions(clone)
		end
	end

	for k, v9 in module4.AssetTypeIdStringToHumanoidDescriptionProp do
		if
			module4.AssetTypeIdToCategory[k] == module4.AssetCategories.Body
			and module9.shouldUnequipBodyBeforeTryOn(p2)
		then
			clone[v9] = 0
		end

		if module4.AssetTypeIdToAccessoryTypeEnum[k] then
			continue
		end

		local v10 = humanoidDescription[v9]

		if v10 ~= "" and v10 ~= 0 then
			clone[v9] = humanoidDescription[v9]
		end
	end

	setAccessoriesFromTryOn(p2, clone, humanoidDescription)

	if v6 or v7 then
		v5.lookMakeupTryOn(clone, humanoidDescription)
	elseif fFlagAXMISEnableMultiShopping then
		v5.makeupAssetsTryOn(p2, clone, humanoidDescription)
	else
		v5.singleMakeupAssetTryOn(p2, clone, humanoidDescription)
	end

	local tryOnsBundleOutfitInfo = getTryOnsBundleOutfitInfo(p2)

	if tryOnsBundleOutfitInfo then
		for k, scale in tryOnsBundleOutfitInfo.scales do
			clone[module4.HumanoidDescriptionScaleToName[k]] = scale
		end

		module.setHumanoidDescriptionColorsFromBodyColor3s(clone, tryOnsBundleOutfitInfo.bodyColor3s)
	end

	v5.setAvatarTryOnProperties(clone, p2)

	if fFlagEnableHeadShapeForCharacterManager then
		v5.applyHeadShapeToHumanoidDescription(clone, p2)
	end

	return clone
end

if fFlagAXMISEnableMultiShopping then
	function v5.getBundleOutfitInfoFromProvidedTryOns(p2, items)
		for k, item in items do
			if not (item.itemType == module4.ItemType.Bundle and item.itemSubType == module4.BundleTypeIdStrings.BodyParts) then
				continue
			end

			local outfitInfoFromBundleId = module5.getOutfitInfoFromBundleId(p2, item.itemId)

			if outfitInfoFromBundleId then
				return outfitInfoFromBundleId
			end
		end

		return nil
	end
end

return v5
