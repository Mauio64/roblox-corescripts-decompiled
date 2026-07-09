local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local InventoryItemType = AvatarExperienceSlotBasedEditor.Enums.InventoryItemType
local InventoryItemAvailability = AvatarExperienceSlotBasedEditor.Enums.InventoryItemAvailability
local CatalogItemCardStatusIconTypeEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Thunks.ToggleEquipAsset)
local EquipOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.EquipOutfit)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local SendAnalytics = require(Modules.AvatarExperience.AvatarEditor.Thunks.SendAnalytics)
local OpenItemDetails = require(Modules.AvatarExperience.Common.Thunks.OpenItemDetails)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local NormalizeAvatar = require(Modules.AvatarExperience.AvatarEditor.Actions.NormalizeAvatar)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local ImpressionsUtil = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).ImpressionsReporter.ImpressionsUtil
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local getRemainingTimeFromExpiration = AvatarExperienceSlotBasedEditor.Utils.getRemainingTimeFromExpiration
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

require(Modules.AvatarExperience.Common.Types)

local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local OrganicEventImpressionsSchema = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).ImpressionsReporter.OrganicEventImpressionsSchema
local sendUnifiedEventForDeferredAction = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendUnifiedEventForDeferredAction
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local getUnifiedLoggingSurface = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Utils.getUnifiedLoggingSurface
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local useSlotBasedEditorContext = AvatarExperienceSlotBasedEditor.Context.useSlotBasedEditorContext
local SlotType = AvatarExperienceSlotBasedEditor.Enums.SlotType
local v43 = game:DefineFastFlag("AXR15PromptBeforeApplyingAvatar", false)
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXEnableModeratedItemsFlowForDurables = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableModeratedItemsFlowForDurables
local FFlagAXFixStaleModerationStatusFromGrant = AvatarExperienceFlags.FFlagAXFixStaleModerationStatusFromGrant
local FFlagAXFixIecModerationFromInventoryFetch = AvatarExperienceFlags.FFlagAXFixIecModerationFromInventoryFetch
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXBlockMakeupEquipR6 = AvatarExperienceFlags.FFlagAXBlockMakeupEquipR6
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local FFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration
local FFlagAXFixClickItemDetailsSurfaceLogging = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXFixClickItemDetailsSurfaceLogging
local ApplyProfileConfiguration = AvatarExperienceRodux.Actions.ApplyProfileConfiguration
local selectActiveBackground = AvatarExperienceCommon.Backgrounds.selectActiveBackground
local NO_BACKGROUND_ASSET_ID = AvatarExperienceCommon.Backgrounds.NO_BACKGROUND_ASSET_ID

require(script.Parent.InventoryItemCard)

local useMakeupFtux = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Hooks.useMakeupFtux
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local MAX_MAKEUP_LAYERS = AvatarExperienceCommon.Constants.MAX_MAKEUP_LAYERS
local selectEquippedLayeredMakeupAssets = AvatarExperienceCommon.State.Selectors.selectEquippedLayeredMakeupAssets

local function selectIsR6(p1) -- line: 112
	-- upvalues: Constants (copy)
	return p1.AvatarExperience.AvatarEditor.Character.AvatarType == Constants.AvatarType.R6
end
local function useBackgroundTileState(s1: string?, s2: string?, b1: boolean) -- line: 118
	-- upvalues: FFlagAXBackgroundsCustomizeHydration (copy), Constants (copy), React (copy), selectActiveBackground (copy), useSelector (copy)
	local v71 = FFlagAXBackgroundsCustomizeHydration and s2 == Constants.AssetTypeIdStrings.AvatarBackground
	local v72 = React.useCallback(function(p2) -- line: 125
		-- upvalues: v71 (copy), selectActiveBackground (copy)
		if v71 then
			return (selectActiveBackground(p2))
		end

		return nil
	end, { v71 })
	local v73 = if not FFlagAXBackgroundsCustomizeHydration then nil else useSelector(v72)
	local v74 = v71 and (v73 ~= nil and v73 == tonumber(s1))

	return v71, v74, if not v71 then b1 else v74
end
local function dispatchBackgroundSelection(p3: ((...any) -> ...any), b2: boolean, s3: string) -- line: 140
	-- upvalues: NO_BACKGROUND_ASSET_ID (copy), ApplyProfileConfiguration (copy)
	local v78 = if not b2 then tonumber(s3) else NO_BACKGROUND_ASSET_ID

	p3(ApplyProfileConfiguration({
		BackgroundAssetId = v78
	}))
end
local function useInventoryItemCardProps(t1: {[any]: any}) -- line: 145
	-- upvalues: useRoactService (copy), Analytics (copy), Analytics2 (copy), useDispatch (copy), useNavigation (copy), useAvatarRoute (copy), React (copy), InventoryItemType (copy), ItemData (copy), useSelector (copy), FFlagAXCustomizeMakeupSupport (copy), useMakeupFtux (copy), selectEquippedLayeredMakeupAssets (copy), FFlagAXInventoryDurablesSupport (copy), getRemainingTimeFromExpiration (copy), useLocalization (copy), selectIsR6 (copy), selectIsPortrait (copy), FFlagAXBackgroundsCustomizeHydration (copy), useBackgroundTileState (copy), FFlagAXFixIecModerationFromInventoryFetch (copy), Constants (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXFixStaleModerationStatusFromGrant (copy), Utils (copy), FFlagAXRootSlotBasedEditorFlag (copy), SendAnalytics (copy), useSlotBasedEditorContext (copy), NO_BACKGROUND_ASSET_ID (copy), ApplyProfileConfiguration (copy), SlotType (copy), ToggleEquipAsset (copy), SetFullView (copy), FullView (copy), NormalizeAvatar (copy), EquipOutfit (copy), FFlagAXBlockMakeupEquipR6 (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), v43 (copy), AvatarScreen (copy), NavigateWithLock (copy), MAX_MAKEUP_LAYERS (copy), FFlagAXMISEnableMultiShopping (copy), CatalogItemCardStatusIconTypeEnum (copy), InventoryItemAvailability (copy), FFlagAXModeratedItemIconUpdates (copy), NavigationUtils (copy), FFlagAXFixClickItemDetailsSurfaceLogging (copy), sendUnifiedEventForDeferredAction (copy), UnifiedEventLogEnums (copy), getUnifiedLoggingSurface (copy), CatalogUtils (copy), OpenItemDetails (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), Cryo (copy), OrganicEventImpressionsSchema (copy), ImpressionsUtil (copy)
	local v80 = useRoactService(Analytics)
	local v81 = useRoactService(Analytics2)
	local v82 = useDispatch()
	local v83 = useNavigation()
	local v84 = useAvatarRoute()
	local v85 = React.useRef(nil)
	local v86 = v84 and (v84.opaque and v84.opaque.name)
	local inventoryItemType = t1.inventoryItemType
	local v88 = React.useCallback(function(p4) -- line: 156
		-- upvalues: inventoryItemType (copy), InventoryItemType (copy), ItemData (copy), t1 (copy)
		if inventoryItemType == InventoryItemType.Asset then
			return (ItemData(p4.AvatarExperience.Common, t1.itemId, inventoryItemType))
		end

		return nil
	end, {
		inventoryItemType,
		t1.itemId
	})
	local v89 = useSelector(v88)
	local v90 = if not FFlagAXCustomizeMakeupSupport then nil else useMakeupFtux()
	local v91 = if not FFlagAXCustomizeMakeupSupport then nil else useSelector(selectEquippedLayeredMakeupAssets)
	local v92 = nil

	if FFlagAXInventoryDurablesSupport then
		local v93 = if not v89 then nil else getRemainingTimeFromExpiration(v89.expirationTime)
		local v94 = useLocalization({
			days = if not v93 or v93.unit ~= "days" then nil else {
				"Feature.Durables.TimeRemaining.Days",
				number = v93.value
			},
			hours = if not v93 or v93.unit ~= "hours" then nil else {
				"Feature.Durables.TimeRemaining.Hours",
				number = v93.value
			},
			minutes = if not v93 or v93.unit ~= "minutes" then nil else {
				"Feature.Durables.TimeRemaining.Minutes",
				number = v93.value
			}
		})

		v92 = if not v93 then nil else v94[v93.unit]
	end

	local v95 = React.useCallback(function(p5) -- line: 189
		-- upvalues: inventoryItemType (copy), InventoryItemType (copy), t1 (copy)
		if inventoryItemType == InventoryItemType.Outfit then
			return p5.AvatarExperience.AvatarEditor.OutfitInfos[t1.itemId]
		end

		return nil
	end, {
		inventoryItemType,
		t1.itemId
	})
	local v96 = useSelector(v95)
	local v97 = useSelector(selectIsR6)
	local v98 = useSelector(selectIsPortrait)
	local u99 = if not v89 then if not v96 then nil else v96.name else v89.name
	local v100 = if not v89 then nil else v89.assetType
	local u101 = false
	local u102 = false
	local isSelected = t1.isSelected

	if FFlagAXBackgroundsCustomizeHydration then
		local v104, v105

		v104, v105, isSelected = useBackgroundTileState(t1.itemId, v100, t1.isSelected)
		u101 = v104
		u102 = v105
	end

	if FFlagAXFixIecModerationFromInventoryFetch and u99 == nil then
		u99 = ((if not v100 then nil else Constants.AssetTypeIdStringToName[v100])) or ""
	end

	local v106 = if not FFlagAXModeratedItemsFlow or not v96 then nil else v96.inventoryType
	local u107 = if not v89 then nil else v89.moderationStatus

	if FFlagAXFixStaleModerationStatusFromGrant and (not v89 or (v89.creatingUniverseId == nil or not (string.len(v89.creatingUniverseId) > 0))) and t1.availabilityStatus ~= nil then
		u107 = Utils.getModerationStatusFromAvailabilityStatus(t1.availabilityStatus)
	end

	local v108 = if not v89 then nil else v89.updateCounter
	local v109 = if not FFlagAXRootSlotBasedEditorFlag then v96 ~= nil and (v96.containsDynamicHead or v96.outfitType == Constants.OutfitTypes.DynamicHead) else nil
	local v110 = React.useCallback(function(p6, p7, p8) -- line: 234
		-- upvalues: v82 (copy), SendAnalytics (copy)
		v82(SendAnalytics(p6, p7, p8))
	end, { v82 })
	local v111 = if not FFlagAXCustomizeMakeupSupport then nil else useSlotBasedEditorContext()
	local v112 = React.useCallback(function() -- line: 244
		-- upvalues: t1 (copy), v100 (copy), u101 (ref), v82 (copy), u102 (ref), NO_BACKGROUND_ASSET_ID (copy), ApplyProfileConfiguration (copy), v80 (copy), FFlagAXCustomizeMakeupSupport (copy), v111 (copy), SlotType (copy), v110 (copy), ToggleEquipAsset (copy), v83 (copy), SetFullView (copy), v86 (copy), FullView (copy), NormalizeAvatar (copy)
		if t1.itemId and v100 then
			if u101 then
				local v130 = v82
				local v131 = u102
				local itemId = t1.itemId
				local v133 = if not v131 then tonumber(itemId) else NO_BACKGROUND_ASSET_ID

				v130(ApplyProfileConfiguration({
					BackgroundAssetId = v133
				}))

				return
			end

			local v134 = if not t1.isSelected then v80.equipAsset else v80.unequipAsset
			local layerIndex = nil
			local t2 = nil
			local v137 = nil

			if FFlagAXCustomizeMakeupSupport and v111 then
				local v138 = v111.signalStore.getSlotIndex()

				v137 = v111.signalStore.getSlots()[v138]

				if not t1.isSelected and v137 and v137.slotType == SlotType.LayeredSlot then
					layerIndex = v137.layerIndex
					t2 = {}

					for _, v140 in v137.assetTypes do
						table.insert(t2, (tostring(v140.Value)))
					end
				end
			end

			v110(v134, t1.itemId, v100)
			v82(ToggleEquipAsset(v100, t1.itemId, v83, nil, layerIndex, nil, if not FFlagAXCustomizeMakeupSupport then nil else t2))
			v82(SetFullView(v80, v86, FullView.None))

			if FFlagAXCustomizeMakeupSupport and t1.isSelected and v137 and v137.slotType ~= SlotType.LayeredSlot then
				v82(NormalizeAvatar())
			end
		end
	end, if not FFlagAXBackgroundsCustomizeHydration then {
		t1.itemId,
		v100,
		t1.isSelected,
		v80,
		v110,
		v82,
		v83,
		v86,
		v111
	} else {
		t1.itemId,
		v100,
		t1.isSelected,
		v80,
		v110,
		v82,
		v83,
		v86,
		v111,
		u101,
		u102
	})
	local v113 = React.useCallback(function() -- line: 329
		-- upvalues: v96 (copy), v80 (copy), v83 (copy), t1 (copy), v82 (copy), SetFullView (copy), v86 (copy), FullView (copy), EquipOutfit (copy)
		if v96 then
			local t3 = {
				outfitInfo = v96,
				analytics = v80,
				navigation = v83,
				isSelected = t1.isSelected
			}

			v82(SetFullView(v80, v86, FullView.None))
			v82(EquipOutfit(t3))
		end
	end, {
		v96,
		v100,
		v80,
		v83,
		t1.isSelected,
		v82,
		v86
	})
	local v114 = React.useCallback(function() -- line: 348
		-- upvalues: t1 (copy), v97 (copy), v100 (copy), Constants (copy), v96 (copy), FFlagAXBlockMakeupEquipR6 (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), v43 (copy), v83 (copy), AvatarScreen (copy), v113 (copy), v112 (copy), v82 (copy), NavigateWithLock (copy), Utils (copy)
		if not t1.itemId or (not v97 or t1.isSelected) then
			return false
		end

		local v142 = v100 == Constants.AssetTypeIdStrings.HairAccessory
		local v143 = v96 and v96.outfitType == Constants.OutfitTypes.Shoes
		local v144 = v100 and Constants.LayeredAssetTypes[v100] ~= nil
		local v145 = if not FFlagAXBlockMakeupEquipR6 then nil else v100 and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[v100]
		local v146 = if not v43 then nil else v96 and (v96.outfitType == Constants.OutfitTypes.Avatar and v96.avatarType == Constants.AvatarType.R15)

		if v144 and not v142 or v143 or v146 or v145 then
			v82(NavigateWithLock(function() -- line: 366
				-- upvalues: v83 (copy), AvatarScreen (copy), v143 (copy), v146 (copy), v113 (copy), v112 (copy)
				v83.navigate(AvatarScreen.R15UpgradePrompt, {
					bodyTextKey = "Feature.Avatar.Label.LayeredClothingR15Warning",
					onSwitchSelected = if not v143 and not v146 then v112 else v113
				})
			end))

			return true
		end

		local v147 = v100 == Constants.AssetTypeIdStrings.EmoteAnimation
		local v148 = Utils.isAnimationAssetType(v100)

		if v147 or v148 then
			local v149 = not v147 and "Feature.Avatar.Message.R15AnimationsPrompt" or "Feature.Avatar.Message.R15EmotesPrompt"

			v82(NavigateWithLock(function() -- line: 383
				-- upvalues: v83 (copy), AvatarScreen (copy), v149 (copy)
				v83.navigate(AvatarScreen.R15UpgradePrompt, {
					bodyTextKey = v149
				})
			end))

			return false
		end

		return false
	end, {
		t1.itemId,
		v100,
		v96,
		v97,
		t1.isSelected,
		v83,
		v112,
		v113,
		v82
	})
	local v115 = if not FFlagAXCustomizeMakeupSupport then nil else React.useCallback(function() -- line: 408
		-- upvalues: v111 (copy), inventoryItemType (copy), InventoryItemType (copy), v100 (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), SlotType (copy), v91 (copy), MAX_MAKEUP_LAYERS (copy), v90 (copy), t1 (copy), v83 (copy), AvatarScreen (copy), v112 (copy), FFlagAXMISEnableMultiShopping (copy)
		if not v111 then
			return false
		end

		local v150 = v111.signalStore.getSlots()
		local v151 = v111.signalStore.getSlotIndex()
		local v152 = inventoryItemType == InventoryItemType.Asset and (v100 and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[v100])
		local v153 = v151 and (v150 and (v150[v151] and v150[v151].slotType == SlotType.LayeredSlot))
		local v154 = v91 and #v91 == MAX_MAKEUP_LAYERS

		if v90 and v90.shouldShowMakeupMax6LayersPrompt() and not t1.isSelected and v152 and v151 and not v153 and v154 then
			v83.navigate(AvatarScreen.MakeupMax6LayersPrompt, {
				onConfirm = function(p9) -- line: 435
					-- upvalues: v90 (copy), v112 (copy)
					if p9 then
						v90.hideMakeupMax6LayersPrompt()
					end

					v112()
				end
			})

			if FFlagAXMISEnableMultiShopping then
				v90.incrementSeenMakeupMax6LayersPrompt()
			end

			return true
		end

		return false
	end, {
		v90,
		v100,
		t1.isSelected,
		v91,
		v111,
		v83,
		v112,
		inventoryItemType
	})
	local v116 = React.useCallback(function() -- line: 466
		-- upvalues: FFlagAXCustomizeMakeupSupport (copy), v114 (copy), v115 (copy), inventoryItemType (copy), InventoryItemType (copy), t1 (copy), v112 (copy), v96 (copy), v113 (copy)
		if if not FFlagAXCustomizeMakeupSupport then v114() else v114() or v115() then
			return
		end

		if inventoryItemType == InventoryItemType.Asset and t1.itemId then
			v112()

			return
		end

		if inventoryItemType == InventoryItemType.Outfit and v96 then
			v113()
		end
	end, if not FFlagAXCustomizeMakeupSupport then {
		inventoryItemType,
		t1.itemId,
		v112,
		v96,
		v113
	} else {
		inventoryItemType,
		t1.itemId,
		v112,
		v96,
		v113,
		v115
	})
	local t4 = nil
	local v118 = React.useCallback(function(s4: string) -- line: 494
		-- upvalues: v100 (copy), Constants (copy), v106 (copy), FFlagAXModeratedItemsFlow (copy), v83 (copy), AvatarScreen (copy), inventoryItemType (copy), u99 (ref)
		local v156 = if not v100 then v106 else Constants.AssetTypeIdStringToName[v100]
		local v157 = nil

		if FFlagAXModeratedItemsFlow then
			v157 = not v100 and "Feature.Catalog.Label.Bundle" or Constants.AssetTypeLocalized[v100]
		end

		v83.navigate(AvatarScreen.ItemsUnavailablePrompt, {
			items = {{
				category = if not FFlagAXModeratedItemsFlow then inventoryItemType else v156,
				categoryLoc = v157,
				itemName = u99
			}},
			messageType = s4
		})
	end, {
		v83,
		u107,
		u99,
		v100,
		v106
	})

	if Utils.isModerationPendingOrRejected(u107) then
		local v119 = if u107 ~= Enum.ModerationStatus.NotReviewed then CatalogItemCardStatusIconTypeEnum.Moderated else CatalogItemCardStatusIconTypeEnum.PendingModeration

		t4 = {
			type = "placeholder",
			iconType = v119
		}

		function v116() -- line: 526
			-- upvalues: Utils (copy), u107 (ref), v118 (copy)
			local v158 = Utils.getMessageTypeFromModerationStatus(u107)

			if not v158 then
				error("ItemsUnavailablePrompt prop messageType cannot be nil")
			end

			v118(v158)
		end
	end

	if FFlagAXModeratedItemsFlow and t1.availabilityStatus == InventoryItemAvailability.Unavailable then
		t4 = {
			type = "placeholder",
			iconType = not FFlagAXModeratedItemIconUpdates and "Error" or CatalogItemCardStatusIconTypeEnum.Unavailable
		}

		function v116() -- line: 543
			-- upvalues: v118 (copy)
			v118("UnavailableItems")
		end
	end

	local v120 = v96 and (v96.creatingUniverseId ~= nil and string.len(v96.creatingUniverseId) > 0)
	local v121 = inventoryItemType == InventoryItemType.Asset or v120
	local v122 = React.useCallback(function() -- line: 555
		-- upvalues: inventoryItemType (copy), InventoryItemType (copy), t1 (copy), v98 (copy), NavigationUtils (copy), v83 (copy), AvatarScreen (copy), v82 (copy), NavigateWithLock (copy), FFlagAXFixClickItemDetailsSurfaceLogging (copy), sendUnifiedEventForDeferredAction (copy), UnifiedEventLogEnums (copy), getUnifiedLoggingSurface (copy), v84 (copy), Constants (copy), CatalogUtils (copy), v89 (copy), v81 (copy), OpenItemDetails (copy)
		if inventoryItemType == InventoryItemType.Outfit then
			local t5 = {
				ZIndex = 2,
				renderBottomBar = false,
				outfitId = t1.itemId,
				showFullWithNoPeekView = not v98,
				NextSelectionLeft = if not v98 then nil else t1.resultsListRef
			}

			v82(NavigateWithLock(function() -- line: 566
				-- upvalues: NavigationUtils (copy), v83 (copy), AvatarScreen (copy), t5 (copy)
				NavigationUtils.closeFiltersAndItemDetails(v83)
				NavigationUtils.closeTryOnManager(v83)
				v83.navigate(AvatarScreen.OutfitDetails, t5)
			end))

			return
		end

		if inventoryItemType == InventoryItemType.Asset and t1.itemId then
			if FFlagAXFixClickItemDetailsSurfaceLogging then
				sendUnifiedEventForDeferredAction({
					elementName = "CLICK_ITEM_DETAILS",
					action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
					itemId = t1.itemId,
					itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET,
					surface = getUnifiedLoggingSurface(v84)
				})
			end

			local t6 = {
				showFullWithNoPeekView = true,
				closePreviousItemDetails = true,
				itemId = t1.itemId,
				itemType = Constants.ItemType.Asset,
				itemSubType = CatalogUtils.GetItemSubType(inventoryItemType, v89),
				priceInRobux = if not v89 then nil else v89.priceInRobux,
				catalogAnalytics = v81,
				avatarRoute = v84,
				navigation = v83,
				itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
				resultsListRef = t1.resultsListRef
			}

			v82(OpenItemDetails(t6))
		end
	end, {
		inventoryItemType,
		t1.itemId,
		v98,
		v89,
		v81,
		v84,
		v83,
		t1.itemDetailsPeekViewRefs,
		t1.resultsListRef,
		v82
	})
	local t7 = {
		itemId = t1.itemId,
		inventoryItemType = inventoryItemType,
		itemName = u99 or "",
		showDynamicHeadIcon = if not FFlagAXRootSlotBasedEditorFlag then v109 else nil,
		isSelected = isSelected,
		thumbnailRef = v85,
		onActivated = v116,
		onDetailsButtonActivated = if not v121 then nil else v122,
		impressionsTag = t1.impressionsTag,
		gridInformation = t1.gridInformation,
		assetType = if not v100 then nil else tonumber(v100),
		outfitType = if not FFlagAXModeratedItemsFlow then nil else v106,
		hideName = t1.hideName or false,
		availabilityStatus = if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else t1.availabilityStatus,
		moderationStatus = u107,
		updateCounter = v108,
		itemStatus = t4,
		expirationTime = if not FFlagAXInventoryDurablesSupport then nil else v92
	}

	React.useEffect(function() -- line: 640
		-- upvalues: v85 (copy), Cryo (copy), t7 (copy), InventoryItemType (copy), OrganicEventImpressionsSchema (copy), t1 (copy), ImpressionsUtil (copy)
		if v85.current then
			local v161 = Cryo.Dictionary.join(t7, {
				itemType = if t7.inventoryItemType ~= InventoryItemType.Asset then if t7.inventoryItemType ~= InventoryItemType.Outfit then nil else "Bundle" else "Asset"
			})

			v85.current:SetAttribute(v161.impressionsTag, v161.itemId)

			local v162 = OrganicEventImpressionsSchema[t1.impressionsSchema]

			ImpressionsUtil.writeItemAttributes(v162, v85.current, v161)
		end
	end, {
		t7,
		t1.impressionsSchema
	})

	return t7
end

return useInventoryItemCardProps
