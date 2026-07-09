local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AvatarExperienceHeadRefinement = require(CorePackages.Workspace.Packages.AvatarExperienceHeadRefinement)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local tutils = require(CorePackages.Packages.tutils)
local TryOnLooksOutfit = AvatarExperienceRodux.Actions.TryOnLooksOutfit
local ToggleTryOn = AvatarExperienceRodux.Actions.ToggleTryOn
local TryOnColorUpdated = AvatarExperienceRodux.Actions.TryOnColorUpdated
local SetEquippedInTryOnManager = AvatarExperienceRodux.Actions.SetEquippedInTryOnManager
local SetSelectedTimedOption = AvatarExperienceRodux.Actions.SetSelectedTimedOption
local RemoveUnselectedItemsFromTryOn = AvatarExperienceRodux.Actions.RemoveUnselectedItemsFromTryOn
local RemoveFromTryOn = AvatarExperienceRodux.Actions.RemoveFromTryOn
local RemoveLookItemsFromTryOn = AvatarExperienceRodux.Actions.RemoveLookItemsFromTryOn
local ReceivedBundleInfoForTryOn = AvatarExperienceRodux.Actions.ReceivedBundleInfoForTryOn
local ClearTryOns = AvatarExperienceRodux.Actions.ClearTryOns
local SetOrderForTryOns = AvatarExperienceRodux.Actions.SetOrderForTryOns
local SetAdjustableTryOnIds = require(Modules.AvatarExperience.Common.Actions.SetAdjustableTryOnIds)
local AddSelectedBundleInfo = require(Modules.AvatarExperience.Common.Actions.AddSelectedBundleInfo)
local SetOutfitTryOns = require(Modules.AvatarExperience.Common.Actions.SetOutfitTryOns)
local SetAccessoryAdjustments = require(Modules.AvatarExperience.AccessoryAdjustment.Actions.SetAccessoryAdjustments)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ReducerUtils = AvatarExperienceRodux.Utils.ReducerUtils

require(Modules.AvatarExperience.Common.Types)

local RemoveLook = require(Modules.AvatarExperience.Common.Actions.RemoveLook)
local RemoveLookFromTryOn = require(Modules.AvatarExperience.Common.Actions.RemoveLookFromTryOn)
local TryOnClassicHeadShape = AvatarExperienceHeadRefinement.Actions.TryOnClassicHeadShape
local NavigatedToNonTryOnPage = require(Modules.AvatarExperience.Common.Actions.NavigatedToNonTryOnPage)
local NavigatedToTryOnPage = require(Modules.AvatarExperience.Common.Actions.NavigatedToTryOnPage)
local DefaultTryOnBodyColorsToggled = require(Modules.AvatarExperience.Common.Actions.DefaultTryOnBodyColorsToggled)
local findItemInTryOnItems = AvatarExperienceCommon.Utils.findItemInTryOnItems
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local getFilteredTryOnItems = AvatarExperienceCatalog.Utils.TryOns.getFilteredTryOnItems
local removeMakeupAssetsFromTryOnsIfOverLimit = AvatarExperienceCatalog.Utils.TryOns.removeMakeupAssetsFromTryOnsIfOverLimit
local SetLastToggledLookType = AvatarExperienceCatalog.State.Actions.SetLastToggledLookType
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local LAYERED_MAKEUP_ORDER = AvatarExperienceCommon.Constants.LAYERED_MAKEUP_ORDER
local MAKEUP_LOOK_ASSET_TYPES = AvatarExperienceCommon.Constants.MAKEUP_LOOK_ASSET_TYPES
local LOOK_TYPE = AvatarExperienceCommon.Constants.LOOK_TYPE
local Constants2 = AvatarExperienceCommon.Constants
local ItemTypeEnum = AvatarExperienceCommon.Enums.ItemTypeEnum
local ASSET_TYPE_NAME_TO_ID_STRING = Constants2.ASSET_TYPE_NAME_TO_ID_STRING
local BUNDLE_TYPE_ID_STRINGS = Constants2.BUNDLE_TYPE_ID_STRINGS
local BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND = Constants2.BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND
local LAYERED_CLOTHING_ORDER = Constants2.LAYERED_CLOTHING_ORDER
local LAYERED_ASSET_TYPES = Constants2.LAYERED_ASSET_TYPES
local ASSET_TYPE_TO_ACCESSORY_TYPE = Constants2.ASSET_TYPE_TO_ACCESSORY_TYPE
local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local AXEnableAccessoryAdjustmentDuringTryOnIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXEnableAccessoryAdjustmentDuringTryOnIXP
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local FFlagDynamicHeadsMigration = AvatarExperienceFlags.FFlagDynamicHeadsMigration
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local n1 = 0

local function formatItem(p1, b1: boolean) -- line: 153
	-- upvalues: FFlagAXMISEnableMultiShopping (copy), FFlagDynamicHeadsMigration (copy), ItemTypeEnum (copy), BUNDLE_TYPE_ID_STRINGS (copy), ASSET_TYPE_NAME_TO_ID_STRING (copy), FFlagParseHeadShapeFromAPIResponse (copy), FFlagHeadRefinementFacialAnimationToggle (copy), FFlagAXDurablesForMIS (copy), ASSET_TYPE_TO_ACCESSORY_TYPE (copy), LAYERED_CLOTHING_ORDER (copy), LAYERED_ASSET_TYPES (copy), Cryo (copy), FFlagAXCustomizeMakeupSupport (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), LAYERED_MAKEUP_ORDER (copy), n1 (ref)
	local v75 = not not p1.receivedBundleInfo
	local bundleInfo = p1.bundleInfo

	if FFlagAXMISEnableMultiShopping and (p1.bundleItems and not v75) then
		bundleInfo = {}

		for _, v78 in p1.bundleItems do
			if FFlagDynamicHeadsMigration and v78.type == ItemTypeEnum.Asset then
				local v79 = v78.assetType or (p1.itemSubType ~= BUNDLE_TYPE_ID_STRINGS.DynamicHead or ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead)

				if v79 then
					local t1 = {
						assetType = v79
					}

					if FFlagParseHeadShapeFromAPIResponse and v78.meta and v78.meta.headShape ~= nil then
						t1.headShape = v78.meta.headShape
					end

					if FFlagHeadRefinementFacialAnimationToggle and v78.meta and v78.meta.staticFacialAnimation ~= nil then
						t1.staticFacialAnimation = v78.meta.staticFacialAnimation
					end

					bundleInfo[v78.id] = t1
				end
			elseif v78.type == ItemTypeEnum.Asset and v78.assetType then
				local t2 = {
					assetType = v78.assetType
				}

				if FFlagParseHeadShapeFromAPIResponse and v78.meta and v78.meta.headShape ~= nil then
					t2.headShape = v78.meta.headShape
				end

				if FFlagHeadRefinementFacialAnimationToggle and v78.meta and v78.meta.staticFacialAnimation ~= nil then
					t2.staticFacialAnimation = v78.meta.staticFacialAnimation
				end

				bundleInfo[v78.id] = t2
			end
		end

		v75 = true
	end

	local t3 = {
		version = "1",
		itemId = p1.itemId,
		itemType = p1.itemType,
		itemSubType = p1.itemSubType,
		selectedInTryOnManager = p1.selectedInTryOnManager,
		isUnequipped = b1,
		receivedBundleInfo = v75,
		bundleInfo = if not FFlagAXMISEnableMultiShopping then p1.bundleInfo else bundleInfo,
		widgetInfo = p1.widgetInfo,
		isRecolorable = p1.isRecolorable,
		selectedTimedOptionIndex = if not FFlagAXDurablesForMIS then nil else p1.selectedTimedOptionIndex
	}

	if ASSET_TYPE_TO_ACCESSORY_TYPE[p1.itemSubType] then
		local t4 = {
			order = p1.overrideOrder or LAYERED_CLOTHING_ORDER[p1.itemSubType],
			isLayered = LAYERED_ASSET_TYPES[p1.itemSubType] ~= nil
		}

		t3 = Cryo.Dictionary.join(t3, t4)
	elseif FFlagAXCustomizeMakeupSupport and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p1.itemSubType] then
		local t5 = {
			isLayered = true,
			order = p1.overrideOrder or LAYERED_MAKEUP_ORDER[p1.itemSubType]
		}

		t3 = Cryo.Dictionary.join(t3, t5)
	end

	if not b1 then
		t3.itemRecency = n1
		n1 += 1
	end

	return t3
end
local function formatItemFromLookOutfit(p2, p3, s1: string?) -- line: 253
	-- upvalues: ASSET_TYPE_TO_ACCESSORY_TYPE (copy), LAYERED_CLOTHING_ORDER (copy), LAYERED_ASSET_TYPES (copy), Cryo (copy), FFlagAXCustomizeMakeupSupport (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), LAYERED_MAKEUP_ORDER (copy), LOOK_TYPE (copy), FFlagAXCatalogMakeupSupport (copy), n1 (ref)
	local t6 = {
		version = "1",
		isUnequipped = false,
		receivedBundleInfo = false,
		itemId = p2.itemId,
		itemType = p2.itemType,
		itemSubType = p2.itemSubType,
		selectedInTryOnManager = p2.isNotSelectable ~= true,
		lookId = s1
	}

	if ASSET_TYPE_TO_ACCESSORY_TYPE[p2.itemSubType] then
		local t7 = {
			order = p2.order or LAYERED_CLOTHING_ORDER[p2.itemSubType],
			isLayered = LAYERED_ASSET_TYPES[p2.itemSubType] ~= nil
		}

		t6 = Cryo.Dictionary.join(t6, t7)
	elseif FFlagAXCustomizeMakeupSupport and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p2.itemSubType] then
		local t8 = {
			isLayered = true,
			order = p2.order or LAYERED_MAKEUP_ORDER[p2.itemSubType]
		}

		t6 = Cryo.Dictionary.join(t6, t8)
	end

	t6.itemRecency = if p3 ~= LOOK_TYPE.Avatar and (not FFlagAXCatalogMakeupSupport or p3 ~= LOOK_TYPE.Makeup) then n1 else p2.tryOnItemOrder
	n1 += 1

	return t6
end
local function formatBundleFromLookOutfit(p4, s2: string?) -- line: 292
	-- upvalues: FFlagAXMISEnableMultiShopping (copy), LAYERED_CLOTHING_ORDER (copy), FFlagAXCustomizeMakeupSupport (copy), LAYERED_MAKEUP_ORDER (copy), FFlagParseHeadShapeFromAPIResponse (copy), n1 (ref)
	local t9 = {
		version = "1",
		isUnequipped = false,
		receivedBundleInfo = false,
		selectedInTryOnManager = p4.isNotSelectable ~= true,
		itemType = p4.itemType,
		itemId = p4.itemId,
		itemSubType = if not FFlagAXMISEnableMultiShopping then nil else p4.itemSubType,
		lookId = s2
	}
	local t10 = {}

	for _, v96 in p4.items do
		t10[v96.itemId] = {
			assetType = v96.itemSubType,
			order = LAYERED_CLOTHING_ORDER[v96.itemSubType] or if not FFlagAXCustomizeMakeupSupport then nil else LAYERED_MAKEUP_ORDER[v96.itemSubType],
			headShape = if not FFlagParseHeadShapeFromAPIResponse then nil else v96.headShape
		}
	end

	t9.bundleInfo = t10
	t9.itemRecency = p4.tryOnItemOrder or n1
	n1 += 1

	return t9
end
local function removeItem(p5, p6, t11: {[any]: any}) -- line: 324
	-- upvalues: getTryOnItemReducerKey (copy), ASSET_TYPE_NAME_TO_ID_STRING (copy), ItemTypeEnum (copy), BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND (copy), Cryo (copy)
	local v100 = getTryOnItemReducerKey(t11.itemId, t11.itemType)
	local v101 = p6[v100]

	v101.isUnequipped = true

	local v102 = t11.itemSubType == ASSET_TYPE_NAME_TO_ID_STRING.Face
	local v103 = t11.itemType == ItemTypeEnum.Bundle and BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND[t11.itemSubType] == "Body"

	return Cryo.Dictionary.join(p5, {
		TryOnItems = Cryo.Dictionary.join(p6, {
			[v100] = Cryo.None
		}),
		LastToggledItem = v101,
		LastTryOnClassicHeadShape = if not v102 then nil else Cryo.None,
		BodyColor3s = if not v103 then nil else Cryo.None,
		BodyPartColorRangeIds = if not v103 then nil else Cryo.None
	})
end
local function isAnimationOrEmoteItem(t12: {[any]: any}) -- line: 348
	-- upvalues: ItemTypeEnum (copy), ASSET_TYPE_NAME_TO_ID_STRING (copy), BUNDLE_TYPE_ID_STRINGS (copy)
	if t12.itemType == ItemTypeEnum.Asset and t12.itemSubType == ASSET_TYPE_NAME_TO_ID_STRING.EmoteAnimation then
		return true
	end

	if t12.itemType == ItemTypeEnum.Bundle and t12.itemSubType == tostring(BUNDLE_TYPE_ID_STRINGS.Animations) then
		return true
	end

	return false
end
local function getTryOnItemsContainsRecolorableBody(t13: {[any]: any}) -- line: 362
	-- upvalues: BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND (copy)
	for _, v107 in t13 do
		if v107.itemType == "Bundle" and BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND[v107.itemSubType] == "Body" and v107.isRecolorable then
			return true
		end
	end

	return false
end
local function getTryOnItemsMakeupAndAvatarLookIds(t14: {[any]: any}) -- line: 375
	-- upvalues: Cryo (copy), MAKEUP_LOOK_ASSET_TYPES (copy)
	local None = Cryo.None
	local None2 = Cryo.None

	for _, v112 in t14 do
		if v112.lookId and not MAKEUP_LOOK_ASSET_TYPES[v112.itemSubType] then
			None = v112.lookId
		end

		if v112.lookId and MAKEUP_LOOK_ASSET_TYPES[v112.itemSubType] then
			None2 = v112.lookId
		end
	end

	return None, None2
end
local function reconcileAllTryOnState(t15: {[any]: any}) -- line: 392
	-- upvalues: FFlagAXMISEnableMultiShopping (copy), getTryOnItemsMakeupAndAvatarLookIds (copy), getTryOnItemsContainsRecolorableBody (copy), Cryo (copy), tutils (copy), LOOK_TYPE (copy)
	local TryOnItems = t15.TryOnItems
	local v115 = nil
	local v116 = nil

	if FFlagAXMISEnableMultiShopping then
		v115, v116 = getTryOnItemsMakeupAndAvatarLookIds(TryOnItems)
	end

	local v117 = getTryOnItemsContainsRecolorableBody(TryOnItems)

	if FFlagAXMISEnableMultiShopping then
		v117 = v117 or v115 ~= nil
	end

	local v118 = if not v117 then Cryo.None else t15.BodyColor3s
	local v119 = if not v117 then Cryo.None else t15.BodyPartColorRangeIds
	local v120 = not not v117 and t15.DefaultTryOnBodyColorsToggled
	local v121 = if not FFlagAXMISEnableMultiShopping then nil else tutils.fieldCount(TryOnItems) == 0
	local v122 = if not FFlagAXMISEnableMultiShopping then nil else if not v121 then t15.LookType else Cryo.None
	local v123 = if not FFlagAXMISEnableMultiShopping then nil else if not v121 and v116 then LOOK_TYPE.Makeup else Cryo.None

	return Cryo.Dictionary.join(t15, {
		BodyColor3s = v118,
		BodyPartColorRangeIds = v119,
		DefaultTryOnBodyColorsToggled = v120,
		LookId = if not FFlagAXMISEnableMultiShopping then nil else v115,
		LookType = if not FFlagAXMISEnableMultiShopping then nil else v122,
		MakeupLookId = if not FFlagAXMISEnableMultiShopping then nil else v116,
		MakeupLookType = if not FFlagAXMISEnableMultiShopping then nil else v123,
		ShouldTryOnWithoutEquippedItems = if not FFlagAXMISEnableMultiShopping then nil else not v121 and t15.ShouldTryOnWithoutEquippedItems
	})
end

local v71 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXEnableAccessoryAdjustmentDuringTryOnIXP.EnabledForUser)
local t16 = {
	DefaultTryOnBodyColorsToggled = false,
	LookId = nil,
	LookType = nil,
	MakeupLookId = nil,
	MakeupLookType = nil,
	LastToggledLookType = nil,
	LastTryOnClassicHeadShape = nil,
	TryOnItems = {},
	OutfitIdMap = {},
	AdjustableTryOnIds = if not v71 then nil else {},
	ShouldTryOnWithoutEquippedItems = not FFlagAXMISEnableMultiShopping and nil
}

return Rodux.createReducer(t16, {
	[TryOnColorUpdated.name] = function(t17: {[any]: any}?, p7) -- line: 451
		-- upvalues: t16 (copy)
		local v126 = table.clone(t17 or t16)

		v126.BodyColor3s = p7.colors
		v126.BodyPartColorRangeIds = p7.bodyPartColorRangeIds

		return v126
	end,
	[ToggleTryOn.name] = function(t18: {[any]: any}?, p8) -- line: 458
		-- upvalues: t16 (copy), getTryOnItemReducerKey (copy), FFlagAXMISEnableMultiShopping (copy), reconcileAllTryOnState (copy), removeItem (copy), ReducerUtils (copy), formatItem (copy), getFilteredTryOnItems (copy), ItemTypeEnum (copy), ASSET_TYPE_NAME_TO_ID_STRING (copy), BUNDLE_TYPE_ID_STRINGS (copy), Cryo (copy), getTryOnItemsContainsRecolorableBody (copy), FFlagAXCatalogMakeupSupport (copy), removeMakeupAssetsFromTryOnsIfOverLimit (copy)
		local v129 = t18 or t16
		local v130 = v129.TryOnItems or {}
		local v131 = v129.LookId ~= nil
		local v132 = getTryOnItemReducerKey(p8.itemId, p8.itemType)

		if if not FFlagAXMISEnableMultiShopping then v130[v132] ~= nil and not v131 else v130[v132] ~= nil then
			if FFlagAXMISEnableMultiShopping then
				return reconcileAllTryOnState(removeItem(v129, v130, p8))
			end

			return removeItem(v129, v130, p8)
		end

		if FFlagAXMISEnableMultiShopping and p8.resetTryOnsBeforeToggleOn then
			v130 = {}
		end

		local v133 = ReducerUtils.filterTryOns(v130, p8)
		local v134 = formatItem(p8, false)

		if FFlagAXMISEnableMultiShopping then
			v133 = getFilteredTryOnItems(v130, v134)
		end

		local v135 = nil

		if v134.itemType == ItemTypeEnum.Asset and v134.itemSubType == ASSET_TYPE_NAME_TO_ID_STRING.EmoteAnimation or v134.itemType == ItemTypeEnum.Bundle and v134.itemSubType == tostring(BUNDLE_TYPE_ID_STRINGS.Animations) then
			v135 = v134
		end

		if not FFlagAXMISEnableMultiShopping and v131 then
			return Cryo.Dictionary.join(v129, {
				DefaultTryOnBodyColorsToggled = false,
				TryOnItems = {
					[p8.itemId] = v134
				},
				LastToggledItem = v134,
				LastAnimOrEmoteToggledItem = v135,
				LookId = Cryo.None,
				BodyColor3s = {},
				BodyPartColorRangeIds = Cryo.None
			})
		end

		local v136 = Cryo.Dictionary.join(v133, {
			[v132] = v134
		})
		local v137 = getTryOnItemsContainsRecolorableBody(v136)
		local v138 = if not v137 then Cryo.None else v129.BodyColor3s
		local v139 = if not v137 then Cryo.None else v129.BodyPartColorRangeIds
		local v140 = not not v137 and v129.DefaultTryOnBodyColorsToggled
		local v141 = Cryo.Dictionary.join(v129, {
			TryOnItems = v136,
			LastToggledItem = v134,
			LastAnimOrEmoteToggledItem = v135,
			BodyColor3s = v138,
			BodyPartColorRangeIds = v139,
			DefaultTryOnBodyColorsToggled = v140
		})

		if FFlagAXMISEnableMultiShopping then
			if FFlagAXCatalogMakeupSupport then
				v136 = removeMakeupAssetsFromTryOnsIfOverLimit(v136)
			end

			local v142 = Cryo.Dictionary.join(v141, {
				TryOnItems = v136,
				LastToggledItem = v134,
				LastAnimOrEmoteToggledItem = v135
			})

			return reconcileAllTryOnState(v142)
		end

		return v141
	end,
	[TryOnClassicHeadShape.name] = function(t19: {[any]: any}?, p9) -- line: 557
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t19, {
			LastTryOnClassicHeadShape = if not p9.headShape then Cryo.None else p9.headShape
		})
	end,
	[TryOnLooksOutfit.name] = function(t20: {[any]: any}?, p10) -- line: 563
		-- upvalues: t16 (copy), FFlagAXMISEnableMultiShopping (copy), FFlagAXCatalogMakeupSupport (copy), LOOK_TYPE (copy), MAKEUP_LOOK_ASSET_TYPES (copy), getTryOnItemReducerKey (copy), formatItemFromLookOutfit (copy), formatBundleFromLookOutfit (copy), Cryo (copy)
		local v147 = t20 or t16
		local t21 = {}

		if FFlagAXMISEnableMultiShopping and (FFlagAXCatalogMakeupSupport and p10.lookType == LOOK_TYPE.Makeup) then
			t21 = table.clone(v147.TryOnItems)

			for v149, v150 in t21 do
				if MAKEUP_LOOK_ASSET_TYPES[v150.itemSubType] then
					t21[v149] = nil
				end
			end
		end

		for _, v152 in p10.assetItemIdTypeAndSubtype do
			t21[getTryOnItemReducerKey(v152.itemId, v152.itemType)] = formatItemFromLookOutfit(v152, p10.lookType, if not FFlagAXMISEnableMultiShopping then nil else p10.lookId)
		end

		if p10.bundleItemIdTypeAndSubtype ~= nil then
			for _, v154 in p10.bundleItemIdTypeAndSubtype do
				t21[getTryOnItemReducerKey(v154.itemId, v154.itemType)] = formatBundleFromLookOutfit(v154, if not FFlagAXMISEnableMultiShopping then nil else p10.lookId)
			end
		end

		if FFlagAXMISEnableMultiShopping and FFlagAXCatalogMakeupSupport and p10.lookType == LOOK_TYPE.Makeup then
			return Cryo.Dictionary.join(v147, {
				TryOnItems = t21,
				MakeupLookId = if not p10.lookId then Cryo.None else p10.lookId,
				MakeupLookType = p10.lookType,
				LastToggledLookType = p10.lookType,
				MakeupLookAnalyticsInfo = if not p10.analyticsInfo then Cryo.None else p10.analyticsInfo
			})
		end

		return Cryo.Dictionary.join(v147, {
			TryOnItems = t21,
			LookId = if not p10.lookId then Cryo.None else p10.lookId,
			LookAnalyticsInfo = if not p10.analyticsInfo then Cryo.None else p10.analyticsInfo,
			LookType = p10.lookType,
			MakeupLookId = Cryo.None,
			MakeupLookType = Cryo.None,
			MakeupLookAnalyticsInfo = Cryo.None,
			LastToggledLookType = if not FFlagAXMISEnableMultiShopping then nil else p10.lookType,
			BodyColor3s = if not p10.bodyColor3s then Cryo.None else p10.bodyColor3s,
			BodyPartColorRangeIds = if not p10.bodyPartColorRangeIds then Cryo.None else p10.bodyPartColorRangeIds,
			DefaultTryOnBodyColorsToggled = Cryo.None,
			Scale = if not p10.scale then Cryo.None else p10.scale,
			ShouldTryOnWithoutEquippedItems = if not FFlagAXMISEnableMultiShopping then nil else p10.lookId ~= nil
		})
	end,
	[SetEquippedInTryOnManager.name] = function(t22: {[any]: any}?, p11) -- line: 630
		-- upvalues: t16 (copy), getTryOnItemReducerKey (copy), Cryo (copy)
		local v157 = t22 or t16
		local v158 = v157.TryOnItems or {}
		local v159 = getTryOnItemReducerKey(p11.itemId, p11.itemType)

		if v158[v159] == nil then
			return v157
		end

		return Cryo.Dictionary.join(v157, {
			TryOnItems = Cryo.Dictionary.join(v158, {
				[v159] = Cryo.Dictionary.join(v158[v159], {
					selectedInTryOnManager = p11.selectedInTryOnManager
				})
			})
		})
	end,
	[SetSelectedTimedOption.name] = function(t23: {[any]: any}?, p12) -- line: 648
		-- upvalues: t16 (copy), getTryOnItemReducerKey (copy), Cryo (copy)
		local v162 = t23 or t16
		local v163 = v162.TryOnItems or {}
		local v164 = getTryOnItemReducerKey(p12.itemId, p12.itemType)

		if v163[v164] == nil then
			return v162
		end

		return Cryo.Dictionary.join(v162, {
			TryOnItems = Cryo.Dictionary.join(v163, {
				[v164] = Cryo.Dictionary.join(v163[v164], {
					selectedTimedOptionIndex = p12.selectedTimedOptionIndex
				})
			})
		})
	end,
	[RemoveUnselectedItemsFromTryOn.name] = function(t24: {[any]: any}?, _) -- line: 666
		-- upvalues: t16 (copy), Cryo (copy)
		local v167 = t24 or t16
		local t25 = {}

		for v169, v170 in v167.TryOnItems or {} do
			if v170.selectedInTryOnManager then
				t25[v169] = v170
			end
		end

		return Cryo.Dictionary.join(v167, {
			TryOnItems = t25
		})
	end,
	[RemoveLookFromTryOn.name] = if not FFlagAXMISEnableMultiShopping then nil else function(t26: {[any]: any}?, p14) -- line: 683
		-- upvalues: t16 (copy), FFlagAXCatalogMakeupSupport (copy), Cryo (copy)
		local v173 = t26 or t16
		local t27 = {}

		for v175, v176 in v173.TryOnItems or {} do
			if v176.lookId ~= p14.lookId then
				t27[v175] = v176
			end
		end

		if FFlagAXCatalogMakeupSupport and v173.MakeupLookId == p14.lookId then
			return Cryo.Dictionary.join(v173, {
				TryOnItems = t27,
				MakeupLookId = Cryo.None,
				MakeupLookType = Cryo.None,
				MakeupLookAnalyticsInfo = Cryo.None,
				LastToggledLookType = Cryo.None
			})
		end

		return Cryo.Dictionary.join(v173, {
			ShouldTryOnWithoutEquippedItems = false,
			TryOnItems = t27,
			LookId = Cryo.None,
			LookType = Cryo.None,
			LookAnalyticsInfo = Cryo.None,
			BodyColor3s = Cryo.None,
			BodyPartColorRangeIds = Cryo.None,
			Scale = Cryo.None,
			LastToggledLookType = Cryo.None
		})
	end,
	[RemoveFromTryOn.name] = function(t28: {[any]: any}?, p15) -- line: 717
		-- upvalues: t16 (copy), findItemInTryOnItems (copy), reconcileAllTryOnState (copy), removeItem (copy)
		local v179 = t28 or t16
		local v180 = v179.TryOnItems or {}
		local v181 = findItemInTryOnItems(v180, p15.itemId, p15.itemType)

		if v181 ~= nil then
			return reconcileAllTryOnState(removeItem(v179, v180, v181))
		end

		return v179
	end,
	[RemoveLookItemsFromTryOn.name] = function(t29: {[any]: any}?, p16) -- line: 730
		-- upvalues: t16 (copy), getTryOnItemReducerKey (copy), ItemTypeEnum (copy), Cryo (copy), FFlagAXMISEnableMultiShopping (copy), FFlagAXCatalogMakeupSupport (copy)
		local v184 = t29 or t16

		if p16.lookId == v184.LookId then
			local v185 = v184.TryOnItems or {}

			for _, v187 in p16.assetIds do
				local v188 = getTryOnItemReducerKey(v187, ItemTypeEnum.Asset)

				if v185[v188] ~= nil then
					v185 = Cryo.Dictionary.join(v185, {
						[v188] = Cryo.None
					})
				end
			end

			if p16.bundleIds ~= nil then
				for _, v190 in p16.bundleIds do
					local v191 = getTryOnItemReducerKey(v190, ItemTypeEnum.Bundle)

					if v185[v191] ~= nil then
						v185 = Cryo.Dictionary.join(v185, {
							[v191] = Cryo.None
						})
					end
				end
			end

			v184 = Cryo.Dictionary.join(v184, {
				TryOnItems = v185,
				LookId = Cryo.None,
				LookType = Cryo.None,
				BodyColor3s = Cryo.None,
				BodyPartColorRangeIds = Cryo.None,
				Scale = Cryo.None,
				ShouldTryOnWithoutEquippedItems = not FFlagAXMISEnableMultiShopping and nil
			})
		end

		if FFlagAXMISEnableMultiShopping and FFlagAXCatalogMakeupSupport and p16.lookId == v184.MakeupLookId then
			local v192 = v184.TryOnItems or {}

			for _, v194 in p16.assetIds do
				local v195 = getTryOnItemReducerKey(v194, ItemTypeEnum.Asset)

				if v192[v195] ~= nil then
					v192 = Cryo.Dictionary.join(v192, {
						[v195] = Cryo.None
					})
				end
			end

			if p16.bundleIds ~= nil then
				for _, v197 in p16.bundleIds do
					local v198 = getTryOnItemReducerKey(v197, ItemTypeEnum.Bundle)

					if v192[v198] ~= nil then
						v192 = Cryo.Dictionary.join(v192, {
							[v198] = Cryo.None
						})
					end
				end
			end

			v184 = Cryo.Dictionary.join(v184, {
				TryOnItems = v192,
				MakeupLookId = Cryo.None,
				MakeupLookType = Cryo.None
			})
		end

		return v184
	end,
	[ReceivedBundleInfoForTryOn.name] = function(t30: {[any]: any}?, p17) -- line: 806
		-- upvalues: t16 (copy), getTryOnItemReducerKey (copy), ItemTypeEnum (copy), Cryo (copy)
		local v201 = t30 or t16
		local v202 = v201.TryOnItems or {}
		local v203 = getTryOnItemReducerKey(p17.itemId, ItemTypeEnum.Bundle)

		if v202[v203] then
			local v204 = table.clone(v201.OutfitIdMap or {})

			v204[p17.itemId] = p17.outfitId

			return Cryo.Dictionary.join(v201, {
				TryOnItems = Cryo.Dictionary.join(v202, {
					[v203] = Cryo.Dictionary.join(v202[v203], {
						receivedBundleInfo = true
					})
				}),
				OutfitIdMap = v204
			})
		end

		return v201
	end,
	[ClearTryOns.name] = function(t31: {[any]: any}?, p18) -- line: 835
		-- upvalues: Cryo (copy), t16 (copy), FFlagAXMISEnableMultiShopping (copy), FFlagAXCatalogMakeupSupport (copy)
		if t31 then
			local v207 = not t31.LookId and p18.retainTryOnColor

			return Cryo.Dictionary.join(t16, {
				LastTryOnClassicHeadShape = t31.LastTryOnClassicHeadShape,
				DefaultTryOnBodyColorsToggled = if not v207 then nil else t31.DefaultTryOnBodyColorsToggled,
				BodyColor3s = if not v207 then nil else t31.BodyColor3s,
				BodyPartColorRangeIds = if not v207 then nil else t31.BodyPartColorRangeIds,
				OutfitIdMap = if not t31 then {} else t31.OutfitIdMap,
				ShouldTryOnWithoutEquippedItems = not FFlagAXMISEnableMultiShopping and nil,
				LastToggledLookType = if not FFlagAXMISEnableMultiShopping or not FFlagAXCatalogMakeupSupport then nil else Cryo.None
			})
		end

		return t16
	end,
	[NavigatedToNonTryOnPage.name] = function(t32: {[any]: any}?, _) -- line: 857
		-- upvalues: t16 (copy)
		local v210 = table.clone(t16)

		if t32 and t32.OutfitIdMap then
			v210.OutfitIdMap = t32.OutfitIdMap
		end

		return v210
	end,
	[NavigatedToTryOnPage.name] = function(t33: {[any]: any}?, _) -- line: 865
		-- upvalues: t16 (copy)
		local v213 = table.clone(t16)

		if t33 and t33.OutfitIdMap then
			v213.OutfitIdMap = t33.OutfitIdMap
		end

		return v213
	end,
	[DefaultTryOnBodyColorsToggled.name] = function(t34: {[any]: any}?, p21) -- line: 873
		-- upvalues: t16 (copy)
		local v216 = table.clone(t34 or t16)

		v216.DefaultTryOnBodyColorsToggled = p21.state

		return v216
	end,
	[SetOrderForTryOns.name] = function(t35: {[any]: any}?, p22) -- line: 880
		-- upvalues: t16 (copy), getTryOnItemReducerKey (copy), ItemTypeEnum (copy), Cryo (copy), Constants (copy)
		local itemIdToOrderMap = p22.itemIdToOrderMap
		local v220 = t35 or t16

		for v221, v222 in itemIdToOrderMap do
			local v223 = v220.TryOnItems or {}
			local v224 = getTryOnItemReducerKey(v221, ItemTypeEnum.Asset)

			if v223[v224] and v223[v224].itemType ~= ItemTypeEnum.Bundle then
				v220 = Cryo.Dictionary.join(v220, {
					TryOnItems = Cryo.Dictionary.join(v223, {
						[v224] = Cryo.Dictionary.join(v223[v224], {
							order = v222
						})
					})
				})
			elseif not v223[v224] then
				for v225, v226 in v223 do
					if v226.bundleInfo and v226.bundleInfo[v221] and v226.itemId ~= tostring(Constants.BlockyBundleId) then
						local bundleInfo = v226.bundleInfo
						local v228 = Cryo.Dictionary.join(bundleInfo, {
							[v221] = Cryo.Dictionary.join(bundleInfo[v221], {
								order = v222
							})
						})

						v220 = Cryo.Dictionary.join(t35, {
							TryOnItems = Cryo.Dictionary.join(v223, {
								[v225] = Cryo.Dictionary.join(v223[v225], {
									bundleInfo = v228
								})
							})
						})

						break
					end
				end
			end
		end

		return v220
	end,
	[SetAccessoryAdjustments.name] = function(t36: {[any]: any}?, p23) -- line: 936
		-- upvalues: t16 (copy), Cryo (copy)
		local v231 = t36 or t16
		local v232 = v231.TryOnItems or {}

		for v233, v234 in v232 do
			if v234.itemType == "Asset" then
				if v234.itemId ~= p23.itemId then
					continue
				end

				return Cryo.Dictionary.join(v231, {
					TryOnItems = Cryo.Dictionary.join(v232, {
						[v233] = Cryo.Dictionary.join(v234, {
							position = p23.position,
							rotation = p23.rotation,
							scale = p23.scale
						})
					})
				})
			end

			if v234.itemType == "Bundle" then
				for v235, v236 in v232 do
					if v236.bundleInfo and v236.bundleInfo[p23.itemId] then
						local bundleInfo = v236.bundleInfo
						local v238 = Cryo.Dictionary.join(bundleInfo, {
							[p23.itemId] = Cryo.Dictionary.join(bundleInfo[p23.itemId], {
								position = p23.position,
								rotation = p23.rotation,
								scale = p23.scale
							})
						})

						return Cryo.Dictionary.join(t36, {
							TryOnItems = Cryo.Dictionary.join(v232, {
								[v235] = Cryo.Dictionary.join(v232[v235], {
									bundleInfo = v238
								})
							})
						})
					end
				end
			end
		end

		return v231
	end,
	[AddSelectedBundleInfo.name] = function(t37: {[any]: any}?, p24) -- line: 981
		-- upvalues: t16 (copy), getTryOnItemReducerKey (copy), ItemTypeEnum (copy), Cryo (copy)
		local v241 = t37 or t16
		local v242 = v241.TryOnItems or {}
		local v243 = getTryOnItemReducerKey(p24.bundleId, ItemTypeEnum.Bundle)

		if v242[v243] then
			return Cryo.Dictionary.join(v241, {
				TryOnItems = Cryo.Dictionary.join(v242, {
					[v243] = Cryo.Dictionary.join(v242[v243], {
						bundleInfo = p24.bundleInfo
					})
				})
			})
		end

		return v241
	end,
	[SetOutfitTryOns.name] = function(_: {[any]: any}?, p25) -- line: 1000
		return p25.outfitTryOns
	end,
	[RemoveLook.name] = function(t39: {[any]: any}?, p26) -- line: 1004
		-- upvalues: t16 (copy), FFlagAXMISEnableMultiShopping (copy), FFlagAXCatalogMakeupSupport (copy), Cryo (copy)
		local v248 = t39 or t16

		if p26.lookId == v248.LookId or FFlagAXMISEnableMultiShopping and FFlagAXCatalogMakeupSupport and p26.lookId == v248.MakeupLookId then
			local t40 = {}

			if FFlagAXMISEnableMultiShopping then
				for v250, v251 in v248.TryOnItems or {} do
					if v251.lookId ~= p26.lookId then
						t40[v250] = v251
					end
				end
			end

			if FFlagAXMISEnableMultiShopping and FFlagAXCatalogMakeupSupport then
				if p26.lookId == v248.LookId then
					v248 = Cryo.Dictionary.join(v248, {
						ShouldTryOnWithoutEquippedItems = false,
						TryOnItems = t40,
						LookId = Cryo.None,
						LookType = Cryo.None,
						BodyColor3s = Cryo.None,
						BodyPartColorRangeIds = Cryo.None,
						Scale = Cryo.None,
						LastToggledLookType = Cryo.None
					})
				end

				if p26.lookId == v248.MakeupLookId then
					return (Cryo.Dictionary.join(v248, {
						TryOnItems = t40,
						MakeupLookId = Cryo.None,
						MakeupLookType = Cryo.None,
						LastToggledLookType = Cryo.None
					}))
				end
			else
				v248 = Cryo.Dictionary.join(v248, {
					TryOnItems = t40,
					LookId = Cryo.None,
					LookType = Cryo.None,
					BodyColor3s = Cryo.None,
					BodyPartColorRangeIds = Cryo.None,
					Scale = Cryo.None,
					ShouldTryOnWithoutEquippedItems = not FFlagAXMISEnableMultiShopping and nil
				})
			end
		end

		return v248
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(p27, p28) -- line: 1064
		-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy)
		if FFlagAXRootSlotBasedEditorFlag and (p28.tryOn and p28.tryOn.OutfitTryOn) then
			return table.clone(p28.tryOn.OutfitTryOn)
		end

		return p27
	end,
	[SetAdjustableTryOnIds.name] = if not v71 then nil else function(t41: {[any]: any}?, p29) -- line: 1075
		-- upvalues: t16 (copy)
		local v256 = table.clone(t41 or t16)

		v256.AdjustableTryOnIds = p29.adjustableTryOnIds

		return v256
	end,
	[SetLastToggledLookType.name] = if not FFlagAXMISEnableMultiShopping then nil else function(t42: {[any]: any}?, p30) -- line: 1082
		-- upvalues: t16 (copy), Cryo (copy)
		local v259 = t42 or t16

		return Cryo.Dictionary.join(v259, {
			LastToggledLookType = p30.lastToggledLookType
		})
	end
})
