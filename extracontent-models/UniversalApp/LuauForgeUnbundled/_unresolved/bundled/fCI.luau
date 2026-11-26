local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local module = require("@luauforge/bundled/dzP")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module3 = require("@luauforge/bundled/dFs")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local module4 = require("@luauforge/bundled/dRg")
local module5 = require("@luauforge/bundled/dPN")
local module6 = require("@luauforge/bundled/fCe")
local getMessageFadeSequence = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsChat/FriendsChat/ConversationWindow/getMessageFadeSequence")
require("@luauforge/bundled/dPs")
local module8 = require("@luauforge/bundled/dRz")
require("@luauforge/bundled/dKU")
require("@luauforge/bundled/fCn")
require("@luauforge/bundled/dRd")
require("@luauforge/bundled/dKV")

local avatarEditorCategories = require("@luauforge/bundled/dPt").Enums.AvatarEditorCategories

local avatarEditorSubcategories = require("@luauforge/bundled/dPt").Enums.AvatarEditorSubcategories

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local setMakeupDescriptions = AvatarExperienceCommon.Utils.setMakeupDescriptions
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType
local isSpawnEffectAssetType = AvatarExperienceCommon.Utils.isSpawnEffectAssetType
local isLayeredClothingAssetType = AvatarExperienceCommon.Utils.isLayeredClothingAssetType
local normalizeBackgroundId = AvatarExperienceCommon.Backgrounds.normalizeBackgroundId
local selectActiveBackground = AvatarExperienceCommon.Backgrounds.selectActiveBackground

local module10 = require("@luauforge/bundled/fCJ")
local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local fFlagAXFixOutfitEquipCheckEmptyArray = AvatarExperienceFlags.FFlagAXFixOutfitEquipCheckEmptyArray
local fFlagAXSpawnEffectSaveRoundTrip = AvatarExperienceFlags.FFlagAXSpawnEffectSaveRoundTrip

local v5 = {}
local module11 = require("@luauforge/bundled/fCK")
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local fFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local fFlagAXMigrateOutfitsToUserInventory = AvatarExperienceFlags.FFlagAXMigrateOutfitsToUserInventory
local fFlagAXBackgroundsOutfitHighlight = AvatarExperienceFlags.FFlagAXBackgroundsOutfitHighlight

local fFlagEnableSplitPaneAvatarOverlay = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPaneAvatarOverlay
local fFlagAXIgnoreHeadShapeSupportInOutfitCheck = AvatarExperienceFlags.FFlagAXIgnoreHeadShapeSupportInOutfitCheck

v5.ReverseKeyValuePairs = memoize(function(items)
	local result = {}

	for k, item in items do
		if not result[item] then
			result[item] = 0
		end
	end

	return result
end)

function v5.Contains(p2, p3): boolean
	if v5.ReverseKeyValuePairs(p2)[p3] then
		return true
	end

	return false
end

function v5.isFullyQualifiedOutfit(items): boolean
	local v6 = {
		Torso = module5.AssetTypeIdStrings.Torso,
		RightArm = module5.AssetTypeIdStrings.RightArm,
		LeftArm = module5.AssetTypeIdStrings.LeftArm,
		LeftLeg = module5.AssetTypeIdStrings.LeftLeg,
		RightLeg = module5.AssetTypeIdStrings.RightLeg
	}

	if module11 and not items then
		return false
	end

	for k, v7 in v6 do
		if not items[v7] then
			return false
		end
	end

	for k, item in items do
		if
			module5.AssetTypeIdToAccessoryTypeEnum[k] ~= Enum.AccessoryType.Hair
			and (module5.AssetTypeIdToAccessoryTypeEnum[k] or k == module5.AssetTypeIdStrings.Gear)
		then
			return true
		end
	end

	return false
end

function v5.isWearingDynamicHeadOutfit(p2, p3): boolean
	local equippedAssetIds = v5.getEquippedAssetIds(p2.assets)

	if not p3 then
		return false
	end

	for k, asset in p2.assets do
		if not p3[k] then
			return false
		end

		local v6 = next(p3[k])

		if not next(p2.assets[k]) then
			continue
		end

		local v7 = false

		for k2, equippedAssetId in equippedAssetIds do
			if equippedAssetId == v6 then
				v7 = true
			end
		end

		if not v7 then
			return false
		end
	end

	if p2.assets[module5.AssetTypeIdStrings.DynamicHead] then
		return true
	end

	return false
end

function v5.getAssetMetadata(p2, items)
	for k, item in items do
		for k2, v6 in item do
			if p2 == k2 then
				if not fFlagAXInventoryDurablesSupport then
					return v6
				end

				local clone = table.clone(v6)
				clone.availabilityStatus = nil
				return clone
			end
		end
	end

	return nil
end

function v5.isSameAssetMetadata(items, p2): boolean
	if items == nil and p2 == nil then
		return true
	end

	if items == nil or p2 == nil then
		return false
	end

	local keys = Cryo.Dictionary.keys(items)
	local keys2 = Cryo.Dictionary.keys(p2)

	if #keys ~= #keys2 then
		return false
	end

	for k, item in items do
		local v6 = p2[k]

		if typeof(item) == "Vector3" and typeof(v6) == "Vector3" then
			if not (module6.fuzzyEq(item.X, v6.X) and module6.fuzzyEq(item.Y, v6.Y) and module6.fuzzyEq(item.Z, v6.Z)) then
				return false
			end
		elseif item ~= v6 then
			return false
		end
	end

	return true
end

function v5.removeEmoteAnimationAsset(p2)
	if not p2[module5.AssetTypeIdStrings.EmoteAnimation] then
		return p2
	end

	return Cryo.Dictionary.join(p2, {
		[module5.AssetTypeIdStrings.EmoteAnimation] = Cryo.None
	})
end

function v5.getEquippedAssetIds(p2)
	local equippedAssetIds = {}

	if not p2 then
		return equippedAssetIds
	end

	for k, assetTypeIdString in module5.AssetTypeIdStrings do
		local v6 = p2[assetTypeIdString]

		if not v6 then
			continue
		end

		for k2, v7 in v6 do
			table.insert(equippedAssetIds, k2)
		end
	end

	return equippedAssetIds
end

function v5.getEquippedAssetIdsForType(p2, p3)
	local equippedAssetIdsForType = {}

	if not p2 then
		return equippedAssetIdsForType
	end

	local v6 = p2[p3]

	if v6 then
		for k, v7 in v6 do
			table.insert(equippedAssetIdsForType, k)
		end
	end

	return equippedAssetIdsForType
end

function v5.getEquippedAssetIdsForCategory(p2, p3)
	local equippedAssetIdsForCategory = {}

	if not p3.AssetTypeIdStrings then
		return equippedAssetIdsForCategory
	end

	for k, assetTypeIdString in p3.AssetTypeIdStrings do
		local equippedAssetIdsForType = v5.getEquippedAssetIdsForType(p2, assetTypeIdString)

		for k2, v6 in equippedAssetIdsForType do
			equippedAssetIdsForCategory[#equippedAssetIdsForCategory + 1] = v6
		end
	end

	return equippedAssetIdsForCategory
end

function v5.isAssetEquipped(p2, p3, p4): boolean
	if not p4 then
		return false
	end

	local v6 = p4[p3]

	if v6 == nil or not next(v6) then
		return false
	end

	if v6[p2] then
		return true
	end

	return false
end

function v5.isPresetOutfit(p2): boolean
	return not p2.isEditable
end

function v5.isDuplicateOutfitName(p2, p3, p4, p5, p6): boolean
	local v6 = string.lower(utf8.nfdnormalize(p4))
	local v7

	if fFlagAXOutfitPageRevamp and p5 then
		v7 = v5.getOutfitSubtypeKey(p5, true)
	else
		v7 = module4.EditableCharacterKey
	end

	for k, v8 in p2[v7] or {} do
		local v9 = tostring(v8)

		if
			(not fFlagAXOutfitPageRevamp or not p6 or v9 ~= p6)
			and p3[v9]
			and string.lower(utf8.nfdnormalize(p3[v9].name)) == v6
		then
			return true
		end
	end

	return false
end

local function diffListTruncated(p2, p3)
	local set = Cryo.List.toSet(p3)
	return (Cryo.List.filter(p2, function(p4, p5): boolean
		return not set[p4]
	end))
end

function v5.diffList(p2, p3)
	local set = Cryo.List.toSet(p3)
	local filtered = Cryo.List.filter(p2, function(p4, p5): boolean
		return not set[p4]
	end)
	local set2 = Cryo.List.toSet(p2)
	local filtered2 = Cryo.List.filter(p3, function(p4, p5): boolean
		return not set2[p4]
	end)

	return (Cryo.List.join(filtered, filtered2))
end

function v5.getEquippedDiffs(items, items2)
	local equippedDiffs = {}

	for k, item in items2 do
		local equippedAssetIdsForType = v5.getEquippedAssetIdsForType(items2, k)
		local equippedAssetIdsForType2 = v5.getEquippedAssetIdsForType(items, k)

		if next(equippedAssetIdsForType2) then
			local diffList = v5.diffList(equippedAssetIdsForType, equippedAssetIdsForType2)

			if next(diffList) ~= nil then
				equippedDiffs[k] = diffList
			end
		elseif next(equippedAssetIdsForType) then
			equippedDiffs[k] = equippedAssetIdsForType
		end
	end

	for k, item in items do
		local equippedAssetIdsForType = v5.getEquippedAssetIdsForType(items, k)
		local equippedAssetIdsForType2 = v5.getEquippedAssetIdsForType(items2, k)

		if next(equippedAssetIdsForType2) then
			local diffList = v5.diffList(equippedAssetIdsForType, equippedAssetIdsForType2)

			if next(diffList) ~= nil then
				equippedDiffs[k] = diffList
			end
		elseif next(equippedAssetIdsForType) then
			equippedDiffs[k] = equippedAssetIdsForType
		end
	end

	return equippedDiffs
end

function v5.isDynamicHeadEquipped(p2): boolean
	return not Cryo.isEmpty(v5.getEquippedAssetIdsForType(p2, module5.AssetTypeIdStrings.DynamicHead))
end

function v5.isClassicHeadEquipped(p2): boolean
	return not Cryo.isEmpty(v5.getEquippedAssetIdsForType(p2, module5.AssetTypeIdStrings.Head))
end

function v5.hasWrapLayer(instance): boolean
	if instance then
		return instance:FindFirstChildWhichIsA("WrapLayer", true) ~= nil
	end

	return false
end

v5.hasLayeredAssetsEquipped = memoize(function(items): boolean
	if not items then
		return false
	end

	for k, item in items do
		for k2, v6 in item do
			if v6.isLayered then
				return true
			end
		end
	end

	return false
end)

function v5:setHumanoidDescriptionColorsFromBodyColor3s(items)
	if items then
		for k, item in items do
			self[module5.BodyPartForSkinColoringIdToHumanoidDescription[k]] = item
		end
	end
end

function v5.setHumanoidDescriptionColorsFromCharacter(p2, p3)
	v5.setHumanoidDescriptionColorsFromBodyColor3s(p2, p3.AvatarEditor.Character.BodyColor3s)
end

function v5.getGearAssetIdFromState(p2)
	if not module10() then
		return 0
	end

	local equippedAssets = p2.AvatarEditor.Character.EquippedAssets

	if equippedAssets == nil then
		return 0
	end

	local equippedAssetIdsForType = v5.getEquippedAssetIdsForType(
		equippedAssets,
		module5.AssetTypeIdStrings.Gear
	)
	local v6, v7 = next(equippedAssetIdsForType)

	if v7 then
		return (tonumber(v7))
	end

	return 0
end

function v5.getHumanoidDescriptionFromState(p2)
	local humanoidDescription = Instance.new("HumanoidDescription")
	local equippedAssets = p2.AvatarEditor.Character.EquippedAssets
	local avatarScales = p2.AvatarEditor.Character.AvatarScales

	local staticFacialAnimation = nil

	if equippedAssets then
		local v6 = {}

		for k, equippedAsset in equippedAssets do
			local accessoryTypeEnum = module5.AssetTypeIdToAccessoryTypeEnum[k]
			local v7 = {}

			for k2, v8 in equippedAsset do
				if accessoryTypeEnum then
					table.insert(v6, module6.createHumanoidDescriptionAccessoryInfo(k, k2, v8))
				else
					table.insert(v7, k2)
				end
			end

			if not (accessoryTypeEnum == nil and #v7 > 0) then
				continue
			end

			local v8 = module5.AssetTypeIdStringToHumanoidDescriptionProp[k]
			local joined = table.concat(v7, ",")

			if v8 then
				if fFlagParseHeadShapeFromAPIResponse and module5.BodyPartNameToEnum[v8] then
					local bodyPartDescription = Instance.new("BodyPartDescription")
					bodyPartDescription.AssetId = joined
					bodyPartDescription.Parent = humanoidDescription
					bodyPartDescription.BodyPart = module5.BodyPartNameToEnum[v8]

					if k == module5.AssetTypeIdStrings.DynamicHead then
						local headShape = nil

						for k2, v10 in v7 do
							local v11 = equippedAsset[v10]

							if
								fFlagHeadRefinementFacialAnimationToggle
								and v11
								and v11.staticFacialAnimation ~= nil
							then
								staticFacialAnimation = v11.staticFacialAnimation
							end

							if v11 and v11.headShape then
								headShape = if v11.headShape ~= "Default" then v11.headShape else nil
								break
							end
						end

						if headShape then
							bodyPartDescription.HeadShape = headShape
						end
					end
				else
					humanoidDescription[v8] = joined
				end
			elseif
				k ~= module5.AssetTypeIdStrings.Gear
				and not (isMakeupAssetType(k) or fFlagAXSpawnEffectSaveRoundTrip and isSpawnEffectAssetType(k))
			then
				module3(string.format(
					"assetTypeId: %s not recognized as member of humanoidDescription",
					(tostring(k))
				))
			end
		end

		humanoidDescription:SetAccessories(v6, true)
		setMakeupDescriptions(humanoidDescription, equippedAssets)

		if fFlagHeadRefinementFacialAnimationToggle and staticFacialAnimation ~= nil then
			humanoidDescription[module5.StaticFacialAnimation] = staticFacialAnimation
		end
	end

	if avatarScales then
		for k, avatarScale in avatarScales do
			humanoidDescription[module5.HumanoidDescriptionScaleToName[k]] = avatarScale
		end
	end

	v5.setHumanoidDescriptionColorsFromCharacter(humanoidDescription, p2)

	local v6 = {}
	local v7 = {}

	for k, v8 in p2.AvatarEditor.EquippedEmotes.slotInfo do
		v6[tostring(v8.assetId)] = { (tonumber(v8.assetId)) }
		table.insert(v7, { Slot = v8.position, Name = tostring(v8.assetId) })
	end

	humanoidDescription:SetEmotes(v6)
	humanoidDescription:SetEquippedEmotes(v7)

	return humanoidDescription
end

function v5.getHumanoidDescriptionFromOutfitInfo(data)
	local humanoidDescription = Instance.new("HumanoidDescription")
	local assets = data.assets
	local scales = data.scales

	if assets then
		local v6 = {}

		for k, asset in assets do
			local accessoryTypeEnum = module5.AssetTypeIdToAccessoryTypeEnum[k]
			local v7 = {}

			for k2, v8 in asset do
				if accessoryTypeEnum then
					table.insert(v6, module6.createHumanoidDescriptionAccessoryInfo(k, k2, v8))
				else
					table.insert(v7, k2)
				end
			end

			if not (accessoryTypeEnum == nil and #v7 > 0) then
				continue
			end

			local v8 = module5.AssetTypeIdStringToHumanoidDescriptionProp[k]
			local joined = table.concat(v7, ",")

			if v8 then
				humanoidDescription[v8] = joined
			elseif k ~= module5.AssetTypeIdStrings.Gear and not isMakeupAssetType(k) then
				module3(string.format(
					"assetTypeId: %s not recognized as member of humanoidDescription",
					(tostring(k))
				))
			end
		end

		humanoidDescription:SetAccessories(v6, true)
		setMakeupDescriptions(humanoidDescription, assets)
	end

	if scales then
		for k, scale in scales do
			humanoidDescription[module5.HumanoidDescriptionScaleToName[k]] = scale
		end
	end

	v5.setHumanoidDescriptionColorsFromBodyColor3s(humanoidDescription, data.bodyColor3s)

	return humanoidDescription
end

function v5.shouldNotifyAssetTypes(items, p2): boolean
	for k, item in items do
		if p2[item] == true then
			return true
		end
	end

	return false
end

function v5.shouldNotifyBundleTypes(items, p2): boolean
	for k, item in items do
		if p2[module5.BundleTypeIdStringToOutfitType[item]] == true then
			return true
		end
	end

	return false
end

function v5.shouldNotifyOutfitTypes(items, p2): boolean
	for k, item in items do
		local v6 = module5.InventoryOutfitTypeToOutfitType[item]

		if v6 and p2[v6] == true then
			return true
		end
	end

	return false
end

function v5.shouldNotifyCategory(data, p2): boolean
	local assetTypeIdStrings = data.AssetTypeIdStrings
	local bundleTypeIdStrings = if not fFlagAXMigrateOutfitsToUserInventory then data.BundleTypeIdStrings else nil
	local inventoryOutfitTypes = if fFlagAXMigrateOutfitsToUserInventory then data.InventoryOutfitTypes else nil
	local subcategories = data.Subcategories
	local subcategoryFilters = data.SubcategoryFilters

	if
		assetTypeIdStrings and v5.shouldNotifyAssetTypes(assetTypeIdStrings, p2)
		or fFlagAXMigrateOutfitsToUserInventory
		and inventoryOutfitTypes ~= nil
		and v5.shouldNotifyOutfitTypes(inventoryOutfitTypes, p2)
	then
		return true
	end

	if
		not fFlagAXMigrateOutfitsToUserInventory
		and bundleTypeIdStrings
		and v5.shouldNotifyBundleTypes(bundleTypeIdStrings, p2)
	then
		return true
	end

	if subcategories then
		for k, subcategory in subcategories do
			if v5.shouldNotifyCategory(subcategory, p2) then
				return true
			end
		end
	elseif subcategoryFilters then
		for k, subcategoryFilter in subcategoryFilters do
			if v5.shouldNotifyCategory(subcategoryFilter, p2) then
				return true
			end
		end
	end

	return false
end

function v5.getNotificationItemTypesForCategory(data, p2)
	local set = {}
	local assetTypeIdStrings = data.AssetTypeIdStrings
	local bundleTypeIdStrings = if not fFlagAXMigrateOutfitsToUserInventory then data.BundleTypeIdStrings else nil
	local inventoryOutfitTypes = if fFlagAXMigrateOutfitsToUserInventory then data.InventoryOutfitTypes else nil
	local subcategories = data.Subcategories
	local subcategoryFilters = data.SubcategoryFilters

	if assetTypeIdStrings then
		for k, assetTypeIdString in assetTypeIdStrings do
			if p2[assetTypeIdString] then
				set[assetTypeIdString] = true
			end
		end
	end

	if fFlagAXMigrateOutfitsToUserInventory then
		if inventoryOutfitTypes then
			for k, inventoryOutfitType in inventoryOutfitTypes do
				local v6 = module5.InventoryOutfitTypeToOutfitType[inventoryOutfitType]

				if v6 and p2[v6] then
					set[v6] = true
				end
			end
		end
	elseif bundleTypeIdStrings then
		for k, bundleTypeIdString in bundleTypeIdStrings do
			local v6 = module5.BundleTypeIdStringToOutfitType[bundleTypeIdString]

			if p2[v6] then
				set[v6] = true
			end
		end
	end

	if subcategories then
		for k, subcategory in subcategories do
			for k2, v6 in v5.getNotificationItemTypesForCategory(subcategory, p2) do
				set[v6] = true
			end
		end
	end

	if subcategoryFilters then
		for k, subcategoryFilter in subcategoryFilters do
			for k2, v6 in v5.getNotificationItemTypesForCategory(subcategoryFilter, p2) do
				set[v6] = true
			end
		end
	end

	return Cryo.Dictionary.keys(set)
end

function v5.doAESCallAndAwaitResult(p2, callback, object, ...)
	local v6 = callback(p2, ...)

	while not v6 do
		object:Wait()
		v6 = callback(p2, ...)
	end

	return object:Wait()
end

v5.getColor3AtValueInRange = memoize(function(list, p2)
	local clampBetween0And1, v6 = getMessageFadeSequence.clampBetween0And1(p2)

	if v6 then
		module3(string.format(
			"getColor3AtValueInRange: value %s should be between 0 and 1 inclusive",
			(tostring(p2))
		))
	end

	if clampBetween0And1 == 0 then
		return list[1]
	elseif clampBetween0And1 == 1 then
		return list[#list]
	end

	local v7 = clampBetween0And1 * (#list - 1)
	local v8 = math.floor(v7 + 1)
	local v9 = v7 + 1 - v8
	return list[v8]:Lerp(list[v8 + 1], v9)
end)

local function fn(data, data2, data3)
	local vector3 = Vector3.new(data.R, data.G, data.B)
	local vector3_2 = Vector3.new(data2.R, data2.G, data2.B)
	local vector3_3 = Vector3.new(data3.R, data3.G, data3.B)

	local vector2 = vector3_2 - vector3
	local vector4 = vector3_3 - vector3

	if vector4:Dot(vector2) <= 0 then
		return vector4.Magnitude, 0
	end

	local vector5 = vector3_3 - vector3_2

	if vector5:Dot(vector2) >= 0 then
		return vector5.Magnitude, 1
	end

	return
		vector2:Cross(vector4).Magnitude / vector4.Magnitude,
		vector2.Unit:Dot(vector4) / vector2.Magnitude
end

local function fn2(range, p2)
	local v6 = 10
	local v7 = 0

	for i = 1, #range - 1 do
		local v8, v9 = fn(range[i], range[i + 1], p2)

		if not (v8 < v6) then
			continue
		end

		v7 = (i - 1 + v9) / (#range - 1)
		v6 = v8
	end

	return v6, v7
end

function v5.findRangeAndSliderValueForColor3(p2, items)
	local v6 = 10
	local rangeId = nil
	local v7 = 0

	for k, item in items do
		local v8, v9 = fn2(item.range, p2)

		if not (v8 < v6) then
			continue
		end

		rangeId = item.rangeId
		v7 = v9
		v6 = v8
	end

	return rangeId, v7
end

v5.getRangeStructForRangeId = memoize(function(p2, items)
	for k, item in items do
		if item.rangeId == p2 then
			return item
		end
	end

	return nil
end)

v5.getColor3AtValueForRangeId = memoize(function(p2, p3, p4)
	local clampBetween0And1, v6 = getMessageFadeSequence.clampBetween0And1(p3)

	if v6 then
		module3(string.format(
			"getColor3AtValueInRange: value %s should be between 0 and 1 inclusive",
			(tostring(p3))
		))
	end

	local rangeStructForRangeId = v5.getRangeStructForRangeId(p2, p4)

	if rangeStructForRangeId then
		return v5.getColor3AtValueInRange(rangeStructForRangeId.range, clampBetween0And1)
	end

	return nil
end)

function v5.getInfoForBodyPartIndex(p2, p3)
	module.assert(p2 >= 1, "selectedBodyPartIndex too low")
	module.assert(p2 <= #module4.BodyPartButtonData, "selectedBodyPartIndex too high")

	if p3 == nil then
		return nil
	end

	local v6 = nil

	for k, bodyPartForSkinColoringId in module4.BodyPartButtonData[p2].bodyPartForSkinColoringIds do
		if not p3[bodyPartForSkinColoringId] then
			continue
		end

		if v6 == nil then
			v6 = p3[bodyPartForSkinColoringId]
		elseif v6.color3 ~= p3[bodyPartForSkinColoringId].color3 then
			return nil
		end
	end

	return v6
end

v5.getColor3ForBodyPartIndex = memoize(function(p2, p3, p4, p5)
	module.isNotNil(p5, "defaultBodyColorRanges")
	local infoForBodyPartIndex = v5.getInfoForBodyPartIndex(p3, p4)

	if infoForBodyPartIndex then
		return infoForBodyPartIndex.color3
	end

	return v5.getColor3AtValueForRangeId(p2, 0.5, p5)
end)

v5.getColor3ForRangeIdAndBodyPartIndex = memoize(function(p2, p3, p4, p5)
	module.isNotNil(p2, "rangeId")
	local getColor3ForBodyPartIndex = v5.getColor3ForBodyPartIndex

	local v6 = if p4 then p4[p2] else nil
	return getColor3ForBodyPartIndex(p2, p3, v6, p5)
end)

v5.getSliderValueForBodyPartIndex = memoize(function(p2, p3)
	local infoForBodyPartIndex = v5.getInfoForBodyPartIndex(p2, p3)

	if infoForBodyPartIndex then
		return infoForBodyPartIndex.sliderValue
	end

	return 0.5
end)

v5.getSliderValueForRangeIdAndBodyPartIndex = memoize(function(p2, p3, p4)
	module.isNotNil(p2, "rangeId")
	local getSliderValueForBodyPartIndex = v5.getSliderValueForBodyPartIndex

	local v6 = if p4 then p4[p2] else nil
	return getSliderValueForBodyPartIndex(p3, v6)
end)

function v5.getBodyColorsSliderFrameHeight(p2, p3, p4, p5)
	local v6 = p4 - math.max(p3, p5)

	if p2 < v6 then
		return v6
	end

	return p2
end

function v5.getSearchUuidAndAssetTypes(data, value, value2)
	if data.SubButtons then
		local subButton = data.SubButtons[value or 1]
		return subButton.SearchUuid, subButton.AssetTypeIdStrings
	end

	if fFlagAXEditorSubcategoryFilters and data.SubcategoryFilters then
		local v6 = data.SubcategoryFilters[value2 or 1] or data.SubcategoryFilters[1]
		return v6.SearchUuid, v6.AssetTypeIdStrings
	end

	return data.SearchUuid, data.AssetTypeIdStrings
end

function v5.getCategoryIndicesFromAssetType(p2)
	local v6 = module8()

	for k, v7 in v6 do
		if not v7.Subcategories then
			continue
		end

		for k2, subcategory in v7.Subcategories do
			if not subcategory.AssetTypeIdStrings then
				continue
			end

			for k3, assetTypeIdString in subcategory.AssetTypeIdStrings do
				if p2 == assetTypeIdString then
					return k, k2
				end
			end
		end
	end

	return nil, nil
end

function v5.findAvatarEditorCategory(p2, p3)
	local v6 = module8()

	for k, v7 in v6 do
		if v7.SearchUuid ~= p2 then
			continue
		end

		for k2, subcategory in v7.Subcategories do
			if subcategory.SearchUuid == p3 then
				return k, k2
			end
		end
	end

	return nil, nil
end

function v5.selectAssetTypeKey(p2)
	local category = p2.AvatarExperience.AvatarEditor.Categories.category
	local subcategory = p2.AvatarExperience.AvatarEditor.Categories.subcategory
	local subButton = p2.AvatarExperience.AvatarEditor.Categories.subButton
	local subcategoryFilter

	if fFlagAXEditorSubcategoryFilters then
		subcategoryFilter = p2.AvatarExperience.AvatarEditor.Categories.subcategoryFilter
	end

	local avatarEditorCategoryInfo = module6.getAvatarEditorCategoryInfo(category, subcategory)

	local getSearchUuidAndAssetTypes = v5.getSearchUuidAndAssetTypes

	if not fFlagAXEditorSubcategoryFilters then
		subcategoryFilter = nil
	end

	local searchUuidAndAssetTypes, v6 = getSearchUuidAndAssetTypes(
		avatarEditorCategoryInfo,
		subButton,
		subcategoryFilter
	)

	return searchUuidAndAssetTypes or avatarEditorCategoryInfo.Name
end

v5.getColor3SharedByBodyParts = memoize(function(items, p2)
	local v6 = nil

	for k, item in items do
		local v7 = p2[item]

		if v6 == nil then
			v6 = v7
		elseif v7 and v6:ToHex() ~= v7:ToHex() then
			return nil
		end
	end

	return v6
end)

v5.getRangeIdSharedByBodyParts = memoize(function(items, p2)
	local v6 = nil

	for k, item in items do
		local v7 = p2[item]

		if v6 == nil then
			v6 = v7
		elseif v6 ~= v7 then
			return nil
		end
	end

	return v6
end)

function v5.ExponentialRepeat(callback, callback2, value)
	local v6 = 1
	local v7 = value or 6

	while v6 <= v7 and callback() do
		if callback2() then
			break
		end

		task.wait(v6 ^ 2)
		v6 += 1
	end
end

function v5.doesOutfitBackgroundMatch(p2, p3): boolean
	if
		p2.outfitType ~= module5.OutfitTypes.Avatar and p2.outfitType ~= module5.OutfitTypes.EditableAvatar
		or v5.isPresetOutfit(p2)
	then
		return true
	end

	local backgroundAssetId = p2.profileConfiguration and p2.profileConfiguration.BackgroundAssetId
	return normalizeBackgroundId(p3) == normalizeBackgroundId(backgroundAssetId)
end

function v5.isWearingOutfitNoState(data, p2, items, items2, items3, p3, p4, p5)
	if data.outfitType == module5.OutfitTypes.DynamicHead then
		return v5.isWearingDynamicHeadOutfit(data, items2)
	end

	local v6 = v5.removeEmoteAnimationAsset(data.assets)

	local isEditable = data.outfitType == module5.OutfitTypes.Avatar and data.isEditable
		or v5.isFullyQualifiedOutfit(data.assets)

	if isEditable then
		for k, item in items3 do
			if data.scales[k] ~= item then
				return false
			end
		end

		if data.avatarType ~= p2 then
			return false
		end

		if not v5.isPresetOutfit(data) then
			for k, item in items do
				if not (data.bodyColor3s and data.bodyColor3s[k]:ToHex() == item:ToHex()) then
					return false
				end
			end
		end
	end

	local v7 = (fFlagAXIgnoreHeadShapeSupportInOutfitCheck or fFlagEnableSplitPaneAvatarOverlay)
		and { "order", "availabilityStatus", "supportsHeadShapes" }
		or { "order", "availabilityStatus" }
	local values = {}
	local values2 = {}

	for k, v8 in v6 do
		if not items2[k] then
			return false
		end

		for k2, v9 in v8 do
			if not (items2[k][k2] and v5.isSameAssetMetadata(
				Dash.omit(v9, v7),
				Dash.omit(items2[k][k2], v7)
			)) then
				return false
			end

			if isMakeupAssetType(k) then
				if v9.order ~= nil then
					table.insert(values, Cryo.Dictionary.join(v9, {
						assetId = k2,
						assetTypeId = k
					}))
				end
			elseif isLayeredClothingAssetType(k) and v9.order ~= nil then
				table.insert(values2, Cryo.Dictionary.join(v9, {
					assetId = k2,
					assetTypeId = k
				}))
			end
		end
	end

	local set = {
		[module5.AssetTypeIdStrings.EyebrowAccessory] = true,
		[module5.AssetTypeIdStrings.EyelashAccessory] = true,
		[module5.AssetTypeIdStrings.FaceMakeup] = true,
		[module5.AssetTypeIdStrings.EyeMakeup] = true,
		[module5.AssetTypeIdStrings.LipMakeup] = true
	}

	if isEditable or data.outfitType == module5.OutfitTypes.Makeup then
		for k, item in items2 do
			if not ((not fFlagAXFixOutfitEquipCheckEmptyArray or next(item) ~= nil) and (data.outfitType ~= module5.OutfitTypes.Makeup or set[k])) then
				continue
			end

			if not (not fFlagAXSpawnEffectSaveRoundTrip or not isSpawnEffectAssetType(k) or v6[k] ~= nil) then
				continue
			end

			if v6[k] == nil then
				return false
			end

			for k2, v8 in item do
				if v6[k][k2] == nil then
					return false
				end
			end
		end
	end

	local function sortByOrder(p6, p7): boolean
		return p6.order < p7.order
	end

	table.sort(values2, sortByOrder)
	table.sort(values, sortByOrder)
	local order = nil

	for k, v8 in values2 do
		if order == nil then
			order = items2[v8.assetTypeId][v8.assetId].order
		elseif items2[v8.assetTypeId][v8.assetId].order < order then
			return false
		else
			order = items2[v8.assetTypeId][v8.assetId].order
		end
	end

	local order2 = nil

	for k, v8 in values do
		if order2 == nil then
			order2 = items2[v8.assetTypeId][v8.assetId].order
		elseif items2[v8.assetTypeId][v8.assetId].order < order2 then
			return false
		else
			order2 = items2[v8.assetTypeId][v8.assetId].order
		end
	end

	return not fFlagAXBackgroundsOutfitHighlight or v5.doesOutfitBackgroundMatch(data, p5)
end

function v5.isWearingOutfit(p2, p3)
	local character = p2.AvatarExperience.AvatarEditor.Character

	local v6 = if fFlagAXBackgroundsOutfitHighlight then selectActiveBackground(p2) else nil

	return v5.isWearingOutfitNoState(
		p3,
		character.AvatarType,
		character.BodyColor3s,
		character.EquippedAssets,
		character.AvatarScales,
		nil,
		nil,
		v6
	)
end

function v5.getIdOfOutfitBeingWorn(items, p2, data, p3)
	local avatarType = data.AvatarType
	local bodyColor3s = data.BodyColor3s
	local equippedAssets = data.EquippedAssets
	local avatarScales = data.AvatarScales

	for k, item in items do
		local v6 = p2[tostring(item)]

		if
			v6
			and v5.isWearingOutfitNoState(
				v6,
				avatarType,
				bodyColor3s,
				equippedAssets,
				avatarScales,
				true,
				true,
				p3
			)
		then
			return item
		end
	end

	return nil
end

function v5.filterOutfitAssetsWithStatus(p2, list)
	local v6 = {}

	if p2.assets then
		for k, asset in p2.assets do
			if asset then
				v6[k] = {}

				for k2, v7 in asset do
					if typeof(list) == "table" then
						if not table.find(list, v7.availabilityStatus) then
							v6[k][k2] = v7
						end
					elseif v7 and v7.availabilityStatus ~= list then
						v6[k][k2] = v7
					end
				end
			end

			if next(v6[k]) == nil then
				v6[k] = nil
			end
		end
	end

	return Cryo.Dictionary.join(p2, { assets = v6 })
end

function v5.hasMakeup(items): boolean
	if not items then
		return false
	end

	for k, item in items do
		if isMakeupAssetType(k) then
			return true
		end
	end

	return false
end

function v5.getOutfitSubtypeKey(p2, p3)
	if not fFlagAXOutfitPageRevamp then
		return ""
	end

	local avatar = module5.OutfitTypes.Avatar
	local v7

	if p3 then
		if fFlagAXMigrateOutfitsToUserInventory then
			v7 = avatarEditorCategories.Avatars
		else
			v7 = module4.EditableCharacterKey
		end
	else
		v7 = module4.PurchasedCharacterKey
	end

	local v6 = { [avatar] = v7 }

	local makeup = module5.OutfitTypes.Makeup
	local v8

	if fFlagAXMigrateOutfitsToUserInventory then
		v8 = if p3 then module4.EditableMakeupOutfitKey else avatarEditorSubcategories.MakeupLooks
	else
		v8 = if p3 then module4.EditableMakeupOutfitKey else module4.MakeupOutfitKey
	end

	v6[makeup] = v8

	local v9 = v6[p2]

	if v9 then
		return v9
	end

	if fFlagAXMigrateOutfitsToUserInventory then
		return avatarEditorCategories.Avatars
	end

	v9 = module4.EditableCharacterKey
	return v9
end

return v5
