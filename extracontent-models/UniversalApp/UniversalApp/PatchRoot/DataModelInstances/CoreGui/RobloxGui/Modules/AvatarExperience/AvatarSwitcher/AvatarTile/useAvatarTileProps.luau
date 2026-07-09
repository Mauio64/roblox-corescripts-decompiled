local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Common.Services.Analytics)
local Analytics3 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local EquipOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.EquipOutfit)
local UpdateSavedOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.UpdateSavedOutfit)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local ToggleTryOn = AvatarExperienceRodux.Actions.ToggleTryOn
local FullView = AvatarExperienceCommon.Enums.FullView
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local ImpressionsUtil = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).ImpressionsReporter.ImpressionsUtil
local OrganicEventImpressionsSchema = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).ImpressionsReporter.OrganicEventImpressionsSchema
local addUnifiedEventLogging = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).addUnifiedEventLogging
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local UnifiedEventLogConstants = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogConstants
local FFlagAXSlotAvatarThumbnailPromptFix = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotAvatarThumbnailPromptFix
local FFlagAXAvatarTileNoDefaultOutfitInfo = require(Modules.AvatarExperience.Flags.FFlagAXAvatarTileNoDefaultOutfitInfo)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXEnableModeratedItemsFlowForDurables = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableModeratedItemsFlowForDurables
local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local v47 = game:DefineFastFlag("AXAddLookTypeToAvatarTile", false)
local FFlagAXBlockMakeupEquipR6 = AvatarExperienceFlags.FFlagAXBlockMakeupEquipR6
local FFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local InventoryItemAvailability = AvatarExperienceSlotBasedEditor.Enums.InventoryItemAvailability

require(Modules.AvatarExperience.Common.Types)

local function getItemStatus(p1) -- line: 89
	-- upvalues: InventoryItemAvailability (copy), FFlagAXModeratedItemIconUpdates (copy), FFlagAXInventoryDurablesSupport (copy)
	if p1 and p1.availabilityStatus == InventoryItemAvailability.Unavailable then
		return {
			type = "placeholder",
			iconType = not FFlagAXModeratedItemIconUpdates and "Error" or "Unavailable"
		}
	end

	if p1 and p1.availabilityStatus == InventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems then
		return {
			type = "icon",
			iconType = "Unavailable"
		}
	end

	if FFlagAXInventoryDurablesSupport and p1 and p1.availabilityStatus == InventoryItemAvailability.PartiallyAvailableWithExpiredSubitems then
		return {
			type = "icon",
			iconType = "Info"
		}
	end

	return nil
end
local function v52(p2) -- line: 125
	return p2.AvatarExperience.Common.AssetInfos
end
local function selectIsR6(p3) -- line: 130
	-- upvalues: Constants (copy)
	return p3.AvatarExperience.AvatarEditor.Character.AvatarType == Constants.AvatarType.R6
end
local function useAvatarTileProps(t1: {[any]: any}, p4) -- line: 134
	-- upvalues: useAvatarRoute (copy), useNavigation (copy), useAdaptiveScrolling (copy), useDispatch (copy), FFlagAXEnableExpiredUserLookCheckout (copy), useRoactService (copy), Analytics3 (copy), Analytics (copy), Analytics2 (copy), FFlagAXModeratedItemsFlow (copy), RoactNetworking (copy), ReactFocusNavigation (copy), Responsive (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), useSelector (copy), v52 (copy), getUseSelectorDeepEquals (copy), React (copy), FFlagAXAvatarTileNoDefaultOutfitInfo (copy), SetFullView (copy), FullView (copy), AvatarScreen (copy), Constants (copy), FFlagAXBlockMakeupEquipR6 (copy), selectIsR6 (copy), EquipOutfit (copy), InventoryItemAvailability (copy), NavigateWithLock (copy), FFlagAXSlotAvatarThumbnailPromptFix (copy), Utils (copy), UpdateSavedOutfit (copy), ToggleTryOn (copy), FetchAssetOrBundleInfo (copy), Cryo (copy), ImpressionEnums (copy), OrganicEventImpressionsSchema (copy), ImpressionsUtil (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), v47 (copy), UnifiedEventLogConstants (copy), FFlagAXInventoryDurablesSupport (copy), GetFFlagAXEnableSlotBasedEditor (copy), getItemStatus (copy)
	local v60 = useAvatarRoute()
	local v61 = useNavigation()
	local v62 = useAdaptiveScrolling()
	local v63 = useDispatch()
	local v64 = if not FFlagAXEnableExpiredUserLookCheckout then nil else useRoactService(Analytics3)
	local v65 = useRoactService(Analytics)
	local v66 = useRoactService(Analytics2)
	local v67 = if not FFlagAXModeratedItemsFlow and not FFlagAXEnableExpiredUserLookCheckout then nil else useRoactService(RoactNetworking)
	local v68 = ReactFocusNavigation.useFocusGuiObject()
	local v69 = Responsive.usePreferredInput()
	local v70 = if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else useSelector(v52, getUseSelectorDeepEquals())
	local v71 = React.useCallback(function(p5) -- line: 152
		-- upvalues: FFlagAXAvatarTileNoDefaultOutfitInfo (copy), t1 (copy)
		if FFlagAXAvatarTileNoDefaultOutfitInfo then
			return p5.AvatarExperience.AvatarEditor.OutfitInfos[t1.itemId]
		end

		return p5.AvatarExperience.AvatarEditor.OutfitInfos[t1.itemId] or {}
	end, { t1.itemId })
	local v72 = useSelector(v71, getUseSelectorDeepEquals())
	local v73 = React.useCallback(function(b1: boolean, b2: boolean) -- line: 162
		-- upvalues: v62 (copy), p4 (copy), v63 (copy), SetFullView (copy), v66 (copy), v60 (copy), FullView (copy)
		if v62 then
			if b1 then
				v62.setSelectedItemInstance(nil)
			else
				local current = p4.current

				if current and b2 then
					v62.setSelectedItemInstance(current)
				end
			end
		end

		if not b1 and b2 then
			v63(SetFullView(v66, v60.opaque.name, FullView.None))
		end
	end, {
		v62,
		v63,
		v66,
		v60
	})
	local v74 = React.useCallback(function() -- line: 180
		-- upvalues: v69 (copy), Responsive (copy), v68 (copy), p4 (copy)
		if v69 == Responsive.Input.Directional then
			v68(p4.current)
		end
	end, {
		v69,
		v68
	})
	local v75 = React.useCallback(function() -- line: 186
		-- upvalues: v61 (copy), AvatarScreen (copy), v72 (copy), v74 (copy), v73 (copy), t1 (copy)
		v61.navigate(AvatarScreen.EquipOutfitConfirmation, {
			outfitInfo = v72,
			onOverlayClosed = v74,
			onEquip = function(b3: boolean?) -- line: 190
				-- upvalues: v73 (copy), t1 (copy)
				v73(t1.isSelected, b3 or false)
			end
		})
	end, {
		t1.isSelected,
		v72,
		v74,
		v61,
		v73
	})
	local v76 = React.useCallback(function(p6) -- line: 197
		-- upvalues: v72 (copy), v70 (copy), Constants (copy), FFlagAXEnableExpiredUserLookCheckout (copy)
		local t2 = {}

		for v96, v97 in v72.assets do
			for v98, v99 in v97 do
				local v100 = v70[v98]

				if p6 == v99.availabilityStatus then
					table.insert(t2, {
						categoryLoc = Constants.AssetTypeLocalized[v96],
						itemName = v100.name,
						itemId = if not FFlagAXEnableExpiredUserLookCheckout then nil else v100.id,
						itemSubType = if not FFlagAXEnableExpiredUserLookCheckout then nil else v96,
						order = if not FFlagAXEnableExpiredUserLookCheckout then nil else v99.order
					})
				end
			end
		end

		return t2
	end, {
		v72,
		v70
	})
	local v77 = if not FFlagAXBlockMakeupEquipR6 then nil else useSelector(selectIsR6)
	local v78 = React.useCallback(function(_: ((...any) -> ...any)?) -- line: 218
		-- upvalues: FFlagAXAvatarTileNoDefaultOutfitInfo (copy), v72 (copy), v63 (copy), EquipOutfit (copy), v65 (copy), v61 (copy), t1 (copy), v73 (copy), FFlagAXEnableExpiredUserLookCheckout (copy), v76 (copy), InventoryItemAvailability (copy), AvatarScreen (copy), FFlagAXBlockMakeupEquipR6 (copy), v77 (copy), Constants (copy), NavigateWithLock (copy), FFlagAXSlotAvatarThumbnailPromptFix (copy), v75 (copy)
		if FFlagAXAvatarTileNoDefaultOutfitInfo and (not v72 or not v72.assets) then
			return
		end

		local function equip() -- line: 226
			-- upvalues: v63 (copy), EquipOutfit (copy), v72 (copy), v65 (copy), v61 (copy), t1 (copy), v73 (copy)
			local v117 = v63(EquipOutfit({
				outfitInfo = v72,
				analytics = v65,
				navigation = v61,
				isSelected = t1.isSelected
			}))

			v73(t1.isSelected, v117 or false)
		end

		if FFlagAXEnableExpiredUserLookCheckout then
			local v103 = v76(InventoryItemAvailability.Expired)

			v61.navigate(AvatarScreen.ExpiredUserLookActionBar, {
				expiredItemCount = not (#v103 > 0) and 0 or #v103,
				expiredItems = if not (#v103 > 0) then nil else v103
			})
		end

		if FFlagAXBlockMakeupEquipR6 and v77 and v72.outfitType == Constants.OutfitTypes.Makeup then
			v63(NavigateWithLock(function() -- line: 245
				-- upvalues: v61 (copy), AvatarScreen (copy), equip (copy)
				v61.navigate(AvatarScreen.R15UpgradePrompt, {
					bodyTextKey = "Feature.Avatar.Label.LayeredClothingR15Warning",
					onSwitchSelected = equip
				})
			end))

			return
		end

		if not FFlagAXSlotAvatarThumbnailPromptFix and not t1.hasItemFromCurrentPageEquipped then
			v63(NavigateWithLock(v75))

			return
		end

		local v104 = v63(EquipOutfit({
			outfitInfo = v72,
			analytics = v65,
			navigation = v61,
			isSelected = t1.isSelected
		}))

		v73(t1.isSelected, v104 or false)
	end, {
		v72,
		t1.isSelected,
		t1.hasItemFromCurrentPageEquipped,
		v65,
		v61,
		v73,
		if FFlagAXSlotAvatarThumbnailPromptFix then nil else v75,
		if not FFlagAXBlockMakeupEquipR6 then nil else v77,
		v63,
		v76,
		v67,
		t1.itemId
	})

	local function onActivatedWithUnavailableItems(p8: ((...any) -> ...any)?) -- line: 278
		-- upvalues: v61 (copy), AvatarScreen (copy), v76 (copy), InventoryItemAvailability (copy)
		v61.navigate(AvatarScreen.ItemsUnavailablePrompt, {
			messageType = "UnavailableItems",
			items = v76(InventoryItemAvailability.Unavailable),
			onConfirm = p8
		})
	end
	local function onActivatedWithRevokedItems(p9: ((...any) -> ...any)?) -- line: 287
		-- upvalues: Utils (copy), v72 (copy), InventoryItemAvailability (copy), v63 (copy), UpdateSavedOutfit (copy), v65 (copy), t1 (copy), v67 (copy), v61 (copy), AvatarScreen (copy), v76 (copy)
		local v107 = Utils.filterOutfitAssetsWithStatus(v72, InventoryItemAvailability.Revoked)

		v63(UpdateSavedOutfit(v65, t1.itemId, v107, nil, v67))
		v61.navigate(AvatarScreen.ItemsUnavailablePrompt, {
			messageType = "RevokedItems",
			items = v76(InventoryItemAvailability.Revoked),
			onConfirm = p9
		})
	end
	local function onActivatedWithPartiallyExpiredItems(p10: ((...any) -> ...any)?) -- line: 302
		-- upvalues: FFlagAXEnableExpiredUserLookCheckout (copy), v76 (copy), InventoryItemAvailability (copy), v63 (copy), ToggleTryOn (copy), Constants (copy), FetchAssetOrBundleInfo (copy), v67 (copy), v64 (copy), v61 (copy), AvatarScreen (copy), Utils (copy), v72 (copy), UpdateSavedOutfit (copy), v65 (copy), t1 (copy)
		if FFlagAXEnableExpiredUserLookCheckout then
			local v109 = v76(InventoryItemAvailability.Expired)

			if #v109 > 0 then
				for _, v111 in v109 do
					v63(ToggleTryOn(Constants.ItemType.Asset, v111.itemSubType, v111.itemId, true, v111.order))
					v63(FetchAssetOrBundleInfo(v67, v64, v111.itemId, Constants.ItemType.Asset))
				end

				v61.navigate(AvatarScreen.ExpiredUserLookActionBar, {
					expiredItemCount = #v109,
					expiredItems = v109
				})

				return
			end
		else
			local v112 = Utils.filterOutfitAssetsWithStatus(v72, InventoryItemAvailability.Expired)

			v63(UpdateSavedOutfit(v65, t1.itemId, v112, true, v67))
			v61.navigate(AvatarScreen.ItemsUnavailablePrompt, {
				items = nil,
				messageType = "PartiallyExpiredItems",
				onConfirm = p10
			})
		end
	end

	React.useEffect(function() -- line: 339
		-- upvalues: p4 (copy), v72 (copy), FFlagAXAvatarTileNoDefaultOutfitInfo (copy), Cryo (copy), t1 (copy), ImpressionEnums (copy), OrganicEventImpressionsSchema (copy), ImpressionsUtil (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), v47 (copy), UnifiedEventLogConstants (copy)
		if p4.current and v72 and (FFlagAXAvatarTileNoDefaultOutfitInfo or not Cryo.isEmpty(v72)) then
			local t3 = {
				itemType = "Bundle",
				itemId = t1.itemId,
				surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
			}

			if t1.impressionsTag then
				p4.current:SetAttribute(t1.impressionsTag, t1.itemId)
			end

			local v114 = OrganicEventImpressionsSchema[t1.impressionsSchema]

			ImpressionsUtil.writeItemAttributes(v114, p4.current, t3)
			addUnifiedEventLogging(p4, {
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
				itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE,
				organicLookType = if not v47 then nil else UnifiedEventLogEnums.MarketplaceLookType.LOOK_TYPE_AVATAR,
				itemId = t1.itemId,
				gridPositionRow = if not t1.gridInformation then nil else t1.gridInformation.row,
				gridPositionColumn = if not t1.gridInformation then nil else t1.gridInformation.column
			}, {
				sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
			})
		end
	end, {
		t1.itemId,
		v72,
		t1.gridInformation
	})

	local v82 = v78

	if FFlagAXModeratedItemsFlow then
		local v83 = v72 and v72.availabilityStatus
		local v84 = v83 == InventoryItemAvailability.Unavailable or v83 == InventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems
		local v85 = nil

		if FFlagAXInventoryDurablesSupport then
			v85 = v83 == InventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
		end

		if v84 then
			local v86 = v76(InventoryItemAvailability.Unavailable)
			local v87 = v76(InventoryItemAvailability.Revoked)
			local v88 = v86 and #v86 > 0
			local v89 = v87 and #v87 > 0

			function v82() -- line: 384
				-- upvalues: v88 (copy), v89 (copy), onActivatedWithRevokedItems (copy), v78 (copy), v61 (copy), AvatarScreen (copy), v76 (copy), InventoryItemAvailability (copy)
				if v88 and v89 then
					v61.navigate(AvatarScreen.ItemsUnavailablePrompt, {
						messageType = "UnavailableItems",
						items = v76(InventoryItemAvailability.Unavailable),
						onConfirm = function() -- line: 389
							-- upvalues: onActivatedWithRevokedItems (copy), v78 (copy)
							onActivatedWithRevokedItems(v78)
						end
					})

					return
				end

				if v88 then
					local v115 = v78

					v61.navigate(AvatarScreen.ItemsUnavailablePrompt, {
						messageType = "UnavailableItems",
						items = v76(InventoryItemAvailability.Unavailable),
						onConfirm = v115
					})

					return
				end

				if v89 then
					onActivatedWithRevokedItems(v78)
				end
			end
		elseif FFlagAXInventoryDurablesSupport and v85 then
			function v82() -- line: 399
				-- upvalues: v78 (copy), onActivatedWithPartiallyExpiredItems (copy)
				v78()
				onActivatedWithPartiallyExpiredItems()
			end
		end
	end

	if FFlagAXEnableModeratedItemsFlowForDurables and FFlagAXInventoryDurablesSupport and not FFlagAXModeratedItemsFlow and (v72 and v72.availabilityStatus) == InventoryItemAvailability.PartiallyAvailableWithExpiredSubitems then
		function v82() -- line: 418
			-- upvalues: v78 (copy), onActivatedWithPartiallyExpiredItems (copy)
			v78()
			onActivatedWithPartiallyExpiredItems()
		end
	end

	return {
		item = v72,
		onActivated = v82,
		isSelected = t1.isSelected,
		itemId = t1.itemId,
		index = t1.index,
		itemWidth = t1.itemWidth,
		hasItemFromCurrentPageEquipped = t1.hasItemFromCurrentPageEquipped,
		impressionsTag = t1.impressionsTag,
		squareAspectRatio = if not GetFFlagAXEnableSlotBasedEditor() then nil else t1.squareAspectRatio,
		outfitUpdateCounter = (not FFlagAXSlotAvatarThumbnailPromptFix or (not v72 or not v72.updateCounter)) and 0 or v72.updateCounter,
		itemStatus = if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else getItemStatus(v72)
	}
end

return useAvatarTileProps
