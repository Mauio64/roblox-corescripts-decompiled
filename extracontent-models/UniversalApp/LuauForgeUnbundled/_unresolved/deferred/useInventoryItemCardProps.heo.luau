local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/bundled/fCn")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module3 = require("@luauforge/bundled/dPt")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local inventoryItemType = module.Enums.InventoryItemType
local inventoryItemAvailability = module.Enums.InventoryItemAvailability

local catalogItemCardStatusIconTypeEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module5 = require("@luauforge/bundled/dPN")
local module6 = require("@luauforge/bundled/fCH")
local module7 = require("@luauforge/bundled/gJM")
local module8 = require("@luauforge/bundled/eie")
local module9 = require("@luauforge/bundled/gJz")
local module10 = require("@luauforge/bundled/fDf")
local module11 = require("@luauforge/deferred/haF")
local module12 = require("@luauforge/deferred/gLj")
local module13 = require("@luauforge/bundled/fDz")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module14 = require("@luauforge/bundled/dRS")
local module15 = require("@luauforge/bundled/dVl")
local module16 = require("@luauforge/bundled/fCe")

local impressionsUtil = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").ImpressionsReporter.ImpressionsUtil
local module17 = require("@luauforge/bundled/gSD")
local fullView = AvatarExperienceCommon.Enums.FullView
local itemTypeEnum = module3.Enums.ItemTypeEnum
local getRemainingTimeFromExpiration = module.Utils.getRemainingTimeFromExpiration
local module18 = require("@luauforge/bundled/dKU")
require("@luauforge/bundled/dPs")
local module19 = require("@luauforge/bundled/gJS")

local organicEventImpressionsSchema = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").ImpressionsReporter.OrganicEventImpressionsSchema

local sendUnifiedEventForDeferredAction = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendUnifiedEventForDeferredAction
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local getUnifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Utils.getUnifiedLoggingSurface
local module20 = require("@luauforge/bundled/dXh")
local module21 = require("@luauforge/bundled/egx")

local useSlotBasedEditorContext = module.Context.useSlotBasedEditorContext
local slotType = module.Enums.SlotType

local defineFastFlag = game:DefineFastFlag("AXR15PromptBeforeApplyingAvatar", false)

local fFlagAXModeratedItemsFlow = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXModeratedItemsFlow
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXBlockMakeupEquipR6 = AvatarExperienceFlags.FFlagAXBlockMakeupEquipR6
local fFlagAXEditorEnableThumbnailLatencyStore = AvatarExperienceFlags.FFlagAXEditorEnableThumbnailLatencyStore
local fFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local fFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration
local fFlagAXBackgroundGeneration = AvatarExperienceFlags.FFlagAXBackgroundGeneration
local fFlagAXBackgroundGenerationAnalytics = AvatarExperienceFlags.FFlagAXBackgroundGenerationAnalytics
local fFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards
local fFlagAXPlusExclusiveBackgroundTryOn = AvatarExperienceFlags.FFlagAXPlusExclusiveBackgroundTryOn
local fFlagAXBackgroundsEndTryOnOnSelect = AvatarExperienceFlags.FFlagAXBackgroundsEndTryOnOnSelect
local fFlagAXBackgroundsEquipTryOnCounters = AvatarExperienceFlags.FFlagAXBackgroundsEquipTryOnCounters
local fFlagAXFixClickItemDetailsSurfaceLogging = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXFixClickItemDetailsSurfaceLogging
local fFlagAXOutfitPageRevamp = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXOutfitPageRevamp
local fFlagAXBlockUnavailableMakeupLookSelection = AvatarExperienceFlags.FFlagAXBlockUnavailableMakeupLookSelection
local module22 = require("@luauforge/deferred/hbf")
local fFlagAXMemoizeEquippedLayeredMakeupAssets = AvatarExperienceFlags.FFlagAXMemoizeEquippedLayeredMakeupAssets

local applyProfileConfiguration = module18.Actions.ApplyProfileConfiguration
local removeFromTryOn = module18.Actions.RemoveFromTryOn
local selectActiveBackground = AvatarExperienceCommon.Backgrounds.selectActiveBackground
local selectTryOnBackgroundId = AvatarExperienceCommon.Backgrounds.selectTryOnBackgroundId
local NO_BACKGROUND_ASSET_ID = AvatarExperienceCommon.Backgrounds.NO_BACKGROUND_ASSET_ID

local reportBackgroundUserActionCounter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").reportBackgroundUserActionCounter

require("@luauforge/deferred/hen")
local module23 = require("@luauforge/deferred/hep")
require("@luauforge/deferred/heh")

local useMakeupFtux = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Hooks.useMakeupFtux
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local MAX_MAKEUP_LAYERS = AvatarExperienceCommon.Constants.MAX_MAKEUP_LAYERS
local selectEquippedLayeredMakeupAssets = AvatarExperienceCommon.State.Selectors.selectEquippedLayeredMakeupAssets
local selectEquippedAssets = AvatarExperienceCommon.State.Selectors.selectEquippedAssets
local getEquippedLayeredMakeupAssets = AvatarExperienceCommon.Utils.getEquippedLayeredMakeupAssets

local function selectIsR6(p2): boolean
	return p2.AvatarExperience.AvatarEditor.Character.AvatarType == module5.AvatarType.R6
end

local function useBackgroundTileState(itemId, assetType, isSelected)
	local v5 = fFlagAXBackgroundsCustomizeHydration
		and assetType == module5.AssetTypeIdStrings.AvatarBackground
	local v6 = React.useCallback(function(p2)
		if v5 then
			return (selectActiveBackground(p2))
		end

		return nil
	end, { v5 })

	local v7 = if fFlagAXBackgroundsCustomizeHydration then useSelector(v6) else nil
	local v8

	if fFlagAXBackgroundsEndTryOnOnSelect or fFlagAXPlusExclusiveBackgroundTryOn then
		v8 = useSelector((React.useCallback(function(p2)
			if v5 then
				return (selectTryOnBackgroundId(p2))
			end

			return nil
		end, { v5 })))
	end

	local v9 = if v5 then not (v7 == nil) and tonumber(itemId) == v7 else v5

	if v5 then
		isSelected = v9
	end

	return v5, v9, isSelected, v8
end

local function dispatchBackgroundSelection(callback, p2, itemId, p3)
	local v5 = if p2 then NO_BACKGROUND_ASSET_ID else tonumber(itemId)

	if fFlagAXBackgroundsEndTryOnOnSelect and p3 ~= nil then
		callback(removeFromTryOn(tostring(p3), itemTypeEnum.Asset))
	end

	callback(applyProfileConfiguration({ BackgroundAssetId = v5 }))
end

local function isThisBackgroundTryOnPreview(p2, p3)
	local v5 = fFlagAXPlusExclusiveBackgroundTryOn

	if v5 then
		v5 = not (p3 == nil) and tonumber(p2) == p3
	end

	return v5
end

local function isBackgroundsPlusUpsellTarget(p2, p3, p4)
	local v5 = fFlagAXBackgroundGenerationAnalytics and fFlagAXBackgroundGeneration

	if v5 then
		if p2 == nil or p2.isPlusExclusive ~= true or p2.hasActiveSubscription ~= false then
			v5 = false
		else
			v5 = not p3 or p4
		end
	end

	return v5
end

local function isUnavailableMakeupLookSelectionBlocked(p2, p3, p4)
	local v5 = fFlagAXBlockUnavailableMakeupLookSelection

	if v5 then
		if p2 == inventoryItemType.Outfit and p3 ~= nil and p3.outfitType == module5.OutfitTypes.Makeup then
			v5 = module16.isModerationPendingOrRejected(p4)
		else
			v5 = false
		end
	end

	return v5
end

local function shouldEnableItemDetailsButton(p2, p3, p4)
	local v5

	if p3 then
		v5 = not (p3.creatingUniverseId == nil) and string.len(p3.creatingUniverseId) > 0
	else
		v5 = p3
	end

	local v6 = fFlagAXBlockUnavailableMakeupLookSelection

	if v6 then
		if p2 == inventoryItemType.Outfit and p3 ~= nil and p3.outfitType == module5.OutfitTypes.Makeup then
			v6 = module16.isModerationPendingOrRejected(p4)
		else
			v6 = false
		end
	end

	return not v6
		and (p2 == inventoryItemType.Asset or (v5 or fFlagAXOutfitPageRevamp and p2 == inventoryItemType.Outfit))
end

local function useInventoryItemCardProps(data)
	local v5 = module8(module9)
	local v6 = module8(module10)

	local v7 = if fFlagAXPlusExclusiveBackgroundTryOn then module8(module21) else nil

	local v8 = useDispatch()
	local v9 = useNavigation()
	local v10 = useAvatarRoute()
	local ref = React.useRef(nil)
	local name = v10 and v10.opaque and v10.opaque.name

	local inventoryItemType2 = data.inventoryItemType

	local v12 = useSelector((React.useCallback(function(p2)
		if inventoryItemType2 == inventoryItemType.Asset then
			return (itemData(p2.AvatarExperience.Common, data.itemId, inventoryItemType2))
		end

		return nil
	end, { inventoryItemType2, data.itemId })))

	local v13 = useMakeupFtux()
	local v14

	if fFlagAXMemoizeEquippedLayeredMakeupAssets then
		v14 = useSelector(selectEquippedAssets)
	else
		v14 = useSelector(selectEquippedLayeredMakeupAssets)
	end

	local v15

	if fFlagAXMemoizeEquippedLayeredMakeupAssets then
		v15 = React.useMemo(function()
			return getEquippedLayeredMakeupAssets(v14)
		end, { v14 })
	else
		v15 = v14
	end

	local v16

	if fFlagAXInventoryDurablesSupport then
		local v17 = if v12 then getRemainingTimeFromExpiration(v12.expirationTime) else nil

		local v18 = useLocalization({
			days = v17 and v17.unit == "days" and {
				"Feature.Durables.TimeRemaining.Days",
				number = v17.value
			} or nil,
			hours = v17 and v17.unit == "hours" and {
				"Feature.Durables.TimeRemaining.Hours",
				number = v17.value
			} or nil,
			minutes = v17 and v17.unit == "minutes" and {
				"Feature.Durables.TimeRemaining.Minutes",
				number = v17.value
			} or nil
		})

		if v17 then
			v16 = v18[v17.unit]
		end
	end

	local v18 = useSelector((React.useCallback(function(p2)
		if inventoryItemType2 == inventoryItemType.Outfit then
			return p2.AvatarExperience.AvatarEditor.OutfitInfos[data.itemId]
		end

		return nil
	end, { inventoryItemType2, data.itemId })))

	local v19 = useSelector(selectIsR6)
	local v20 = useSelector(module19)

	local v21 = if v12 then v12.name elseif v18 then v18.name else nil
	local assetType = if v12 then v12.assetType else nil

	local v22 = data.isSelected
	local v23, v24, v25

	if fFlagAXBackgroundsCustomizeHydration then
		v23, v24, v22, v25 = useBackgroundTileState(data.itemId, assetType, data.isSelected)
	else
		v25 = nil
		v23 = false
		v24 = false
	end

	local itemId = data.itemId
	local v26 = v25
	local v27 = fFlagAXPlusExclusiveBackgroundTryOn

	if v27 then
		v27 = not (v26 == nil) and tonumber(itemId) == v26
	end

	local plus = data.plus
	local v28 = v22
	local v29 = fFlagAXBackgroundGenerationAnalytics and fFlagAXBackgroundGeneration

	if v29 then
		if plus == nil or plus.isPlusExclusive ~= true or plus.hasActiveSubscription ~= false then
			v29 = false
		else
			v29 = not v28 or v27
		end
	end

	if v21 == nil then
		v21 = (if assetType then module5.AssetTypeIdStringToName[assetType] else nil) or ""
	end

	local inventoryType = if fFlagAXModeratedItemsFlow and v18 then v18.inventoryType else nil
	local v30, v31

	if module22 and v18 then
		v30, v31 = module23(v18)
	end

	local v32 = if v12 then v12.moderationStatus else nil
	local v33

	if v12 then
		v33 = not (v12.creatingUniverseId == nil) and string.len(v12.creatingUniverseId) > 0
	else
		v33 = v12
	end

	if not v33 and data.availabilityStatus ~= nil then
		v32 = module16.getModerationStatusFromAvailabilityStatus(data.availabilityStatus)
	end

	local updateCounter = if v12 then v12.updateCounter else nil

	local v34 = React.useCallback(function(p2, p3, p4)
		v8(module11(p2, p3, p4))
	end, { v8 })
	local v35 = useSlotBasedEditorContext()

	local plus2 = if fFlagAXBackgroundGenerationAnalytics then data.plus else nil
	local v36

	if fFlagAXPlusExclusiveBackgroundTryOn then
		v36 = React.useCallback(function(p2, callback, p3)
			callback(p2, function()
				if fFlagAXBackgroundsEquipTryOnCounters then
					reportBackgroundUserActionCounter.report("Equip")
				end

				v8(applyProfileConfiguration({ BackgroundAssetId = tonumber(p2) }))

				if fFlagAXBackgroundGenerationAnalytics and plus2 and plus2.onSelectionChanged then
					plus2.onSelectionChanged(p2, true, true)
				end
			end, function()
				if fFlagAXBackgroundsEquipTryOnCounters then
					reportBackgroundUserActionCounter.report("RemoveTryOn")
				end

				v8(removeFromTryOn(p2, itemTypeEnum.Asset))
			end)

			if p3 then
				return
			end

			if fFlagAXBackgroundsEquipTryOnCounters then
				reportBackgroundUserActionCounter.report("TryOn")
			end

			v8(module13(v7, v6, itemTypeEnum.Asset, assetType, p2, true, v10, v9))
		end, { v8, v7, v6, assetType, v10, v9, plus2 })
	else
		v36 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		if fFlagAXBackgroundGenerationAnalytics and v29 and data.itemId and plus2 and plus2.onActivated then
			if fFlagAXPlusExclusiveBackgroundTryOn and v36 then
				v36(data.itemId, plus2.onActivated, v27)
			else
				plus2.onActivated(data.itemId)
			end
		elseif
			fFlagAXBackgroundGenerationAnalytics
			or not fFlagAXBackgroundGeneration
			or not data.onPlusExclusiveActivated
			or v22 and not v27
			or fFlagAXPlusExclusiveBackgroundTryOn and not data.itemId
		then
			if data.itemId and assetType then
				if v23 then
					if fFlagAXBackgroundsEquipTryOnCounters then
						reportBackgroundUserActionCounter.report(v24 and "Unequip" or "Equip")
					end

					dispatchBackgroundSelection(v8, v24, data.itemId, v25)

					if
						fFlagAXBackgroundGenerationAnalytics
						and plus2
						and plus2.isPlusExclusive
						and plus2.onSelectionChanged
					then
						plus2.onSelectionChanged(data.itemId, not v24, plus2.hasActiveSubscription == true)
					end
				else
					local v37 = if data.isSelected then v5.unequipAsset else v5.equipAsset

					local layerIndex = nil
					local v38 = nil
					local v39

					if v35 then
						local slotIndex = v35.signalStore.getSlotIndex()

						v39 = v35.signalStore.getSlots()[slotIndex]

						if not data.isSelected and v39 and v39.slotType == slotType.LayeredSlot then
							layerIndex = v39.layerIndex
							v38 = {}

							for k, assetType2 in v39.assetTypes do
								table.insert(v38, (tostring(assetType2.Value)))
							end
						end
					end

					v34(v37, data.itemId, assetType)
					v8(module6(assetType, data.itemId, v9, nil, layerIndex, nil, v38))

					v8(module17(v5, name, fullView.None))

					if data.isSelected and v39 and v39.slotType ~= slotType.LayeredSlot then
						v8(module14())
					end
				end
			end
		elseif fFlagAXPlusExclusiveBackgroundTryOn and v36 then
			v36(data.itemId, data.onPlusExclusiveActivated, v27)
		else
			data.onPlusExclusiveActivated()
		end
	end

	local v37

	if fFlagAXBackgroundsCustomizeHydration then
		v37 = {
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil
		}
		local itemId2 = data.itemId

		local isSelected = data.isSelected
		local v40 = if fFlagAXBackgroundGenerationAnalytics then v29 else nil
		local v41 = if fFlagAXBackgroundGenerationAnalytics then plus2 else data.onPlusExclusiveActivated

		v37[1], v37[2], v37[3], v37[4], v37[5], v37[6], v37[7], v37[8], v37[9], v37[10], v37[11], v37[12], v37[13], v37[14], v37[15] = itemId2, assetType, isSelected, v5, v34, v8, v9, name, v35, v23, v24, v40, v41, if fFlagAXPlusExclusiveBackgroundTryOn then v36 else nil, (fFlagAXBackgroundsEndTryOnOnSelect or fFlagAXPlusExclusiveBackgroundTryOn) and (v25 or 0) or nil
	else
		v37 = {
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil
		}
		local itemId2 = data.itemId

		local isSelected = data.isSelected
		local v38 = if fFlagAXBackgroundGenerationAnalytics then v29 else nil
		local v39 = if fFlagAXBackgroundGenerationAnalytics then plus2 else data.onPlusExclusiveActivated
		v37[1], v37[2], v37[3], v37[4], v37[5], v37[6], v37[7], v37[8], v37[9], v37[10], v37[11], v37[12] = itemId2, assetType, isSelected, v5, v34, v8, v9, name, v35, v38, v39, if fFlagAXPlusExclusiveBackgroundTryOn then v36 else nil
	end

	local v38 = useCallback(fn, v37)

	local v39 = React.useCallback(function()
		if v18 then
			local v40 = {
				outfitInfo = v18,
				analytics = v5,
				navigation = v9,
				isSelected = data.isSelected
			}

			v8(module17(v5, name, fullView.None))
			v8(module7(v40))
		end
	end, { v18, assetType, v5, v9, data.isSelected, v8, name })

	local v40 = React.useCallback(function(): boolean
		if not data.itemId or not v19 or data.isSelected then
			return false
		end

		local v41 = assetType == module5.AssetTypeIdStrings.HairAccessory
		local v42 = v18 and v18.outfitType == module5.OutfitTypes.Shoes
		local v43 = assetType and module5.LayeredAssetTypes[assetType] ~= nil
		local v44

		if fFlagAXBlockMakeupEquipR6 then
			v44 = assetType and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[assetType]
		end

		local v45

		if defineFastFlag then
			v45 = v18

			if v45 then
				v45 = v18.outfitType == module5.OutfitTypes.Avatar
					and v18.avatarType == module5.AvatarType.R15
			end
		else
			v45 = nil
		end

		if v43 and not v41 or v42 or v45 or v44 then
			v8(navigateWithLock(function()
				local v47 = if v42 or v45 then v39 else v38
				v9.navigate(avatarScreen.R15UpgradePrompt, {
					bodyTextKey = "Feature.Avatar.Label.LayeredClothingR15Warning",
					onSwitchSelected = v47
				})
			end))
			return true
		end

		local v46 = assetType == module5.AssetTypeIdStrings.EmoteAnimation
		local animationAssetType = module16.isAnimationAssetType(assetType)

		if v46 or animationAssetType then
			local v47 = v46 and "Feature.Avatar.Message.R15EmotesPrompt"
				or "Feature.Avatar.Message.R15AnimationsPrompt"
			v8(navigateWithLock(function()
				v9.navigate(avatarScreen.R15UpgradePrompt, { bodyTextKey = v47 })
			end))
			return false
		end

		return false
	end, {
		data.itemId,
		assetType,
		v18,
		v19,
		data.isSelected,
		v9,
		v38,
		v39,
		v8
	})

	local v41 = React.useCallback(function(): boolean
		if not v35 then
			return false
		end

		local slots = v35.signalStore.getSlots()
		local slotIndex = v35.signalStore.getSlotIndex()
		local v42

		if inventoryItemType2 == inventoryItemType.Asset then
			v42 = assetType and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[assetType]
		else
			v42 = false
		end

		local v43 = slotIndex
			and slots
			and slots[slotIndex]
			and slots[slotIndex].slotType == slotType.LayeredSlot
		local v44 = v15 and #v15 == MAX_MAKEUP_LAYERS

		if
			v13
			and v13.shouldShowMakeupMax6LayersPrompt()
			and not data.isSelected
			and v42
			and slotIndex
			and not v43
			and v44
		then
			v9.navigate(avatarScreen.MakeupMax6LayersPrompt, {
				onConfirm = function(p2)
					if p2 then
						v13.hideMakeupMax6LayersPrompt()
					end

					v38()
				end
			})

			v13.incrementSeenMakeupMax6LayersPrompt()

			return true
		end

		return false
	end, { v13, assetType, data.isSelected, v15, v35, v9, v38, inventoryItemType2 })

	local v42 = React.useCallback(function()
		if v40() or v41() then
			return
		end

		if inventoryItemType2 == inventoryItemType.Asset and data.itemId then
			v38()
		elseif inventoryItemType2 == inventoryItemType.Outfit and v18 then
			v39()
		end
	end, { inventoryItemType2, data.itemId, v38, v18, v39, v41 })

	local v43 = React.useCallback(function(messageType)
		local v44 = if assetType then module5.AssetTypeIdStringToName[assetType] else inventoryType
		local v45

		if fFlagAXModeratedItemsFlow then
			v45 = not assetType and "Feature.Catalog.Label.Bundle" or module5.AssetTypeLocalized[assetType]
		end

		local navigate = v9.navigate
		local itemsUnavailablePrompt = avatarScreen.ItemsUnavailablePrompt

		if not fFlagAXModeratedItemsFlow then
			v44 = inventoryItemType2
		end

		navigate(itemsUnavailablePrompt, {
			items = {
				{ category = v44, categoryLoc = v45, itemName = v21 }
			},
			messageType = messageType
		})
	end, { v9, v32, v21, assetType, inventoryType })
	local v44

	if module16.isModerationPendingOrRejected(v32) then
		local v45

		if v32 == Enum.ModerationStatus.NotReviewed then
			v45 = catalogItemCardStatusIconTypeEnum.PendingModeration
		else
			v45 = catalogItemCardStatusIconTypeEnum.Moderated
		end

		v42 = function()
			local messageTypeFromModerationStatus = module16.getMessageTypeFromModerationStatus(v32)

			if not messageTypeFromModerationStatus then
				error("ItemsUnavailablePrompt prop messageType cannot be nil")
			end

			v43(messageTypeFromModerationStatus)
		end

		v44 = { type = "placeholder", iconType = v45 }
	end

	if fFlagAXModeratedItemsFlow and data.availabilityStatus == inventoryItemAvailability.Unavailable then
		v44 = {
			type = "placeholder",
			iconType = not fFlagAXModeratedItemIconUpdates and "Error" or catalogItemCardStatusIconTypeEnum.Unavailable
		}

		v42 = function()
			v43("UnavailableItems")
		end
	end

	local v45 = v32
	local v46

	if v18 then
		v46 = not (v18.creatingUniverseId == nil) and string.len(v18.creatingUniverseId) > 0
	else
		v46 = v18
	end

	local v47 = fFlagAXBlockUnavailableMakeupLookSelection

	if v47 then
		if
			inventoryItemType2 == inventoryItemType.Outfit
			and v18 ~= nil
			and v18.outfitType == module5.OutfitTypes.Makeup
		then
			v47 = module16.isModerationPendingOrRejected(v45)
		else
			v47 = false
		end
	end

	local v48 = not v47
		and (inventoryItemType2 == inventoryItemType.Asset or (v46 or fFlagAXOutfitPageRevamp and inventoryItemType2 == inventoryItemType.Outfit))

	local v49 = React.useCallback(function()
		if inventoryItemType2 == inventoryItemType.Outfit then
			local v50 = {
				outfitId = data.itemId,
				ZIndex = 2,
				showFullWithNoPeekView = not v20,
				renderBottomBar = false,
				NextSelectionLeft = 0
			}

			local v51 = if v20 then data.resultsListRef else nil
			v50.NextSelectionLeft = v51

			v8(navigateWithLock(function()
				module20.closeFiltersAndItemDetails(v9)

				module20.closeTryOnManager(v9)
				v9.navigate(avatarScreen.OutfitDetails, v50)
			end))
		elseif inventoryItemType2 == inventoryItemType.Asset and data.itemId then
			if fFlagAXFixClickItemDetailsSurfaceLogging then
				sendUnifiedEventForDeferredAction({
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
					elementName = "CLICK_ITEM_DETAILS",
					itemId = data.itemId,
					itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET,
					surface = getUnifiedLoggingSurface(v10)
				})
			end

			local v50 = {
				itemId = data.itemId,
				itemType = module5.ItemType.Asset,
				itemSubType = module15.GetItemSubType(inventoryItemType2, v12),
				priceInRobux = 0,
				catalogAnalytics = 0,
				avatarRoute = 0,
				navigation = 0,
				itemDetailsPeekViewRefs = 0,
				resultsListRef = 0,
				showFullWithNoPeekView = true,
				closePreviousItemDetails = true
			}
			local v51 = if v12 then v12.priceInRobux else nil
			v50.priceInRobux = v51
			v50.catalogAnalytics = v6
			v50.avatarRoute = v10
			v50.navigation = v9
			v50.itemDetailsPeekViewRefs = data.itemDetailsPeekViewRefs
			v50.resultsListRef = data.resultsListRef

			v8(module12(v50))
		end
	end, {
		inventoryItemType2,
		data.itemId,
		v20,
		v12,
		v6,
		v10,
		v9,
		data.itemDetailsPeekViewRefs,
		data.resultsListRef,
		v8
	})

	local v50 = {
		itemId = data.itemId,
		inventoryItemType = inventoryItemType2,
		itemName = v21 or "",
		isSelected = v22,
		isPlusUpsellTarget = if fFlagAXBackgroundGenerationAnalytics then v29 else nil,
		thumbnailRef = ref,
		onActivated = v42,
		onDetailsButtonActivated = 0,
		impressionsTag = 0,
		gridInformation = 0,
		assetType = 0,
		bundleType = 0,
		organicLookType = 0,
		unifiedCategoryFields = 0,
		outfitType = 0,
		hideName = 0,
		availabilityStatus = 0,
		moderationStatus = 0,
		updateCounter = 0,
		itemStatus = 0,
		itemLicensingInfo = 0,
		expirationTime = 0,
		onThumbnailLoaded = 0
	}

	if not v48 then
		v49 = nil
	end

	v50.onDetailsButtonActivated = v49
	v50.impressionsTag = data.impressionsTag
	v50.gridInformation = data.gridInformation
	local v52 = if assetType then tonumber(assetType) else nil
	v50.assetType = v52

	if not module22 then
		v30 = nil
	end

	v50.bundleType = v30

	if not module22 then
		v31 = nil
	end

	v50.organicLookType = v31
	local v53 = if module22 then data.unifiedCategoryFields else nil
	v50.unifiedCategoryFields = v53
	v50.outfitType = if fFlagAXModeratedItemsFlow then inventoryType else nil
	v50.hideName = data.hideName or false
	v50.availabilityStatus = data.availabilityStatus
	v50.moderationStatus = v32
	v50.updateCounter = updateCounter
	v50.itemStatus = v44

	local v55 = if fFlagAXMarketplaceLicensingItemCards and v12 then v12.itemLicensingInfo else nil
	v50.itemLicensingInfo = v55

	if not fFlagAXInventoryDurablesSupport then
		v16 = nil
	end

	v50.expirationTime = v16
	local v56 = if fFlagAXEditorEnableThumbnailLatencyStore then data.onThumbnailLoaded else nil
	v50.onThumbnailLoaded = v56

	React.useEffect(function()
		if ref.current then
			local joined = Cryo.Dictionary.join(v50, {
				itemType = v50.inventoryItemType == inventoryItemType.Asset and "Asset" or v50.inventoryItemType == inventoryItemType.Outfit and "Bundle" or nil
			})

			ref.current:SetAttribute(joined.impressionsTag, joined.itemId)
			local v57 = organicEventImpressionsSchema[data.impressionsSchema]
			impressionsUtil.writeItemAttributes(v57, ref.current, joined)
		end
	end, { v50, data.impressionsSchema })

	return v50
end

return useInventoryItemCardProps
