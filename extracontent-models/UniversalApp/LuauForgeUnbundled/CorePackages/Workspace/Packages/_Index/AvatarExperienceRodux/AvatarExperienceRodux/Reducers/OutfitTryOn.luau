local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Cryo")
local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceModel")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceFlags")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceCommon")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/tutils")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/RoduxTypes")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/OutfitTryOn")

local TryOnLooksOutfit = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/TryOnLooksOutfit")
local ToggleTryOn = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/ToggleTryOn")
local TryOnColorUpdated = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/TryOnColorUpdated")
local SetEquippedInTryOnManager = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetEquippedInTryOnManager")
local SetSelectedTimedOption = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetSelectedTimedOption")
local RemoveUnselectedItemsFromTryOn = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/RemoveUnselectedItemsFromTryOn")
local RemoveFromTryOn = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/RemoveFromTryOn")
local RemoveLook = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/RemoveLook")
local RemoveLookFromTryOn = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/RemoveLookFromTryOn")
local RemoveLookItemsFromTryOn = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/RemoveLookItemsFromTryOn")
local ReceivedBundleInfoForTryOn = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/ReceivedBundleInfoForTryOn")
local ClearTryOns = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/ClearTryOns")
local SetBackgroundPreview = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetBackgroundPreview")
local SetOrderForTryOns = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetOrderForTryOns")
local AddSelectedBundleInfo = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/AddSelectedBundleInfo")
local SetOutfitTryOns = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetOutfitTryOns")
local SetAccessoryAdjustments = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetAccessoryAdjustments")
local ReducerUtils = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Utils/ReducerUtils")
local TryOnClassicHeadShape = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/TryOnClassicHeadShape")
local NavigatedToNonTryOnPage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/NavigatedToNonTryOnPage")
local NavigatedToTryOnPage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/NavigatedToTryOnPage")
local module28 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/DefaultTryOnBodyColorsToggled")
local findItemInTryOnItems = AvatarExperienceCommon.Utils.findItemInTryOnItems
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local getFilteredTryOnItems = AvatarExperienceCommon.Utils.getFilteredTryOnItems
local removeMakeupAssetsFromTryOnsIfOverLimit = AvatarExperienceCommon.Utils.removeMakeupAssetsFromTryOnsIfOverLimit
local SetLastToggledLookType = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetLastToggledLookType")
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local LAYERED_MAKEUP_ORDER = AvatarExperienceCommon.Constants.LAYERED_MAKEUP_ORDER
local MAKEUP_LOOK_ASSET_TYPES = AvatarExperienceCommon.Constants.MAKEUP_LOOK_ASSET_TYPES
local LOOK_TYPE = AvatarExperienceCommon.Constants.LOOK_TYPE
local constants = AvatarExperienceCommon.Constants
local itemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local ASSET_TYPE_NAME_TO_ID_STRING = constants.ASSET_TYPE_NAME_TO_ID_STRING
local bundleTypeIdStrings = AvatarExperienceModel.Constants.BundleTypeIdStrings
local BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND = constants.BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND
local LAYERED_CLOTHING_ORDER = constants.LAYERED_CLOTHING_ORDER
local LAYERED_ASSET_TYPES = constants.LAYERED_ASSET_TYPES
local ASSET_TYPE_TO_ACCESSORY_TYPE = constants.ASSET_TYPE_TO_ACCESSORY_TYPE

local characterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local fFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local fFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local fFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local fFlagAXPhotoboothMomentsPage = AvatarExperienceFlags.FFlagAXPhotoboothMomentsPage
local fFlagAXTryOnWithoutEquippedBody = AvatarExperienceFlags.FFlagAXTryOnWithoutEquippedBody

local fFlagAXPhotoboothMomentsTryOnAccessoryAdjustments = AvatarExperienceFlags.FFlagAXPhotoboothMomentsTryOnAccessoryAdjustments

local count = 0

local function formatItem(data, p2)
	local v5 = data.receivedBundleInfo and true or false

	local v6 = data.bundleInfo

	if fFlagAXMISEnableMultiShopping and data.bundleItems and not v5 then
		v6 = {}

		for k, bundleItem in data.bundleItems do
			if bundleItem.type ~= itemTypeEnum.Asset then
				continue
			end

			local v7 = bundleItem.assetType

			if not v7 and data.itemSubType == bundleTypeIdStrings.DynamicHead then
				v7 = ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead
			end

			if not v7 then
				continue
			end

			local v8 = { assetType = v7 }

			if
				fFlagParseHeadShapeFromAPIResponse
				and bundleItem.meta
				and bundleItem.meta.headShape ~= nil
			then
				v8.headShape = bundleItem.meta.headShape
			end

			if
				fFlagHeadRefinementFacialAnimationToggle
				and bundleItem.meta
				and bundleItem.meta.staticFacialAnimation ~= nil
			then
				v8.staticFacialAnimation = bundleItem.meta.staticFacialAnimation
			end

			v6[bundleItem.id] = v8
		end

		v5 = true
	end

	local joined = {
		version = "1",
		itemId = data.itemId,
		itemType = data.itemType,
		itemSubType = data.itemSubType,
		selectedInTryOnManager = data.selectedInTryOnManager,
		isUnequipped = p2,
		receivedBundleInfo = v5,
		bundleInfo = 0,
		widgetInfo = 0,
		isRecolorable = 0,
		selectedTimedOptionIndex = 0
	}

	if not fFlagAXMISEnableMultiShopping then
		v6 = data.bundleInfo
	end

	joined.bundleInfo = v6
	joined.widgetInfo = data.widgetInfo
	joined.isRecolorable = data.isRecolorable
	local v7 = if fFlagAXDurablesForMIS then data.selectedTimedOptionIndex else nil
	joined.selectedTimedOptionIndex = v7

	if ASSET_TYPE_TO_ACCESSORY_TYPE[data.itemSubType] then
		local v8 = {
			order = data.overrideOrder or LAYERED_CLOTHING_ORDER[data.itemSubType],
			isLayered = LAYERED_ASSET_TYPES[data.itemSubType] ~= nil
		}

		joined = Cryo.Dictionary.join(joined, v8)
	elseif ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[data.itemSubType] then
		local v8 = {
			order = data.overrideOrder or LAYERED_MAKEUP_ORDER[data.itemSubType],
			isLayered = true
		}

		joined = Cryo.Dictionary.join(joined, v8)
	end

	if not p2 then
		joined.itemRecency = count
		count += 1
	end

	return joined
end

local function formatItemFromLookOutfit(data, p2, p3, p4)
	local joined = {
		version = "1",
		itemId = data.itemId,
		itemType = data.itemType,
		itemSubType = data.itemSubType,
		selectedInTryOnManager = data.isNotSelectable ~= true,
		isUnequipped = false,
		receivedBundleInfo = false,
		lookId = p3,
		outfitId = if fFlagAXPhotoboothMomentsPage then p4 else nil,
		headShape = 0,
		staticFacialAnimation = 0
	}

	local v6 = if fFlagAXTryOnWithoutEquippedBody then data.headShape else nil
	joined.headShape = v6
	local v7 = if fFlagAXTryOnWithoutEquippedBody then data.staticFacialAnimation else nil
	joined.staticFacialAnimation = v7

	if ASSET_TYPE_TO_ACCESSORY_TYPE[data.itemSubType] then
		local v8 = {
			order = data.order or LAYERED_CLOTHING_ORDER[data.itemSubType],
			isLayered = LAYERED_ASSET_TYPES[data.itemSubType] ~= nil
		}

		joined = Cryo.Dictionary.join(joined, v8)

		if fFlagAXPhotoboothMomentsTryOnAccessoryAdjustments and p4 ~= nil then
			joined.position = data.position
			joined.rotation = data.rotation
			joined.scale = data.scale
		end
	elseif ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[data.itemSubType] then
		local v8 = {
			order = data.order or LAYERED_MAKEUP_ORDER[data.itemSubType],
			isLayered = true
		}

		joined = Cryo.Dictionary.join(joined, v8)
	end

	local v8 = if p2 == LOOK_TYPE.Avatar or fFlagAXCatalogMakeupSupport and p2 == LOOK_TYPE.Makeup then data.tryOnItemOrder else count
	joined.itemRecency = v8

	count += 1

	return joined
end

local function formatBundleFromLookOutfit(data, lookId)
	local v5 = {
		version = "1",
		selectedInTryOnManager = data.isNotSelectable ~= true,
		isUnequipped = false,
		receivedBundleInfo = false,
		itemType = data.itemType,
		itemId = data.itemId,
		itemSubType = 0,
		lookId = 0
	}
	local v6 = if fFlagAXMISEnableMultiShopping then data.itemSubType else nil
	v5.itemSubType = v6
	v5.lookId = lookId

	local v7 = {}

	for k, item in data.items do
		local itemId = item.itemId
		local v8 = {
			assetType = item.itemSubType,
			order = LAYERED_CLOTHING_ORDER[item.itemSubType] or LAYERED_MAKEUP_ORDER[item.itemSubType],
			headShape = 0
		}
		local v9 = if fFlagParseHeadShapeFromAPIResponse then item.headShape else nil
		v8.headShape = v9
		v7[itemId] = v8
	end

	v5.bundleInfo = v7
	v5.itemRecency = data.tryOnItemOrder or count
	count += 1

	return v5
end

local function removeItem(p2, tryOnItems, data)
	local tryOnItemReducerKey = getTryOnItemReducerKey(data.itemId, data.itemType)
	local v5 = tryOnItems[tryOnItemReducerKey]
	v5.isUnequipped = true

	local v6 = data.itemSubType == ASSET_TYPE_NAME_TO_ID_STRING.Face
	local v7

	if data.itemType == itemTypeEnum.Bundle then
		v7 = BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND[data.itemSubType] == "Body"
	else
		v7 = false
	end

	local join = Cryo.Dictionary.join
	local v8 = {
		TryOnItems = Cryo.Dictionary.join(tryOnItems, {
			[tryOnItemReducerKey] = Cryo.None
		}),
		LastToggledItem = v5,
		LastTryOnClassicHeadShape = 0,
		BodyColor3s = 0,
		BodyPartColorRangeIds = 0
	}

	local v9 = if v6 then Cryo.None else nil
	v8.LastTryOnClassicHeadShape = v9
	local v10 = if v7 then Cryo.None else nil
	v8.BodyColor3s = v10
	local v11 = if v7 then Cryo.None else nil
	v8.BodyPartColorRangeIds = v11
	return join(p2, v8)
end

local function isAnimationOrEmoteItem(p2): boolean
	if
		p2.itemType == itemTypeEnum.Asset
		and p2.itemSubType == ASSET_TYPE_NAME_TO_ID_STRING.EmoteAnimation
	then
		return true
	end

	return p2.itemType == itemTypeEnum.Bundle and p2.itemSubType == tostring(bundleTypeIdStrings.Animations)
end

local function getTryOnItemsContainsRecolorableBody(items): boolean
	for k, item in items do
		if
			item.itemType == "Bundle"
			and BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND[item.itemSubType] == "Body"
			and item.isRecolorable
		then
			return true
		end
	end

	return false
end

local function getTryOnItemsMakeupAndAvatarLookIds(tryOnItems)
	local v5 = Cryo.None
	local v6 = Cryo.None

	for k, item in tryOnItems do
		if item.lookId and not MAKEUP_LOOK_ASSET_TYPES[item.itemSubType] then
			v5 = item.lookId
		end

		if item.lookId and MAKEUP_LOOK_ASSET_TYPES[item.itemSubType] then
			v6 = item.lookId
		end
	end

	return v5, v6
end

local function reconcileAllTryOnState(data)
	local tryOnItems = data.TryOnItems
	local v5, v6

	if fFlagAXMISEnableMultiShopping then
		v5, v6 = getTryOnItemsMakeupAndAvatarLookIds(tryOnItems)
	end

	local v7 = getTryOnItemsContainsRecolorableBody(tryOnItems)

	if fFlagAXMISEnableMultiShopping then
		v7 = v7 or v5 ~= nil
	end

	if fFlagAXPhotoboothMomentsPage then
		v7 = v7 or data.OutfitId ~= nil
	end

	local v8 = if v7 then data.BodyColor3s else Cryo.None
	local v9 = if v7 then data.BodyPartColorRangeIds else Cryo.None

	local v10 = if v7 then data.DefaultTryOnBodyColorsToggled else false

	local v11 = if fFlagAXMISEnableMultiShopping then tutils.fieldCount(tryOnItems) == 0 else nil
	local v12

	if fFlagAXMISEnableMultiShopping then
		v12 = if v11 then Cryo.None else data.LookType
	end

	local v13

	if fFlagAXMISEnableMultiShopping then
		v13 = if v11 or not v6 then Cryo.None else LOOK_TYPE.Makeup
	end

	local join = Cryo.Dictionary.join

	if not fFlagAXMISEnableMultiShopping then
		v5 = nil
	end

	if not fFlagAXMISEnableMultiShopping then
		v12 = nil
	end

	if not fFlagAXMISEnableMultiShopping then
		v6 = nil
	end

	if not fFlagAXMISEnableMultiShopping then
		v13 = nil
	end

	local v15

	if fFlagAXMISEnableMultiShopping then
		v15 = not v11 and data.ShouldTryOnWithoutEquippedItems
	end

	local v16

	if fFlagAXTryOnWithoutEquippedBody then
		v16 = not v11 and data.ShouldTryOnWithoutEquippedBody
	end

	return join(data, {
		BodyColor3s = v8,
		BodyPartColorRangeIds = v9,
		DefaultTryOnBodyColorsToggled = v10,
		LookId = v5,
		LookType = v12,
		MakeupLookId = v6,
		MakeupLookType = v13,
		ShouldTryOnWithoutEquippedItems = v15,
		ShouldTryOnWithoutEquippedBody = v16
	})
end

local v5 = {
	TryOnItems = {},
	DefaultTryOnBodyColorsToggled = false,
	LookId = nil,
	LookType = nil,
	MakeupLookId = nil,
	MakeupLookType = nil,
	LastToggledLookType = nil,
	LastTryOnClassicHeadShape = nil,
	OutfitIdMap = {},
	ShouldTryOnWithoutEquippedItems = if fFlagAXMISEnableMultiShopping then false else nil,
	ShouldTryOnWithoutEquippedBody = if fFlagAXTryOnWithoutEquippedBody then false else nil,
	BackgroundPreview = nil,
	AvatarType = nil,
	OutfitId = nil
}

return Rodux.createReducer(v5, {
	[TryOnColorUpdated.name] = function(p2, p3)
		local clone = table.clone(p2 or v5)
		clone.BodyColor3s = p3.colors
		clone.BodyPartColorRangeIds = p3.bodyPartColorRangeIds
		return clone
	end,
	[ToggleTryOn.name] = function(p2, data)
		local v9 = p2 or v5
		local tryOnItems = v9.TryOnItems or {}
		local v10 = v9.LookId ~= nil
		local tryOnItemReducerKey = getTryOnItemReducerKey(data.itemId, data.itemType)
		local v11

		if fFlagAXMISEnableMultiShopping then
			v11 = tryOnItems[tryOnItemReducerKey] ~= nil
		else
			v11 = not (tryOnItems[tryOnItemReducerKey] == nil) and not v10
		end

		if v11 then
			if fFlagAXMISEnableMultiShopping then
				return reconcileAllTryOnState(removeItem(v9, tryOnItems, data))
			end

			return removeItem(v9, tryOnItems, data)
		else
			local v12 = fFlagAXMISEnableMultiShopping and data.resetTryOnsBeforeToggleOn and {}
				or tryOnItems

			local v13 = ReducerUtils.filterTryOns(v12, data)
			local v14 = formatItem(data, false)

			if fFlagAXMISEnableMultiShopping then
				v13 = getFilteredTryOnItems(v12, v14)
			end

			local v15

			if
				v14.itemType == itemTypeEnum.Asset
				and v14.itemSubType == ASSET_TYPE_NAME_TO_ID_STRING.EmoteAnimation
				or v14.itemType == itemTypeEnum.Bundle
				and v14.itemSubType == tostring(bundleTypeIdStrings.Animations)
			then
				v15 = v14
			end

			if fFlagAXMISEnableMultiShopping or not v10 then
				local joined = Cryo.Dictionary.join(v13, {
					[tryOnItemReducerKey] = v14
				})

				local v16 = getTryOnItemsContainsRecolorableBody(joined)

				if fFlagAXPhotoboothMomentsPage then
					v16 = v16 or v9.OutfitId ~= nil
				end

				local v17 = if v16 then v9.BodyColor3s else Cryo.None

				local v18 = if v16 then v9.BodyPartColorRangeIds else Cryo.None

				local v19 = if v16 then v9.DefaultTryOnBodyColorsToggled else false

				local joined2 = Cryo.Dictionary.join(v9, {
					TryOnItems = joined,
					LastToggledItem = v14,
					LastAnimOrEmoteToggledItem = v15,
					BodyColor3s = v17,
					BodyPartColorRangeIds = v18,
					DefaultTryOnBodyColorsToggled = v19
				})

				if not fFlagAXMISEnableMultiShopping then
					return joined2
				end

				if fFlagAXCatalogMakeupSupport then
					joined = removeMakeupAssetsFromTryOnsIfOverLimit(joined)
				end

				return reconcileAllTryOnState(Cryo.Dictionary.join(joined2, {
					TryOnItems = joined,
					LastToggledItem = v14,
					LastAnimOrEmoteToggledItem = v15
				}))
			end

			return Cryo.Dictionary.join(v9, {
				TryOnItems = { [data.itemId] = v14 },
				LastToggledItem = v14,
				LastAnimOrEmoteToggledItem = v15,
				LookId = Cryo.None,
				BodyColor3s = {},
				BodyPartColorRangeIds = Cryo.None,
				DefaultTryOnBodyColorsToggled = false
			})
		end
	end,
	[TryOnClassicHeadShape.name] = function(p2, p3)
		local join = Cryo.Dictionary.join
		local v10 = if p3.headShape then p3.headShape else Cryo.None
		return join(p2, { LastTryOnClassicHeadShape = v10 })
	end,
	[TryOnLooksOutfit.name] = function(p2, data)
		local v9 = p2 or v5
		local v10

		if
			fFlagAXMISEnableMultiShopping
			and fFlagAXCatalogMakeupSupport
			and data.lookType == LOOK_TYPE.Makeup
		then
			v10 = table.clone(v9.TryOnItems)

			for k, v11 in v10 do
				if MAKEUP_LOOK_ASSET_TYPES[v11.itemSubType] then
					v10[k] = nil
				end
			end
		else
			v10 = {}
		end

		for k, v11 in data.assetItemIdTypeAndSubtype do
			local tryOnItemReducerKey = getTryOnItemReducerKey(v11.itemId, v11.itemType)

			local lookType = data.lookType
			local lookId = if fFlagAXMISEnableMultiShopping then data.lookId else nil
			local v13 = if fFlagAXPhotoboothMomentsPage then data.outfitId else nil
			v10[tryOnItemReducerKey] = formatItemFromLookOutfit(v11, lookType, lookId, v13)
		end

		if data.bundleItemIdTypeAndSubtype ~= nil then
			for k, v11 in data.bundleItemIdTypeAndSubtype do
				local tryOnItemReducerKey = getTryOnItemReducerKey(v11.itemId, v11.itemType)

				local v13 = if fFlagAXMISEnableMultiShopping then data.lookId else nil
				v10[tryOnItemReducerKey] = formatBundleFromLookOutfit(v11, v13)
			end
		end

		if
			fFlagAXMISEnableMultiShopping
			and fFlagAXCatalogMakeupSupport
			and data.lookType == LOOK_TYPE.Makeup
		then
			local join = Cryo.Dictionary.join

			local v12 = if data.lookId then data.lookId else Cryo.None
			local v11 = {
				TryOnItems = v10,
				MakeupLookId = v12,
				MakeupLookType = data.lookType,
				LastToggledLookType = data.lookType,
				MakeupLookAnalyticsInfo = 0
			}
			local v13 = if data.analyticsInfo then data.analyticsInfo else Cryo.None
			v11.MakeupLookAnalyticsInfo = v13
			return join(v9, v11)
		else
			local join = Cryo.Dictionary.join

			local v12 = if data.lookId then data.lookId else Cryo.None
			local v13 = if data.analyticsInfo then data.analyticsInfo else Cryo.None
			local v11 = {
				TryOnItems = v10,
				LookId = v12,
				LookAnalyticsInfo = v13,
				LookType = data.lookType,
				MakeupLookId = Cryo.None,
				MakeupLookType = Cryo.None,
				MakeupLookAnalyticsInfo = Cryo.None,
				LastToggledLookType = 0,
				BodyColor3s = 0,
				BodyPartColorRangeIds = 0,
				DefaultTryOnBodyColorsToggled = 0,
				Scale = 0,
				ShouldTryOnWithoutEquippedItems = 0,
				ShouldTryOnWithoutEquippedBody = 0,
				AvatarType = 0,
				OutfitId = 0
			}
			local v14 = if fFlagAXMISEnableMultiShopping then data.lookType else nil
			v11.LastToggledLookType = v14
			local v15 = if data.bodyColor3s then data.bodyColor3s else Cryo.None
			v11.BodyColor3s = v15
			local v16 = if data.bodyPartColorRangeIds then data.bodyPartColorRangeIds else Cryo.None
			v11.BodyPartColorRangeIds = v16

			v11.DefaultTryOnBodyColorsToggled = Cryo.None
			local v17 = if data.scale then data.scale else Cryo.None
			v11.Scale = v17

			local v18 = if fFlagAXMISEnableMultiShopping then data.lookId ~= nil or fFlagAXPhotoboothMomentsPage and data.outfitId ~= nil else nil
			v11.ShouldTryOnWithoutEquippedItems = v18

			local v19 = if fFlagAXTryOnWithoutEquippedBody then data.shouldTryOnWithoutEquippedBody == true else nil
			v11.ShouldTryOnWithoutEquippedBody = v19
			local v20

			if fFlagAXPhotoboothMomentsPage then
				v20 = if data.avatarType then data.avatarType else Cryo.None
			end

			v11.AvatarType = v20
			local v21

			if fFlagAXPhotoboothMomentsPage then
				v21 = if data.outfitId == nil then Cryo.None else data.outfitId
			end

			v11.OutfitId = v21
			return join(v9, v11)
		end
	end,
	[SetEquippedInTryOnManager.name] = function(p2, data)
		local v9 = p2 or v5
		local tryOnItems = v9.TryOnItems or {}

		local tryOnItemReducerKey = getTryOnItemReducerKey(data.itemId, data.itemType)

		if tryOnItems[tryOnItemReducerKey] == nil then
			return v9
		end

		return Cryo.Dictionary.join(v9, {
			TryOnItems = Cryo.Dictionary.join(tryOnItems, {
				[tryOnItemReducerKey] = Cryo.Dictionary.join(tryOnItems[tryOnItemReducerKey], {
					selectedInTryOnManager = data.selectedInTryOnManager
				})
			})
		})
	end,
	[SetSelectedTimedOption.name] = function(p2, data)
		local v9 = p2 or v5
		local tryOnItems = v9.TryOnItems or {}

		local tryOnItemReducerKey = getTryOnItemReducerKey(data.itemId, data.itemType)

		if tryOnItems[tryOnItemReducerKey] == nil then
			return v9
		end

		return Cryo.Dictionary.join(v9, {
			TryOnItems = Cryo.Dictionary.join(tryOnItems, {
				[tryOnItemReducerKey] = Cryo.Dictionary.join(tryOnItems[tryOnItemReducerKey], {
					selectedTimedOptionIndex = data.selectedTimedOptionIndex
				})
			})
		})
	end,
	[RemoveUnselectedItemsFromTryOn.name] = function(p2, p3)
		local v9 = p2 or v5
		local v10 = {}

		for k, v11 in v9.TryOnItems or {} do
			if v11.selectedInTryOnManager then
				v10[k] = v11
			end
		end

		return Cryo.Dictionary.join(v9, { TryOnItems = v10 })
	end,
	[RemoveLookFromTryOn.name] = fFlagAXMISEnableMultiShopping and function(p2, p3)
		local v9 = p2 or v5
		local v10 = {}

		for k, v11 in v9.TryOnItems or {} do
			if v11.lookId ~= p3.lookId then
				v10[k] = v11
			end
		end

		if fFlagAXCatalogMakeupSupport and v9.MakeupLookId == p3.lookId then
			return Cryo.Dictionary.join(v9, {
				TryOnItems = v10,
				MakeupLookId = Cryo.None,
				MakeupLookType = Cryo.None,
				MakeupLookAnalyticsInfo = Cryo.None,
				LastToggledLookType = Cryo.None
			})
		end

		return Cryo.Dictionary.join(v9, {
			TryOnItems = v10,
			LookId = Cryo.None,
			LookType = Cryo.None,
			LookAnalyticsInfo = Cryo.None,
			BodyColor3s = Cryo.None,
			BodyPartColorRangeIds = Cryo.None,
			Scale = Cryo.None,
			LastToggledLookType = Cryo.None,
			ShouldTryOnWithoutEquippedItems = false,
			ShouldTryOnWithoutEquippedBody = if fFlagAXTryOnWithoutEquippedBody then false else nil
		})
	end or nil,
	[RemoveFromTryOn.name] = function(p2, p3)
		local v9 = p2 or v5
		local tryOnItems = v9.TryOnItems or {}

		local itemInTryOnItems = findItemInTryOnItems(tryOnItems, p3.itemId, p3.itemType)

		if itemInTryOnItems == nil then
			return v9
		end

		return reconcileAllTryOnState(removeItem(v9, tryOnItems, itemInTryOnItems))
	end,
	[RemoveLookItemsFromTryOn.name] = function(p2, data)
		local joined = p2 or v5

		if data.lookId == joined.LookId then
			local tryOnItems = joined.TryOnItems or {}

			for k, assetId in data.assetIds do
				local tryOnItemReducerKey = getTryOnItemReducerKey(assetId, itemTypeEnum.Asset)

				if tryOnItems[tryOnItemReducerKey] ~= nil then
					tryOnItems = Cryo.Dictionary.join(tryOnItems, {
						[tryOnItemReducerKey] = Cryo.None
					})
				end
			end

			if data.bundleIds ~= nil then
				for k, bundleId in data.bundleIds do
					local tryOnItemReducerKey = getTryOnItemReducerKey(bundleId, itemTypeEnum.Bundle)

					if tryOnItems[tryOnItemReducerKey] ~= nil then
						tryOnItems = Cryo.Dictionary.join(tryOnItems, {
							[tryOnItemReducerKey] = Cryo.None
						})
					end
				end
			end

			joined = Cryo.Dictionary.join(joined, {
				TryOnItems = tryOnItems,
				LookId = Cryo.None,
				LookType = Cryo.None,
				BodyColor3s = Cryo.None,
				BodyPartColorRangeIds = Cryo.None,
				Scale = Cryo.None,
				ShouldTryOnWithoutEquippedItems = if fFlagAXMISEnableMultiShopping then false else nil,
				ShouldTryOnWithoutEquippedBody = if fFlagAXTryOnWithoutEquippedBody then false else nil
			})
		end

		if
			not fFlagAXMISEnableMultiShopping
			or not fFlagAXCatalogMakeupSupport
			or data.lookId ~= joined.MakeupLookId
		then
			return joined
		end

		local tryOnItems = joined.TryOnItems or {}

		for k, assetId in data.assetIds do
			local tryOnItemReducerKey = getTryOnItemReducerKey(assetId, itemTypeEnum.Asset)

			if tryOnItems[tryOnItemReducerKey] ~= nil then
				tryOnItems = Cryo.Dictionary.join(tryOnItems, {
					[tryOnItemReducerKey] = Cryo.None
				})
			end
		end

		if data.bundleIds ~= nil then
			for k, bundleId in data.bundleIds do
				local tryOnItemReducerKey = getTryOnItemReducerKey(bundleId, itemTypeEnum.Bundle)

				if tryOnItems[tryOnItemReducerKey] ~= nil then
					tryOnItems = Cryo.Dictionary.join(tryOnItems, {
						[tryOnItemReducerKey] = Cryo.None
					})
				end
			end
		end

		joined = Cryo.Dictionary.join(joined, {
			TryOnItems = tryOnItems,
			MakeupLookId = Cryo.None,
			MakeupLookType = Cryo.None
		})

		return joined
	end,
	[ReceivedBundleInfoForTryOn.name] = function(p2, p3)
		local v9 = p2 or v5
		local tryOnItems = v9.TryOnItems or {}

		local tryOnItemReducerKey = getTryOnItemReducerKey(p3.itemId, itemTypeEnum.Bundle)

		if not tryOnItems[tryOnItemReducerKey] then
			return v9
		end

		local clone = table.clone(v9.OutfitIdMap or {})
		clone[p3.itemId] = p3.outfitId

		return Cryo.Dictionary.join(v9, {
			TryOnItems = Cryo.Dictionary.join(tryOnItems, {
				[tryOnItemReducerKey] = Cryo.Dictionary.join(tryOnItems[tryOnItemReducerKey], {
					receivedBundleInfo = true
				})
			}),
			OutfitIdMap = clone
		})
	end,
	[ClearTryOns.name] = function(data, p2)
		if not data then
			return v5
		end

		local retainTryOnColor = not (if fFlagAXPhotoboothMomentsPage then data.LookId ~= nil or data.OutfitId ~= nil else data.LookId ~= nil)
			and p2.retainTryOnColor
		local join = Cryo.Dictionary.join
		local v11 = {
			LastTryOnClassicHeadShape = data.LastTryOnClassicHeadShape,
			DefaultTryOnBodyColorsToggled = 0,
			BodyColor3s = 0,
			BodyPartColorRangeIds = 0,
			OutfitIdMap = 0,
			ShouldTryOnWithoutEquippedItems = 0,
			ShouldTryOnWithoutEquippedBody = 0,
			LastToggledLookType = 0
		}

		local v12 = if retainTryOnColor then data.DefaultTryOnBodyColorsToggled else nil
		v11.DefaultTryOnBodyColorsToggled = v12

		local v13 = if retainTryOnColor then data.BodyColor3s else nil
		v11.BodyColor3s = v13
		local v14 = if retainTryOnColor then data.BodyPartColorRangeIds else nil
		v11.BodyPartColorRangeIds = v14
		v11.OutfitIdMap = not data and {} or data.OutfitIdMap
		v11.ShouldTryOnWithoutEquippedItems = if fFlagAXMISEnableMultiShopping then false else nil
		v11.ShouldTryOnWithoutEquippedBody = if fFlagAXTryOnWithoutEquippedBody then false else nil

		local v17 = if fFlagAXMISEnableMultiShopping and fFlagAXCatalogMakeupSupport then Cryo.None else nil
		v11.LastToggledLookType = v17
		return join(v5, v11)
	end,
	[NavigatedToNonTryOnPage.name] = function(p2, p3)
		local clone = table.clone(v5)

		if p2 and p2.OutfitIdMap then
			clone.OutfitIdMap = p2.OutfitIdMap
		end

		return clone
	end,
	[NavigatedToTryOnPage.name] = function(p2, p3)
		local clone = table.clone(v5)

		if p2 and p2.OutfitIdMap then
			clone.OutfitIdMap = p2.OutfitIdMap
		end

		return clone
	end,
	[SetBackgroundPreview.name] = function(p2, p3)
		local clone = table.clone(p2 or v5)
		clone.BackgroundPreview = p3.previewKey
		return clone
	end,
	[module28.name] = function(p2, p3)
		local clone = table.clone(p2 or v5)

		clone.DefaultTryOnBodyColorsToggled = p3.state
		return clone
	end,
	[SetOrderForTryOns.name] = function(p2, p3)
		local v9 = p2 or v5

		for k, orderMap in p3.itemIdToOrderMap do
			local tryOnItems = v9.TryOnItems or {}

			local tryOnItemReducerKey = getTryOnItemReducerKey(k, itemTypeEnum.Asset)

			if
				tryOnItems[tryOnItemReducerKey]
				and tryOnItems[tryOnItemReducerKey].itemType ~= itemTypeEnum.Bundle
			then
				v9 = Cryo.Dictionary.join(v9, {
					TryOnItems = Cryo.Dictionary.join(tryOnItems, {
						[tryOnItemReducerKey] = Cryo.Dictionary.join(tryOnItems[tryOnItemReducerKey], {
							order = orderMap
						})
					})
				})
			elseif not tryOnItems[tryOnItemReducerKey] then
				for k2, tryOnItem in tryOnItems do
					if
						tryOnItem.bundleInfo
						and tryOnItem.bundleInfo[k]
						and tryOnItem.itemId ~= constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID
					then
						local bundleInfo = tryOnItem.bundleInfo
						local joined = Cryo.Dictionary.join(bundleInfo, {
							[k] = Cryo.Dictionary.join(bundleInfo[k], {
								order = orderMap
							})
						})

						v9 = Cryo.Dictionary.join(p2, {
							TryOnItems = Cryo.Dictionary.join(tryOnItems, {
								[k2] = Cryo.Dictionary.join(tryOnItems[k2], {
									bundleInfo = joined
								})
							})
						})
						break
					end
				end
			end
		end

		return v9
	end,
	[SetAccessoryAdjustments.name] = function(p2, data)
		local v9 = p2 or v5
		local tryOnItems = v9.TryOnItems or {}

		for k, tryOnItem in tryOnItems do
			if tryOnItem.itemType == "Asset" then
				if tryOnItem.itemId == data.itemId then
					return Cryo.Dictionary.join(v9, {
						TryOnItems = Cryo.Dictionary.join(tryOnItems, {
							[k] = Cryo.Dictionary.join(tryOnItem, {
								position = data.position,
								rotation = data.rotation,
								scale = data.scale
							})
						})
					})
				end
			elseif tryOnItem.itemType == "Bundle" then
				for k2, tryOnItem2 in tryOnItems do
					if tryOnItem2.bundleInfo and tryOnItem2.bundleInfo[data.itemId] then
						local bundleInfo = tryOnItem2.bundleInfo
						local v10 = Cryo.Dictionary.join(bundleInfo, {
							[data.itemId] = Cryo.Dictionary.join(bundleInfo[data.itemId], {
								position = data.position,
								rotation = data.rotation,
								scale = data.scale
							})
						})

						return Cryo.Dictionary.join(p2, {
							TryOnItems = Cryo.Dictionary.join(tryOnItems, {
								[k2] = Cryo.Dictionary.join(tryOnItems[k2], {
									bundleInfo = v10
								})
							})
						})
					end
				end
			end
		end

		return v9
	end,
	[AddSelectedBundleInfo.name] = function(p2, p3)
		local v9 = p2 or v5
		local tryOnItems = v9.TryOnItems or {}

		local tryOnItemReducerKey = getTryOnItemReducerKey(p3.bundleId, itemTypeEnum.Bundle)

		if tryOnItems[tryOnItemReducerKey] then
			return Cryo.Dictionary.join(v9, {
				TryOnItems = Cryo.Dictionary.join(tryOnItems, {
					[tryOnItemReducerKey] = Cryo.Dictionary.join(tryOnItems[tryOnItemReducerKey], {
						bundleInfo = p3.bundleInfo
					})
				})
			})
		end

		return v9
	end,
	[SetOutfitTryOns.name] = function(p2, p3)
		return p3.outfitTryOns
	end,
	[RemoveLook.name] = function(p2, p3)
		local v9 = p2 or v5

		if
			p3.lookId ~= v9.LookId
			and (not fFlagAXMISEnableMultiShopping or not fFlagAXCatalogMakeupSupport or p3.lookId ~= v9.MakeupLookId)
		then
			return v9
		end

		local v10 = {}

		if fFlagAXMISEnableMultiShopping then
			for k, v11 in v9.TryOnItems or {} do
				if v11.lookId ~= p3.lookId then
					v10[k] = v11
				end
			end
		end

		if fFlagAXMISEnableMultiShopping and fFlagAXCatalogMakeupSupport then
			if p3.lookId == v9.LookId then
				v9 = Cryo.Dictionary.join(v9, {
					TryOnItems = v10,
					LookId = Cryo.None,
					LookType = Cryo.None,
					BodyColor3s = Cryo.None,
					BodyPartColorRangeIds = Cryo.None,
					Scale = Cryo.None,
					ShouldTryOnWithoutEquippedItems = false,
					ShouldTryOnWithoutEquippedBody = if fFlagAXTryOnWithoutEquippedBody then false else nil,
					LastToggledLookType = Cryo.None
				})
			end

			if p3.lookId == v9.MakeupLookId then
				return (Cryo.Dictionary.join(v9, {
					TryOnItems = v10,
					MakeupLookId = Cryo.None,
					MakeupLookType = Cryo.None,
					LastToggledLookType = Cryo.None
				}))
			end

			return v9
		end

		v9 = Cryo.Dictionary.join(v9, {
			TryOnItems = v10,
			LookId = Cryo.None,
			LookType = Cryo.None,
			BodyColor3s = Cryo.None,
			BodyPartColorRangeIds = Cryo.None,
			Scale = Cryo.None,
			ShouldTryOnWithoutEquippedItems = if fFlagAXMISEnableMultiShopping then false else nil,
			ShouldTryOnWithoutEquippedBody = if fFlagAXTryOnWithoutEquippedBody then false else nil
		})

		return v9
	end,
	[characterHistoryStateChangeButtonActivated.name] = function(p2, p3)
		if p3.tryOn and p3.tryOn.OutfitTryOn then
			return table.clone(p3.tryOn.OutfitTryOn)
		end

		return p2
	end,
	[SetLastToggledLookType.name] = fFlagAXMISEnableMultiShopping and function(p2, p3)
		return Cryo.Dictionary.join(p2 or v5, {
			LastToggledLookType = p3.lastToggledLookType
		})
	end or nil
})
