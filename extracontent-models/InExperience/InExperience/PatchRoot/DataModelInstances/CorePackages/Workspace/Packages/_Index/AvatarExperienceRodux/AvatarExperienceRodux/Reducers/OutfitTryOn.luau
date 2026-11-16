local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local parent = AvatarExperienceRodux.Parent
local Rodux = require(parent.Rodux)
local Cryo = require(parent.Cryo)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local tutils = require(parent.tutils)

require(AvatarExperienceRodux.Types.RoduxTypes)
require(AvatarExperienceRodux.Types.OutfitTryOn)

local TryOnLooksOutfit = require(AvatarExperienceRodux.Actions.TryOnLooksOutfit)
local ToggleTryOn = require(AvatarExperienceRodux.Actions.ToggleTryOn)
local TryOnColorUpdated = require(AvatarExperienceRodux.Actions.TryOnColorUpdated)
local SetEquippedInTryOnManager = require(AvatarExperienceRodux.Actions.SetEquippedInTryOnManager)
local SetSelectedTimedOption = require(AvatarExperienceRodux.Actions.SetSelectedTimedOption)
local RemoveUnselectedItemsFromTryOn = require(AvatarExperienceRodux.Actions.RemoveUnselectedItemsFromTryOn)
local RemoveFromTryOn = require(AvatarExperienceRodux.Actions.RemoveFromTryOn)
local RemoveLook = require(AvatarExperienceRodux.Actions.RemoveLook)
local RemoveLookFromTryOn = require(AvatarExperienceRodux.Actions.RemoveLookFromTryOn)
local RemoveLookItemsFromTryOn = require(AvatarExperienceRodux.Actions.RemoveLookItemsFromTryOn)
local ReceivedBundleInfoForTryOn = require(AvatarExperienceRodux.Actions.ReceivedBundleInfoForTryOn)
local ClearTryOns = require(AvatarExperienceRodux.Actions.ClearTryOns)
local SetBackgroundPreview = require(AvatarExperienceRodux.Actions.SetBackgroundPreview)
local SetOrderForTryOns = require(AvatarExperienceRodux.Actions.SetOrderForTryOns)
local AddSelectedBundleInfo = require(AvatarExperienceRodux.Actions.AddSelectedBundleInfo)
local SetOutfitTryOns = require(AvatarExperienceRodux.Actions.SetOutfitTryOns)
local SetAccessoryAdjustments = require(AvatarExperienceRodux.Actions.SetAccessoryAdjustments)
local ReducerUtils = require(AvatarExperienceRodux.Utils.ReducerUtils)
local TryOnClassicHeadShape = require(AvatarExperienceRodux.Actions.TryOnClassicHeadShape)
local NavigatedToNonTryOnPage = require(AvatarExperienceRodux.Actions.NavigatedToNonTryOnPage)
local NavigatedToTryOnPage = require(AvatarExperienceRodux.Actions.NavigatedToTryOnPage)
local DefaultTryOnBodyColorsToggled = require(AvatarExperienceRodux.Actions.DefaultTryOnBodyColorsToggled)
local findItemInTryOnItems = AvatarExperienceCommon.Utils.findItemInTryOnItems
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local getFilteredTryOnItems = AvatarExperienceCommon.Utils.getFilteredTryOnItems
local removeMakeupAssetsFromTryOnsIfOverLimit = AvatarExperienceCommon.Utils.removeMakeupAssetsFromTryOnsIfOverLimit
local SetLastToggledLookType = require(AvatarExperienceRodux.Actions.SetLastToggledLookType)
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local LAYERED_MAKEUP_ORDER = AvatarExperienceCommon.Constants.LAYERED_MAKEUP_ORDER
local MAKEUP_LOOK_ASSET_TYPES = AvatarExperienceCommon.Constants.MAKEUP_LOOK_ASSET_TYPES
local LOOK_TYPE = AvatarExperienceCommon.Constants.LOOK_TYPE
local Constants = AvatarExperienceCommon.Constants
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local ASSET_TYPE_NAME_TO_ID_STRING = Constants.ASSET_TYPE_NAME_TO_ID_STRING
local BundleTypeIdStrings = AvatarExperienceModel.Constants.BundleTypeIdStrings
local BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND = Constants.BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND
local LAYERED_CLOTHING_ORDER = Constants.LAYERED_CLOTHING_ORDER
local LAYERED_ASSET_TYPES = Constants.LAYERED_ASSET_TYPES
local ASSET_TYPE_TO_ACCESSORY_TYPE = Constants.ASSET_TYPE_TO_ACCESSORY_TYPE

local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local FFlagAXPhotoboothMomentsPage = AvatarExperienceFlags.FFlagAXPhotoboothMomentsPage
local FFlagAXTryOnWithoutEquippedBody = AvatarExperienceFlags.FFlagAXTryOnWithoutEquippedBody

local FFlagAXPhotoboothMomentsTryOnAccessoryAdjustments = AvatarExperienceFlags.FFlagAXPhotoboothMomentsTryOnAccessoryAdjustments

local count = 0

local function formatItem(data, isUnequipped: boolean)
	local receivedBundleInfo = data.receivedBundleInfo and true or false

	local bundleInfo = data.bundleInfo

	if FFlagAXMISEnableMultiShopping and data.bundleItems and not receivedBundleInfo then
		bundleInfo = {}

		for _, bundleItem in data.bundleItems do
			if bundleItem.type ~= ItemTypeEnum.Asset then
				continue
			end

			local assetType = bundleItem.assetType

			if not assetType and data.itemSubType == BundleTypeIdStrings.DynamicHead then
				assetType = ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead
			end

			if not assetType then
				continue
			end

			local v = { assetType = assetType }

			if FFlagParseHeadShapeFromAPIResponse and bundleItem.meta and bundleItem.meta.headShape ~= nil then
				v.headShape = bundleItem.meta.headShape
			end

			if
				FFlagHeadRefinementFacialAnimationToggle
				and bundleItem.meta
				and bundleItem.meta.staticFacialAnimation ~= nil
			then
				v.staticFacialAnimation = bundleItem.meta.staticFacialAnimation
			end

			bundleInfo[bundleItem.id] = v
		end

		receivedBundleInfo = true
	end

	local joined = {
		version = "1",
		itemId = data.itemId,
		itemType = data.itemType,
		itemSubType = data.itemSubType,
		selectedInTryOnManager = data.selectedInTryOnManager,
		isUnequipped = isUnequipped,
		receivedBundleInfo = receivedBundleInfo,
		bundleInfo = 0,
		widgetInfo = 0,
		isRecolorable = 0,
		selectedTimedOptionIndex = 0
	}

	if not FFlagAXMISEnableMultiShopping then
		bundleInfo = data.bundleInfo
	end

	joined.bundleInfo = bundleInfo
	joined.widgetInfo = data.widgetInfo
	joined.isRecolorable = data.isRecolorable
	local selectedTimedOptionIndex

	if FFlagAXDurablesForMIS then
		selectedTimedOptionIndex = data.selectedTimedOptionIndex
	end

	joined.selectedTimedOptionIndex = selectedTimedOptionIndex

	if ASSET_TYPE_TO_ACCESSORY_TYPE[data.itemSubType] then
		local v = {
			order = data.overrideOrder or LAYERED_CLOTHING_ORDER[data.itemSubType],
			isLayered = LAYERED_ASSET_TYPES[data.itemSubType] ~= nil
		}

		joined = Cryo.Dictionary.join(joined, v)
	elseif ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[data.itemSubType] then
		local v = {
			order = data.overrideOrder or LAYERED_MAKEUP_ORDER[data.itemSubType],
			isLayered = true
		}

		joined = Cryo.Dictionary.join(joined, v)
	end

	if not isUnequipped then
		joined.itemRecency = count
		count += 1
	end

	return joined
end

local function formatItemFromLookOutfit(data, lookType, lookId: string?, p: string?)
	local joined = {
		version = "1",
		itemId = data.itemId,
		itemType = data.itemType,
		itemSubType = data.itemSubType,
		selectedInTryOnManager = data.isNotSelectable ~= true,
		isUnequipped = false,
		receivedBundleInfo = false,
		lookId = lookId,
		outfitId = 0,
		headShape = 0,
		staticFacialAnimation = 0
	}
	local outfitId

	if FFlagAXPhotoboothMomentsPage then
		outfitId = p
	end

	joined.outfitId = outfitId
	local headShape

	if FFlagAXTryOnWithoutEquippedBody then
		headShape = data.headShape
	end

	joined.headShape = headShape
	local staticFacialAnimation

	if FFlagAXTryOnWithoutEquippedBody then
		staticFacialAnimation = data.staticFacialAnimation
	end

	joined.staticFacialAnimation = staticFacialAnimation

	if ASSET_TYPE_TO_ACCESSORY_TYPE[data.itemSubType] then
		local v = {
			order = data.order or LAYERED_CLOTHING_ORDER[data.itemSubType],
			isLayered = LAYERED_ASSET_TYPES[data.itemSubType] ~= nil
		}

		joined = Cryo.Dictionary.join(joined, v)

		if FFlagAXPhotoboothMomentsTryOnAccessoryAdjustments and p ~= nil then
			joined.position = data.position
			joined.rotation = data.rotation
			joined.scale = data.scale
		end
	elseif ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[data.itemSubType] then
		local v = {
			order = data.order or LAYERED_MAKEUP_ORDER[data.itemSubType],
			isLayered = true
		}

		joined = Cryo.Dictionary.join(joined, v)
	end

	local itemRecency

	if lookType == LOOK_TYPE.Avatar or FFlagAXCatalogMakeupSupport and lookType == LOOK_TYPE.Makeup then
		itemRecency = data.tryOnItemOrder
	else
		itemRecency = count
	end

	joined.itemRecency = itemRecency

	count += 1

	return joined
end

local function formatBundleFromLookOutfit(data, lookId: string?)
	local v = {
		version = "1",
		selectedInTryOnManager = data.isNotSelectable ~= true,
		isUnequipped = false,
		receivedBundleInfo = false,
		itemType = data.itemType,
		itemId = data.itemId,
		itemSubType = 0,
		lookId = 0
	}
	local itemSubType

	if FFlagAXMISEnableMultiShopping then
		itemSubType = data.itemSubType
	end

	v.itemSubType = itemSubType
	v.lookId = lookId

	local bundleInfo = {}

	for _, item in data.items do
		local itemId = item.itemId
		local v2 = {
			assetType = item.itemSubType,
			order = LAYERED_CLOTHING_ORDER[item.itemSubType] or LAYERED_MAKEUP_ORDER[item.itemSubType],
			headShape = 0
		}
		local headShape

		if FFlagParseHeadShapeFromAPIResponse then
			headShape = item.headShape
		end

		v2.headShape = headShape
		bundleInfo[itemId] = v2
	end

	v.bundleInfo = bundleInfo
	v.itemRecency = data.tryOnItemOrder or count
	count += 1

	return v
end

local function removeItem(p, tryOnItems, data)
	local tryOnItemReducerKey = getTryOnItemReducerKey(data.itemId, data.itemType)
	local lastToggledItem = tryOnItems[tryOnItemReducerKey]
	lastToggledItem.isUnequipped = true

	local v = data.itemSubType == ASSET_TYPE_NAME_TO_ID_STRING.Face
	local v2

	if data.itemType == ItemTypeEnum.Bundle then
		v2 = BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND[data.itemSubType] == "Body"
	else
		v2 = false
	end

	local join = Cryo.Dictionary.join
	local v3 = {
		TryOnItems = Cryo.Dictionary.join(tryOnItems, { [tryOnItemReducerKey] = Cryo.None }),
		LastToggledItem = lastToggledItem,
		LastTryOnClassicHeadShape = 0,
		BodyColor3s = 0,
		BodyPartColorRangeIds = 0
	}
	local lastTryOnClassicHeadShape

	if v then
		lastTryOnClassicHeadShape = Cryo.None
	end

	v3.LastTryOnClassicHeadShape = lastTryOnClassicHeadShape
	local bodyColor3s

	if v2 then
		bodyColor3s = Cryo.None
	end

	v3.BodyColor3s = bodyColor3s
	local bodyPartColorRangeIds

	if v2 then
		bodyPartColorRangeIds = Cryo.None
	end

	v3.BodyPartColorRangeIds = bodyPartColorRangeIds
	return join(p, v3)
end

local function isAnimationOrEmoteItem(p): boolean -- 1 equivalent call inferred from this helper
	if p.itemType == ItemTypeEnum.Asset and p.itemSubType == ASSET_TYPE_NAME_TO_ID_STRING.EmoteAnimation then
		return true
	end

	return p.itemType == ItemTypeEnum.Bundle and p.itemSubType == tostring(BundleTypeIdStrings.Animations)
end

local function getTryOnItemsContainsRecolorableBody(items): boolean
	for _, item in items do
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
	local v = Cryo.None
	local v2 = Cryo.None

	for _, item in tryOnItems do
		if item.lookId and not MAKEUP_LOOK_ASSET_TYPES[item.itemSubType] then
			v = item.lookId
		end

		if item.lookId and MAKEUP_LOOK_ASSET_TYPES[item.itemSubType] then
			v2 = item.lookId
		end
	end

	return v, v2
end

local function reconcileAllTryOnState(data)
	local tryOnItems = data.TryOnItems
	local lookId, makeupLookId

	if FFlagAXMISEnableMultiShopping then
		lookId, makeupLookId = getTryOnItemsMakeupAndAvatarLookIds(tryOnItems)
	end

	local v = getTryOnItemsContainsRecolorableBody(tryOnItems)

	if FFlagAXMISEnableMultiShopping then
		v = v or lookId ~= nil
	end

	if FFlagAXPhotoboothMomentsPage then
		v = v or data.OutfitId ~= nil
	end

	local bodyColor3s = if v then data.BodyColor3s else Cryo.None
	local bodyPartColorRangeIds

	if v then
		bodyPartColorRangeIds = data.BodyPartColorRangeIds
	else
		bodyPartColorRangeIds = Cryo.None
	end

	local defaultTryOnBodyColorsToggled

	if v then
		defaultTryOnBodyColorsToggled = data.DefaultTryOnBodyColorsToggled
	else
		defaultTryOnBodyColorsToggled = false
	end

	local v2

	if FFlagAXMISEnableMultiShopping then
		v2 = tutils.fieldCount(tryOnItems) == 0
	end

	local lookType

	if FFlagAXMISEnableMultiShopping then
		lookType = if v2 then Cryo.None else data.LookType
	end

	local makeupLookType

	if FFlagAXMISEnableMultiShopping then
		if v2 or not makeupLookId then
			makeupLookType = Cryo.None
		else
			makeupLookType = LOOK_TYPE.Makeup
		end
	end

	local join = Cryo.Dictionary.join

	if not FFlagAXMISEnableMultiShopping then
		lookId = nil
	end

	if not FFlagAXMISEnableMultiShopping then
		lookType = nil
	end

	if not FFlagAXMISEnableMultiShopping then
		makeupLookId = nil
	end

	if not FFlagAXMISEnableMultiShopping then
		makeupLookType = nil
	end

	local shouldTryOnWithoutEquippedItems

	if FFlagAXMISEnableMultiShopping then
		if v2 then
			shouldTryOnWithoutEquippedItems = false
		else
			shouldTryOnWithoutEquippedItems = data.ShouldTryOnWithoutEquippedItems
		end
	end

	local shouldTryOnWithoutEquippedBody

	if FFlagAXTryOnWithoutEquippedBody then
		if v2 then
			shouldTryOnWithoutEquippedBody = false
		else
			shouldTryOnWithoutEquippedBody = data.ShouldTryOnWithoutEquippedBody
		end
	end

	return join(data, {
		BodyColor3s = bodyColor3s,
		BodyPartColorRangeIds = bodyPartColorRangeIds,
		DefaultTryOnBodyColorsToggled = defaultTryOnBodyColorsToggled,
		LookId = lookId,
		LookType = lookType,
		MakeupLookId = makeupLookId,
		MakeupLookType = makeupLookType,
		ShouldTryOnWithoutEquippedItems = shouldTryOnWithoutEquippedItems,
		ShouldTryOnWithoutEquippedBody = shouldTryOnWithoutEquippedBody
	})
end

local v = {
	TryOnItems = {},
	DefaultTryOnBodyColorsToggled = false,
	LookId = nil,
	LookType = nil,
	MakeupLookId = nil,
	MakeupLookType = nil,
	LastToggledLookType = nil,
	LastTryOnClassicHeadShape = nil,
	OutfitIdMap = {},
	ShouldTryOnWithoutEquippedItems = not FFlagAXMISEnableMultiShopping and nil,
	ShouldTryOnWithoutEquippedBody = not FFlagAXTryOnWithoutEquippedBody and nil,
	BackgroundPreview = nil,
	AvatarType = nil,
	OutfitId = nil
}

return Rodux.createReducer(v, {
	[TryOnColorUpdated.name] = function(p, p2)
		local clone = table.clone(p or v)
		clone.BodyColor3s = p2.colors
		clone.BodyPartColorRangeIds = p2.bodyPartColorRangeIds
		return clone
	end,
	[ToggleTryOn.name] = function(p, data)
		local v2 = p or v
		local tryOnItems = v2.TryOnItems or {}
		local v3 = v2.LookId ~= nil
		local tryOnItemReducerKey = getTryOnItemReducerKey(data.itemId, data.itemType)
		local v4

		if FFlagAXMISEnableMultiShopping then
			v4 = tryOnItems[tryOnItemReducerKey] ~= nil
		elseif tryOnItems[tryOnItemReducerKey] == nil then
			v4 = false
		else
			v4 = not v3
		end

		if v4 then
			if FFlagAXMISEnableMultiShopping then
				return reconcileAllTryOnState(removeItem(v2, tryOnItems, data))
			end

			return removeItem(v2, tryOnItems, data)
		else
			local v5 = FFlagAXMISEnableMultiShopping and data.resetTryOnsBeforeToggleOn and {} or tryOnItems

			local v6 = ReducerUtils.filterTryOns(v5, data)
			local lastToggledItem = formatItem(data, false)

			if FFlagAXMISEnableMultiShopping then
				v6 = getFilteredTryOnItems(v5, lastToggledItem)
			end

			local lastAnimOrEmoteToggledItem

			if isAnimationOrEmoteItem(lastToggledItem) then -- inferred equivalent call
				lastAnimOrEmoteToggledItem = lastToggledItem
			end

			if FFlagAXMISEnableMultiShopping or not v3 then
				local joined = Cryo.Dictionary.join(v6, { [tryOnItemReducerKey] = lastToggledItem })

				local v7 = getTryOnItemsContainsRecolorableBody(joined)

				if FFlagAXPhotoboothMomentsPage then
					v7 = v7 or v2.OutfitId ~= nil
				end

				local bodyColor3s

				if v7 then
					bodyColor3s = v2.BodyColor3s
				else
					bodyColor3s = Cryo.None
				end

				local bodyPartColorRangeIds

				if v7 then
					bodyPartColorRangeIds = v2.BodyPartColorRangeIds
				else
					bodyPartColorRangeIds = Cryo.None
				end

				local defaultTryOnBodyColorsToggled

				if v7 then
					defaultTryOnBodyColorsToggled = v2.DefaultTryOnBodyColorsToggled
				else
					defaultTryOnBodyColorsToggled = false
				end

				local joined2 = Cryo.Dictionary.join(v2, {
					TryOnItems = joined,
					LastToggledItem = lastToggledItem,
					LastAnimOrEmoteToggledItem = lastAnimOrEmoteToggledItem,
					BodyColor3s = bodyColor3s,
					BodyPartColorRangeIds = bodyPartColorRangeIds,
					DefaultTryOnBodyColorsToggled = defaultTryOnBodyColorsToggled
				})

				if not FFlagAXMISEnableMultiShopping then
					return joined2
				end

				if FFlagAXCatalogMakeupSupport then
					joined = removeMakeupAssetsFromTryOnsIfOverLimit(joined)
				end

				return reconcileAllTryOnState(Cryo.Dictionary.join(joined2, {
					TryOnItems = joined,
					LastToggledItem = lastToggledItem,
					LastAnimOrEmoteToggledItem = lastAnimOrEmoteToggledItem
				}))
			end

			return Cryo.Dictionary.join(v2, {
				TryOnItems = { [data.itemId] = lastToggledItem },
				LastToggledItem = lastToggledItem,
				LastAnimOrEmoteToggledItem = lastAnimOrEmoteToggledItem,
				LookId = Cryo.None,
				BodyColor3s = {},
				BodyPartColorRangeIds = Cryo.None,
				DefaultTryOnBodyColorsToggled = false
			})
		end
	end,
	[TryOnClassicHeadShape.name] = function(p, p2)
		local join = Cryo.Dictionary.join
		local lastTryOnClassicHeadShape

		if p2.headShape then
			lastTryOnClassicHeadShape = p2.headShape
		else
			lastTryOnClassicHeadShape = Cryo.None
		end

		return join(p, { LastTryOnClassicHeadShape = lastTryOnClassicHeadShape })
	end,
	[TryOnLooksOutfit.name] = function(p, data)
		local v2 = p or v
		local tryOnItems

		if FFlagAXMISEnableMultiShopping and FFlagAXCatalogMakeupSupport and data.lookType == LOOK_TYPE.Makeup then
			tryOnItems = table.clone(v2.TryOnItems)

			for k, v3 in tryOnItems do
				if MAKEUP_LOOK_ASSET_TYPES[v3.itemSubType] then
					tryOnItems[k] = nil
				end
			end
		else
			tryOnItems = {}
		end

		for _, v3 in data.assetItemIdTypeAndSubtype do
			local tryOnItemReducerKey = getTryOnItemReducerKey(v3.itemId, v3.itemType)

			local lookType = data.lookType
			local lookId

			if FFlagAXMISEnableMultiShopping then
				lookId = data.lookId
			end

			local v4

			if FFlagAXPhotoboothMomentsPage then
				v4 = data.outfitId
			end

			tryOnItems[tryOnItemReducerKey] = formatItemFromLookOutfit(v3, lookType, lookId, v4)
		end

		if data.bundleItemIdTypeAndSubtype ~= nil then
			for _, v3 in data.bundleItemIdTypeAndSubtype do
				local tryOnItemReducerKey = getTryOnItemReducerKey(v3.itemId, v3.itemType)
				local v4

				if FFlagAXMISEnableMultiShopping then
					v4 = data.lookId
				end

				tryOnItems[tryOnItemReducerKey] = formatBundleFromLookOutfit(v3, v4)
			end
		end

		if FFlagAXMISEnableMultiShopping and FFlagAXCatalogMakeupSupport and data.lookType == LOOK_TYPE.Makeup then
			local join = Cryo.Dictionary.join
			local makeupLookId

			if data.lookId then
				makeupLookId = data.lookId
			else
				makeupLookId = Cryo.None
			end

			local v3 = {
				TryOnItems = tryOnItems,
				MakeupLookId = makeupLookId,
				MakeupLookType = data.lookType,
				LastToggledLookType = data.lookType,
				MakeupLookAnalyticsInfo = 0
			}
			local makeupLookAnalyticsInfo

			if data.analyticsInfo then
				makeupLookAnalyticsInfo = data.analyticsInfo
			else
				makeupLookAnalyticsInfo = Cryo.None
			end

			v3.MakeupLookAnalyticsInfo = makeupLookAnalyticsInfo
			return join(v2, v3)
		else
			local join = Cryo.Dictionary.join
			local lookId

			if data.lookId then
				lookId = data.lookId
			else
				lookId = Cryo.None
			end

			local lookAnalyticsInfo

			if data.analyticsInfo then
				lookAnalyticsInfo = data.analyticsInfo
			else
				lookAnalyticsInfo = Cryo.None
			end

			local v3 = {
				TryOnItems = tryOnItems,
				LookId = lookId,
				LookAnalyticsInfo = lookAnalyticsInfo,
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
			local lastToggledLookType

			if FFlagAXMISEnableMultiShopping then
				lastToggledLookType = data.lookType
			end

			v3.LastToggledLookType = lastToggledLookType
			local bodyColor3s

			if data.bodyColor3s then
				bodyColor3s = data.bodyColor3s
			else
				bodyColor3s = Cryo.None
			end

			v3.BodyColor3s = bodyColor3s
			local bodyPartColorRangeIds

			if data.bodyPartColorRangeIds then
				bodyPartColorRangeIds = data.bodyPartColorRangeIds
			else
				bodyPartColorRangeIds = Cryo.None
			end

			v3.BodyPartColorRangeIds = bodyPartColorRangeIds

			v3.DefaultTryOnBodyColorsToggled = Cryo.None
			local scale

			if data.scale then
				scale = data.scale
			else
				scale = Cryo.None
			end

			v3.Scale = scale
			local shouldTryOnWithoutEquippedItems

			if FFlagAXMISEnableMultiShopping then
				shouldTryOnWithoutEquippedItems = data.lookId ~= nil
					or FFlagAXPhotoboothMomentsPage and data.outfitId ~= nil
			end

			v3.ShouldTryOnWithoutEquippedItems = shouldTryOnWithoutEquippedItems
			local shouldTryOnWithoutEquippedBody

			if FFlagAXTryOnWithoutEquippedBody then
				shouldTryOnWithoutEquippedBody = data.shouldTryOnWithoutEquippedBody == true
			end

			v3.ShouldTryOnWithoutEquippedBody = shouldTryOnWithoutEquippedBody
			local avatarType

			if FFlagAXPhotoboothMomentsPage then
				if data.avatarType then
					avatarType = data.avatarType
				else
					avatarType = Cryo.None
				end
			end

			v3.AvatarType = avatarType
			local outfitId

			if FFlagAXPhotoboothMomentsPage then
				if data.outfitId == nil then
					outfitId = Cryo.None
				else
					outfitId = data.outfitId
				end
			end

			v3.OutfitId = outfitId
			return join(v2, v3)
		end
	end,
	[SetEquippedInTryOnManager.name] = function(p, data)
		local v2 = p or v
		local tryOnItems = v2.TryOnItems or {}

		local tryOnItemReducerKey = getTryOnItemReducerKey(data.itemId, data.itemType)

		if tryOnItems[tryOnItemReducerKey] == nil then
			return v2
		end

		return Cryo.Dictionary.join(v2, {
			TryOnItems = Cryo.Dictionary.join(tryOnItems, {
				[tryOnItemReducerKey] = Cryo.Dictionary.join(tryOnItems[tryOnItemReducerKey], {
					selectedInTryOnManager = data.selectedInTryOnManager
				})
			})
		})
	end,
	[SetSelectedTimedOption.name] = function(p, data)
		local v2 = p or v
		local tryOnItems = v2.TryOnItems or {}

		local tryOnItemReducerKey = getTryOnItemReducerKey(data.itemId, data.itemType)

		if tryOnItems[tryOnItemReducerKey] == nil then
			return v2
		end

		return Cryo.Dictionary.join(v2, {
			TryOnItems = Cryo.Dictionary.join(tryOnItems, {
				[tryOnItemReducerKey] = Cryo.Dictionary.join(tryOnItems[tryOnItemReducerKey], {
					selectedTimedOptionIndex = data.selectedTimedOptionIndex
				})
			})
		})
	end,
	[RemoveUnselectedItemsFromTryOn.name] = function(p, _)
		local v2 = p or v
		local tryOnItems = {}

		for k, v3 in v2.TryOnItems or {} do
			if v3.selectedInTryOnManager then
				tryOnItems[k] = v3
			end
		end

		return Cryo.Dictionary.join(v2, { TryOnItems = tryOnItems })
	end,
	[RemoveLookFromTryOn.name] = FFlagAXMISEnableMultiShopping and function(p, p2)
		local v2 = p or v
		local tryOnItems = {}

		for k, v3 in v2.TryOnItems or {} do
			if v3.lookId ~= p2.lookId then
				tryOnItems[k] = v3
			end
		end

		if FFlagAXCatalogMakeupSupport and v2.MakeupLookId == p2.lookId then
			return Cryo.Dictionary.join(v2, {
				TryOnItems = tryOnItems,
				MakeupLookId = Cryo.None,
				MakeupLookType = Cryo.None,
				MakeupLookAnalyticsInfo = Cryo.None,
				LastToggledLookType = Cryo.None
			})
		end

		return Cryo.Dictionary.join(v2, {
			TryOnItems = tryOnItems,
			LookId = Cryo.None,
			LookType = Cryo.None,
			LookAnalyticsInfo = Cryo.None,
			BodyColor3s = Cryo.None,
			BodyPartColorRangeIds = Cryo.None,
			Scale = Cryo.None,
			LastToggledLookType = Cryo.None,
			ShouldTryOnWithoutEquippedItems = false,
			ShouldTryOnWithoutEquippedBody = not FFlagAXTryOnWithoutEquippedBody and nil
		})
	end or nil,
	[RemoveFromTryOn.name] = function(p, p2)
		local v2 = p or v
		local tryOnItems = v2.TryOnItems or {}

		local itemInTryOnItems = findItemInTryOnItems(tryOnItems, p2.itemId, p2.itemType)

		if itemInTryOnItems == nil then
			return v2
		end

		return reconcileAllTryOnState(removeItem(v2, tryOnItems, itemInTryOnItems))
	end,
	[RemoveLookItemsFromTryOn.name] = function(p, data)
		local joined = p or v

		if data.lookId == joined.LookId then
			local tryOnItems = joined.TryOnItems or {}

			for _, assetId in data.assetIds do
				local tryOnItemReducerKey = getTryOnItemReducerKey(assetId, ItemTypeEnum.Asset)

				if tryOnItems[tryOnItemReducerKey] ~= nil then
					tryOnItems = Cryo.Dictionary.join(tryOnItems, {
						[tryOnItemReducerKey] = Cryo.None
					})
				end
			end

			if data.bundleIds ~= nil then
				for _, bundleId in data.bundleIds do
					local tryOnItemReducerKey = getTryOnItemReducerKey(bundleId, ItemTypeEnum.Bundle)

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
				ShouldTryOnWithoutEquippedItems = not FFlagAXMISEnableMultiShopping and nil,
				ShouldTryOnWithoutEquippedBody = not FFlagAXTryOnWithoutEquippedBody and nil
			})
		end

		if
			not FFlagAXMISEnableMultiShopping
			or not FFlagAXCatalogMakeupSupport
			or data.lookId ~= joined.MakeupLookId
		then
			return joined
		end

		local tryOnItems = joined.TryOnItems or {}

		for _, assetId in data.assetIds do
			local tryOnItemReducerKey = getTryOnItemReducerKey(assetId, ItemTypeEnum.Asset)

			if tryOnItems[tryOnItemReducerKey] ~= nil then
				tryOnItems = Cryo.Dictionary.join(tryOnItems, { [tryOnItemReducerKey] = Cryo.None })
			end
		end

		if data.bundleIds ~= nil then
			for _, bundleId in data.bundleIds do
				local tryOnItemReducerKey = getTryOnItemReducerKey(bundleId, ItemTypeEnum.Bundle)

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
	[ReceivedBundleInfoForTryOn.name] = function(p, p2)
		local v2 = p or v
		local tryOnItems = v2.TryOnItems or {}

		local tryOnItemReducerKey = getTryOnItemReducerKey(p2.itemId, ItemTypeEnum.Bundle)

		if not tryOnItems[tryOnItemReducerKey] then
			return v2
		end

		local clone = table.clone(v2.OutfitIdMap or {})
		clone[p2.itemId] = p2.outfitId

		return Cryo.Dictionary.join(v2, {
			TryOnItems = Cryo.Dictionary.join(tryOnItems, {
				[tryOnItemReducerKey] = Cryo.Dictionary.join(tryOnItems[tryOnItemReducerKey], {
					receivedBundleInfo = true
				})
			}),
			OutfitIdMap = clone
		})
	end,
	[ClearTryOns.name] = function(data, p)
		if not data then
			return v
		end

		local v2

		if FFlagAXPhotoboothMomentsPage then
			v2 = data.LookId ~= nil or data.OutfitId ~= nil
		else
			v2 = data.LookId ~= nil
		end

		local retainTryOnColor = not v2 and p.retainTryOnColor
		local join = Cryo.Dictionary.join
		local v3 = {
			LastTryOnClassicHeadShape = data.LastTryOnClassicHeadShape,
			DefaultTryOnBodyColorsToggled = 0,
			BodyColor3s = 0,
			BodyPartColorRangeIds = 0,
			OutfitIdMap = 0,
			ShouldTryOnWithoutEquippedItems = 0,
			ShouldTryOnWithoutEquippedBody = 0,
			LastToggledLookType = 0
		}
		local defaultTryOnBodyColorsToggled

		if retainTryOnColor then
			defaultTryOnBodyColorsToggled = data.DefaultTryOnBodyColorsToggled
		end

		v3.DefaultTryOnBodyColorsToggled = defaultTryOnBodyColorsToggled
		local bodyColor3s

		if retainTryOnColor then
			bodyColor3s = data.BodyColor3s
		end

		v3.BodyColor3s = bodyColor3s
		local bodyPartColorRangeIds

		if retainTryOnColor then
			bodyPartColorRangeIds = data.BodyPartColorRangeIds
		end

		v3.BodyPartColorRangeIds = bodyPartColorRangeIds
		v3.OutfitIdMap = not data and {} or data.OutfitIdMap
		v3.ShouldTryOnWithoutEquippedItems = not FFlagAXMISEnableMultiShopping and nil
		v3.ShouldTryOnWithoutEquippedBody = not FFlagAXTryOnWithoutEquippedBody and nil
		local lastToggledLookType

		if FFlagAXMISEnableMultiShopping and FFlagAXCatalogMakeupSupport then
			lastToggledLookType = Cryo.None
		end

		v3.LastToggledLookType = lastToggledLookType
		return join(v, v3)
	end,
	[NavigatedToNonTryOnPage.name] = function(p, _)
		local clone = table.clone(v)

		if p and p.OutfitIdMap then
			clone.OutfitIdMap = p.OutfitIdMap
		end

		return clone
	end,
	[NavigatedToTryOnPage.name] = function(p, _)
		local clone = table.clone(v)

		if p and p.OutfitIdMap then
			clone.OutfitIdMap = p.OutfitIdMap
		end

		return clone
	end,
	[SetBackgroundPreview.name] = function(p, p2)
		local clone = table.clone(p or v)
		clone.BackgroundPreview = p2.previewKey
		return clone
	end,
	[DefaultTryOnBodyColorsToggled.name] = function(p, p2)
		local clone = table.clone(p or v)

		clone.DefaultTryOnBodyColorsToggled = p2.state
		return clone
	end,
	[SetOrderForTryOns.name] = function(p, p2)
		local v2 = p or v

		for k, orderMap in p2.itemIdToOrderMap do
			local tryOnItems = v2.TryOnItems or {}

			local tryOnItemReducerKey = getTryOnItemReducerKey(k, ItemTypeEnum.Asset)

			if tryOnItems[tryOnItemReducerKey] and tryOnItems[tryOnItemReducerKey].itemType ~= ItemTypeEnum.Bundle then
				v2 = Cryo.Dictionary.join(v2, {
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
						and tryOnItem.itemId ~= Constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID
					then
						local bundleInfo = tryOnItem.bundleInfo
						local joined = Cryo.Dictionary.join(bundleInfo, {
							[k] = Cryo.Dictionary.join(bundleInfo[k], { order = orderMap })
						})

						v2 = Cryo.Dictionary.join(p, {
							TryOnItems = Cryo.Dictionary.join(tryOnItems, {
								[k2] = Cryo.Dictionary.join(tryOnItems[k2], { bundleInfo = joined })
							})
						})
						break
					end
				end
			end
		end

		return v2
	end,
	[SetAccessoryAdjustments.name] = function(p, data)
		local v2 = p or v
		local tryOnItems = v2.TryOnItems or {}

		for k, tryOnItem in tryOnItems do
			if tryOnItem.itemType == "Asset" then
				if tryOnItem.itemId == data.itemId then
					return Cryo.Dictionary.join(v2, {
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
						local bundleInfo2 = Cryo.Dictionary.join(bundleInfo, {
							[data.itemId] = Cryo.Dictionary.join(bundleInfo[data.itemId], {
								position = data.position,
								rotation = data.rotation,
								scale = data.scale
							})
						})

						return Cryo.Dictionary.join(p, {
							TryOnItems = Cryo.Dictionary.join(tryOnItems, {
								[k2] = Cryo.Dictionary.join(tryOnItems[k2], {
									bundleInfo = bundleInfo2
								})
							})
						})
					end
				end
			end
		end

		return v2
	end,
	[AddSelectedBundleInfo.name] = function(p, p2)
		local v2 = p or v
		local tryOnItems = v2.TryOnItems or {}

		local tryOnItemReducerKey = getTryOnItemReducerKey(p2.bundleId, ItemTypeEnum.Bundle)

		if tryOnItems[tryOnItemReducerKey] then
			return Cryo.Dictionary.join(v2, {
				TryOnItems = Cryo.Dictionary.join(tryOnItems, {
					[tryOnItemReducerKey] = Cryo.Dictionary.join(tryOnItems[tryOnItemReducerKey], {
						bundleInfo = p2.bundleInfo
					})
				})
			})
		end

		return v2
	end,
	[SetOutfitTryOns.name] = function(_, p)
		return p.outfitTryOns
	end,
	[RemoveLook.name] = function(p, p2)
		local v2 = p or v

		if
			p2.lookId ~= v2.LookId
			and (not FFlagAXMISEnableMultiShopping or not FFlagAXCatalogMakeupSupport or p2.lookId ~= v2.MakeupLookId)
		then
			return v2
		end

		local tryOnItems = {}

		if FFlagAXMISEnableMultiShopping then
			for k, v3 in v2.TryOnItems or {} do
				if v3.lookId ~= p2.lookId then
					tryOnItems[k] = v3
				end
			end
		end

		if FFlagAXMISEnableMultiShopping and FFlagAXCatalogMakeupSupport then
			if p2.lookId == v2.LookId then
				v2 = Cryo.Dictionary.join(v2, {
					TryOnItems = tryOnItems,
					LookId = Cryo.None,
					LookType = Cryo.None,
					BodyColor3s = Cryo.None,
					BodyPartColorRangeIds = Cryo.None,
					Scale = Cryo.None,
					ShouldTryOnWithoutEquippedItems = false,
					ShouldTryOnWithoutEquippedBody = not FFlagAXTryOnWithoutEquippedBody and nil,
					LastToggledLookType = Cryo.None
				})
			end

			if p2.lookId == v2.MakeupLookId then
				return (Cryo.Dictionary.join(v2, {
					TryOnItems = tryOnItems,
					MakeupLookId = Cryo.None,
					MakeupLookType = Cryo.None,
					LastToggledLookType = Cryo.None
				}))
			end

			return v2
		end

		return (Cryo.Dictionary.join(v2, {
			TryOnItems = tryOnItems,
			LookId = Cryo.None,
			LookType = Cryo.None,
			BodyColor3s = Cryo.None,
			BodyPartColorRangeIds = Cryo.None,
			Scale = Cryo.None,
			ShouldTryOnWithoutEquippedItems = not FFlagAXMISEnableMultiShopping and nil,
			ShouldTryOnWithoutEquippedBody = not FFlagAXTryOnWithoutEquippedBody and nil
		}))
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(p, p2)
		if p2.tryOn and p2.tryOn.OutfitTryOn then
			return table.clone(p2.tryOn.OutfitTryOn)
		end

		return p
	end,
	[SetLastToggledLookType.name] = FFlagAXMISEnableMultiShopping and function(p, p2)
		return Cryo.Dictionary.join(p or v, { LastToggledLookType = p2.lastToggledLookType })
	end or nil
})
