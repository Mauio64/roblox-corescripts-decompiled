local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/bundled/fuM")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module3 = require("@luauforge/bundled/dMd")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local inventoryItemType = module.Enums.InventoryItemType
local inventoryItemAvailability = module.Enums.InventoryItemAvailability

local catalogItemCardStatusIconTypeEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module5 = require("@luauforge/bundled/dMx")
local module6 = require("@luauforge/bundled/fvg")
local module7 = require("@luauforge/bundled/gfg")
local module8 = require("@luauforge/bundled/eeH")
local module9 = require("@luauforge/bundled/geT")
local module10 = require("@luauforge/bundled/fvF")
local module11 = require("@luauforge/deferred/gOC")
local module12 = require("@luauforge/deferred/ggD")
local module13 = require("@luauforge/bundled/fvZ")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module14 = require("@luauforge/bundled/dOC")
local module15 = require("@luauforge/bundled/dRQ")
local module16 = require("@luauforge/bundled/fuD")

local impressionsUtil = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").ImpressionsReporter.ImpressionsUtil
local module17 = require("@luauforge/bundled/gnZ")
local fullView = AvatarExperienceCommon.Enums.FullView
local itemTypeEnum = module3.Enums.ItemTypeEnum
local getRemainingTimeFromExpiration = module.Utils.getRemainingTimeFromExpiration
local module18 = require("@luauforge/bundled/dHL")
require("@luauforge/bundled/dMc")
local module19 = require("@luauforge/bundled/gfm")

local organicEventImpressionsSchema = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").ImpressionsReporter.OrganicEventImpressionsSchema

local sendUnifiedEventForDeferredAction = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendUnifiedEventForDeferredAction
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local getUnifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Utils.getUnifiedLoggingSurface
local module20 = require("@luauforge/bundled/dTM")
local module21 = require("@luauforge/bundled/eda")

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
local module22 = require("@luauforge/deferred/gPc")
local fFlagAXMemoizeEquippedLayeredMakeupAssets = AvatarExperienceFlags.FFlagAXMemoizeEquippedLayeredMakeupAssets

local applyProfileConfiguration = module18.Actions.ApplyProfileConfiguration
local removeFromTryOn = module18.Actions.RemoveFromTryOn
local selectActiveBackground = AvatarExperienceCommon.Backgrounds.selectActiveBackground
local selectTryOnBackgroundId = AvatarExperienceCommon.Backgrounds.selectTryOnBackgroundId
local NO_BACKGROUND_ASSET_ID = AvatarExperienceCommon.Backgrounds.NO_BACKGROUND_ASSET_ID

local reportBackgroundUserActionCounter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").reportBackgroundUserActionCounter

require("@luauforge/deferred/gSb")
local module23 = require("@luauforge/deferred/gSd")
require("@luauforge/deferred/gRV")

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

	local v11 = useSelector((React.useCallback(function(p2)
		if inventoryItemType2 == inventoryItemType.Asset then
			return (itemData(p2.AvatarExperience.Common, data.itemId, inventoryItemType2))
		end

		return nil
	end, { inventoryItemType2, data.itemId })))

	local v12 = useMakeupFtux()
	local v13

	if fFlagAXMemoizeEquippedLayeredMakeupAssets then
		v13 = useSelector(selectEquippedAssets)
	else
		v13 = useSelector(selectEquippedLayeredMakeupAssets)
	end

	local v14

	if fFlagAXMemoizeEquippedLayeredMakeupAssets then
		v14 = React.useMemo(function()
			return getEquippedLayeredMakeupAssets(v13)
		end, { v13 })
	else
		v14 = v13
	end

	local v15

	if fFlagAXInventoryDurablesSupport then
		local v16 = if v11 then getRemainingTimeFromExpiration(v11.expirationTime) else nil

		local v17 = useLocalization({
			days = v16 and v16.unit == "days" and {
				"Feature.Durables.TimeRemaining.Days",
				number = v16.value
			} or nil,
			hours = v16 and v16.unit == "hours" and {
				"Feature.Durables.TimeRemaining.Hours",
				number = v16.value
			} or nil,
			minutes = v16 and v16.unit == "minutes" and {
				"Feature.Durables.TimeRemaining.Minutes",
				number = v16.value
			} or nil
		})

		if v16 then
			v15 = v17[v16.unit]
		end
	end

	local v16 = useSelector((React.useCallback(function(p2)
		if inventoryItemType2 == inventoryItemType.Outfit then
			return p2.AvatarExperience.AvatarEditor.OutfitInfos[data.itemId]
		end

		return nil
	end, { inventoryItemType2, data.itemId })))

	local v17 = useSelector(selectIsR6)
	local v18 = useSelector(module19)

	local v19 = if v11 then v11.name elseif v16 then v16.name else nil
	local assetType = if v11 then v11.assetType else nil

	local v20 = data.isSelected
	local v21, v22, v23

	if fFlagAXBackgroundsCustomizeHydration then
		v21, v22, v20, v23 = useBackgroundTileState(data.itemId, assetType, data.isSelected)
	else
		v23 = nil
		v21 = false
		v22 = false
	end

	local itemId = data.itemId
	local v24 = fFlagAXPlusExclusiveBackgroundTryOn

	if v24 then
		v24 = not (v23 == nil) and tonumber(itemId) == v23
	end

	local plus = data.plus
	local v25 = fFlagAXBackgroundGenerationAnalytics and fFlagAXBackgroundGeneration

	if v25 then
		if plus == nil or plus.isPlusExclusive ~= true or plus.hasActiveSubscription ~= false then
			v25 = false
		else
			v25 = not v20 or v24
		end
	end

	if v19 == nil then
		v19 = (if assetType then module5.AssetTypeIdStringToName[assetType] else nil) or ""
	end

	local inventoryType = if fFlagAXModeratedItemsFlow and v16 then v16.inventoryType else nil
	local v26, v27

	if module22 and v16 then
		v26, v27 = module23(v16)
	end

	local v28 = if v11 then v11.moderationStatus else nil
	local v29

	if v11 then
		v29 = not (v11.creatingUniverseId == nil) and string.len(v11.creatingUniverseId) > 0
	else
		v29 = v11
	end

	if not v29 and data.availabilityStatus ~= nil then
		v28 = module16.getModerationStatusFromAvailabilityStatus(data.availabilityStatus)
	end

	local updateCounter = if v11 then v11.updateCounter else nil

	local v30 = React.useCallback(function(p2, p3, p4)
		v8(module11(p2, p3, p4))
	end, { v8 })
	local v31 = useSlotBasedEditorContext()

	local plus2 = if fFlagAXBackgroundGenerationAnalytics then data.plus else nil
	local v32

	if fFlagAXPlusExclusiveBackgroundTryOn then
		v32 = React.useCallback(function(p2, callback, p3)
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
		v32 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		if fFlagAXBackgroundGenerationAnalytics and v25 and data.itemId and plus2 and plus2.onActivated then
			if fFlagAXPlusExclusiveBackgroundTryOn and v32 then
				v32(data.itemId, plus2.onActivated, v24)
			else
				plus2.onActivated(data.itemId)
			end
		elseif
			fFlagAXBackgroundGenerationAnalytics
			or not fFlagAXBackgroundGeneration
			or not data.onPlusExclusiveActivated
			or v20 and not v24
			or fFlagAXPlusExclusiveBackgroundTryOn and not data.itemId
		then
			if data.itemId and assetType then
				if v21 then
					if fFlagAXBackgroundsEquipTryOnCounters then
						reportBackgroundUserActionCounter.report(v22 and "Unequip" or "Equip")
					end

					dispatchBackgroundSelection(v8, v22, data.itemId, v23)

					if
						fFlagAXBackgroundGenerationAnalytics
						and plus2
						and plus2.isPlusExclusive
						and plus2.onSelectionChanged
					then
						plus2.onSelectionChanged(data.itemId, not v22, plus2.hasActiveSubscription == true)
					end
				else
					local v33 = if data.isSelected then v5.unequipAsset else v5.equipAsset

					local layerIndex = nil
					local v34 = nil
					local v35

					if v31 then
						local slotIndex = v31.signalStore.getSlotIndex()

						v35 = v31.signalStore.getSlots()[slotIndex]

						if not data.isSelected and v35 and v35.slotType == slotType.LayeredSlot then
							layerIndex = v35.layerIndex
							v34 = {}

							for k, assetType2 in v35.assetTypes do
								table.insert(v34, (tostring(assetType2.Value)))
							end
						end
					end

					v30(v33, data.itemId, assetType)
					v8(module6(assetType, data.itemId, v9, nil, layerIndex, nil, v34))

					v8(module17(v5, name, fullView.None))

					if data.isSelected and v35 and v35.slotType ~= slotType.LayeredSlot then
						v8(module14())
					end
				end
			end
		elseif fFlagAXPlusExclusiveBackgroundTryOn and v32 then
			v32(data.itemId, data.onPlusExclusiveActivated, v24)
		else
			data.onPlusExclusiveActivated()
		end
	end

	local v33

	if fFlagAXBackgroundsCustomizeHydration then
		v33 = {
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
		local v34 = if fFlagAXBackgroundGenerationAnalytics then v25 else nil
		local v35 = if fFlagAXBackgroundGenerationAnalytics then plus2 else data.onPlusExclusiveActivated

		v33[1], v33[2], v33[3], v33[4], v33[5], v33[6], v33[7], v33[8], v33[9], v33[10], v33[11], v33[12], v33[13], v33[14], v33[15] = itemId2, assetType, isSelected, v5, v30, v8, v9, name, v31, v21, v22, v34, v35, if fFlagAXPlusExclusiveBackgroundTryOn then v32 else nil, (fFlagAXBackgroundsEndTryOnOnSelect or fFlagAXPlusExclusiveBackgroundTryOn) and (v23 or 0) or nil
	else
		v33 = {
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
		local v34 = if fFlagAXBackgroundGenerationAnalytics then v25 else nil
		local v35 = if fFlagAXBackgroundGenerationAnalytics then plus2 else data.onPlusExclusiveActivated
		v33[1], v33[2], v33[3], v33[4], v33[5], v33[6], v33[7], v33[8], v33[9], v33[10], v33[11], v33[12] = itemId2, assetType, isSelected, v5, v30, v8, v9, name, v31, v34, v35, if fFlagAXPlusExclusiveBackgroundTryOn then v32 else nil
	end

	local v34 = useCallback(fn, v33)

	local v35 = React.useCallback(function()
		if v16 then
			local v36 = {
				outfitInfo = v16,
				analytics = v5,
				navigation = v9,
				isSelected = data.isSelected
			}

			v8(module17(v5, name, fullView.None))
			v8(module7(v36))
		end
	end, { v16, assetType, v5, v9, data.isSelected, v8, name })

	local v36 = React.useCallback(function(): boolean
		if not data.itemId or not v17 or data.isSelected then
			return false
		end

		local v37 = assetType == module5.AssetTypeIdStrings.HairAccessory
		local v38 = v16 and v16.outfitType == module5.OutfitTypes.Shoes
		local v39 = assetType and module5.LayeredAssetTypes[assetType] ~= nil
		local v40

		if fFlagAXBlockMakeupEquipR6 then
			v40 = assetType and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[assetType]
		end

		local v41

		if defineFastFlag then
			v41 = v16

			if v41 then
				v41 = v16.outfitType == module5.OutfitTypes.Avatar
					and v16.avatarType == module5.AvatarType.R15
			end
		else
			v41 = nil
		end

		if v39 and not v37 or v38 or v41 or v40 then
			v8(navigateWithLock(function()
				local v43 = if v38 or v41 then v35 else v34
				v9.navigate(avatarScreen.R15UpgradePrompt, {
					bodyTextKey = "Feature.Avatar.Label.LayeredClothingR15Warning",
					onSwitchSelected = v43
				})
			end))
			return true
		end

		local v42 = assetType == module5.AssetTypeIdStrings.EmoteAnimation
		local animationAssetType = module16.isAnimationAssetType(assetType)

		if v42 or animationAssetType then
			local v43 = v42 and "Feature.Avatar.Message.R15EmotesPrompt"
				or "Feature.Avatar.Message.R15AnimationsPrompt"
			v8(navigateWithLock(function()
				v9.navigate(avatarScreen.R15UpgradePrompt, { bodyTextKey = v43 })
			end))
			return false
		end

		return false
	end, {
		data.itemId,
		assetType,
		v16,
		v17,
		data.isSelected,
		v9,
		v34,
		v35,
		v8
	})

	local v37 = React.useCallback(function(): boolean
		if not v31 then
			return false
		end

		local slots = v31.signalStore.getSlots()
		local slotIndex = v31.signalStore.getSlotIndex()
		local v38

		if inventoryItemType2 == inventoryItemType.Asset then
			v38 = assetType and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[assetType]
		else
			v38 = false
		end

		local v39 = slotIndex
			and slots
			and slots[slotIndex]
			and slots[slotIndex].slotType == slotType.LayeredSlot
		local v40 = v14 and #v14 == MAX_MAKEUP_LAYERS

		if
			v12
			and v12.shouldShowMakeupMax6LayersPrompt()
			and not data.isSelected
			and v38
			and slotIndex
			and not v39
			and v40
		then
			v9.navigate(avatarScreen.MakeupMax6LayersPrompt, {
				onConfirm = function(p2)
					if p2 then
						v12.hideMakeupMax6LayersPrompt()
					end

					v34()
				end
			})

			v12.incrementSeenMakeupMax6LayersPrompt()

			return true
		end

		return false
	end, { v12, assetType, data.isSelected, v14, v31, v9, v34, inventoryItemType2 })

	local v38 = React.useCallback(function()
		if v36() or v37() then
			return
		end

		if inventoryItemType2 == inventoryItemType.Asset and data.itemId then
			v34()
		elseif inventoryItemType2 == inventoryItemType.Outfit and v16 then
			v35()
		end
	end, { inventoryItemType2, data.itemId, v34, v16, v35, v37 })

	local v39 = React.useCallback(function(messageType)
		local v40 = if assetType then module5.AssetTypeIdStringToName[assetType] else inventoryType
		local v41

		if fFlagAXModeratedItemsFlow then
			v41 = not assetType and "Feature.Catalog.Label.Bundle" or module5.AssetTypeLocalized[assetType]
		end

		local navigate = v9.navigate
		local itemsUnavailablePrompt = avatarScreen.ItemsUnavailablePrompt

		if not fFlagAXModeratedItemsFlow then
			v40 = inventoryItemType2
		end

		navigate(itemsUnavailablePrompt, {
			items = {
				{ category = v40, categoryLoc = v41, itemName = v19 }
			},
			messageType = messageType
		})
	end, { v9, v28, v19, assetType, inventoryType })
	local v40

	if module16.isModerationPendingOrRejected(v28) then
		local v41

		if v28 == Enum.ModerationStatus.NotReviewed then
			v41 = catalogItemCardStatusIconTypeEnum.PendingModeration
		else
			v41 = catalogItemCardStatusIconTypeEnum.Moderated
		end

		v38 = function()
			local messageTypeFromModerationStatus = module16.getMessageTypeFromModerationStatus(v28)

			if not messageTypeFromModerationStatus then
				error("ItemsUnavailablePrompt prop messageType cannot be nil")
			end

			v39(messageTypeFromModerationStatus)
		end

		v40 = { type = "placeholder", iconType = v41 }
	end

	if fFlagAXModeratedItemsFlow and data.availabilityStatus == inventoryItemAvailability.Unavailable then
		v40 = {
			type = "placeholder",
			iconType = not fFlagAXModeratedItemIconUpdates and "Error" or catalogItemCardStatusIconTypeEnum.Unavailable
		}

		v38 = function()
			v39("UnavailableItems")
		end
	end

	local v41

	if v16 then
		v41 = not (v16.creatingUniverseId == nil) and string.len(v16.creatingUniverseId) > 0
	else
		v41 = v16
	end

	local v42 = fFlagAXBlockUnavailableMakeupLookSelection

	if v42 then
		if
			inventoryItemType2 == inventoryItemType.Outfit
			and v16 ~= nil
			and v16.outfitType == module5.OutfitTypes.Makeup
		then
			v42 = module16.isModerationPendingOrRejected(v28)
		else
			v42 = false
		end
	end

	local v43 = not v42
		and (inventoryItemType2 == inventoryItemType.Asset or (v41 or fFlagAXOutfitPageRevamp and inventoryItemType2 == inventoryItemType.Outfit))

	local v44 = React.useCallback(function()
		if inventoryItemType2 == inventoryItemType.Outfit then
			local v45 = {
				outfitId = data.itemId,
				ZIndex = 2,
				showFullWithNoPeekView = not v18,
				renderBottomBar = false,
				NextSelectionLeft = 0
			}

			local v46 = if v18 then data.resultsListRef else nil
			v45.NextSelectionLeft = v46

			v8(navigateWithLock(function()
				module20.closeFiltersAndItemDetails(v9)

				module20.closeTryOnManager(v9)
				v9.navigate(avatarScreen.OutfitDetails, v45)
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

			local v45 = {
				itemId = data.itemId,
				itemType = module5.ItemType.Asset,
				itemSubType = module15.GetItemSubType(inventoryItemType2, v11),
				priceInRobux = 0,
				catalogAnalytics = 0,
				avatarRoute = 0,
				navigation = 0,
				itemDetailsPeekViewRefs = 0,
				resultsListRef = 0,
				showFullWithNoPeekView = true,
				closePreviousItemDetails = true
			}
			local v46 = if v11 then v11.priceInRobux else nil
			v45.priceInRobux = v46
			v45.catalogAnalytics = v6
			v45.avatarRoute = v10
			v45.navigation = v9
			v45.itemDetailsPeekViewRefs = data.itemDetailsPeekViewRefs
			v45.resultsListRef = data.resultsListRef

			v8(module12(v45))
		end
	end, {
		inventoryItemType2,
		data.itemId,
		v18,
		v11,
		v6,
		v10,
		v9,
		data.itemDetailsPeekViewRefs,
		data.resultsListRef,
		v8
	})

	local v45 = {
		itemId = data.itemId,
		inventoryItemType = inventoryItemType2,
		itemName = v19 or "",
		isSelected = v20,
		isPlusUpsellTarget = if fFlagAXBackgroundGenerationAnalytics then v25 else nil,
		thumbnailRef = ref,
		onActivated = v38,
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

	if not v43 then
		v44 = nil
	end

	v45.onDetailsButtonActivated = v44
	v45.impressionsTag = data.impressionsTag
	v45.gridInformation = data.gridInformation
	local v47 = if assetType then tonumber(assetType) else nil
	v45.assetType = v47

	if not module22 then
		v26 = nil
	end

	v45.bundleType = v26

	if not module22 then
		v27 = nil
	end

	v45.organicLookType = v27
	local v48 = if module22 then data.unifiedCategoryFields else nil
	v45.unifiedCategoryFields = v48
	v45.outfitType = if fFlagAXModeratedItemsFlow then inventoryType else nil
	v45.hideName = data.hideName or false
	v45.availabilityStatus = data.availabilityStatus
	v45.moderationStatus = v28
	v45.updateCounter = updateCounter
	v45.itemStatus = v40

	local v50 = if fFlagAXMarketplaceLicensingItemCards and v11 then v11.itemLicensingInfo else nil
	v45.itemLicensingInfo = v50

	if not fFlagAXInventoryDurablesSupport then
		v15 = nil
	end

	v45.expirationTime = v15
	local v51 = if fFlagAXEditorEnableThumbnailLatencyStore then data.onThumbnailLoaded else nil
	v45.onThumbnailLoaded = v51

	React.useEffect(function()
		if ref.current then
			local joined = Cryo.Dictionary.join(v45, {
				itemType = v45.inventoryItemType == inventoryItemType.Asset and "Asset" or v45.inventoryItemType == inventoryItemType.Outfit and "Bundle" or nil
			})

			ref.current:SetAttribute(joined.impressionsTag, joined.itemId)
			local v52 = organicEventImpressionsSchema[data.impressionsSchema]
			impressionsUtil.writeItemAttributes(v52, ref.current, joined)
		end
	end, { v45, data.impressionsSchema })

	return v45
end

return useInventoryItemCardProps
