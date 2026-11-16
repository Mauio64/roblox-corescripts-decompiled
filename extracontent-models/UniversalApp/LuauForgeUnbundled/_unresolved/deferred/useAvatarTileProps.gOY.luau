local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module6 = require("@luauforge/bundled/dHL")
local module7 = require("@luauforge/bundled/fuM")

local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local module8 = require("@luauforge/bundled/eeH")
local module9 = require("@luauforge/bundled/eda")

local module10 = require("@luauforge/bundled/dMx")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local module11 = require("@luauforge/bundled/fvh")
local module12 = require("@luauforge/bundled/geT")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module13 = require("@luauforge/bundled/fvF")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module14 = require("@luauforge/bundled/gfg")
local module15 = require("@luauforge/deferred/gOZ")
local module16 = require("@luauforge/bundled/gnZ")
local module17 = require("@luauforge/bundled/fuC")
local toggleTryOn = module6.Actions.ToggleTryOn
local fullView = AvatarExperienceCommon.Enums.FullView
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums

local impressionsUtil = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").ImpressionsReporter.ImpressionsUtil

local organicEventImpressionsSchema = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").ImpressionsReporter.OrganicEventImpressionsSchema
require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local addUnifiedEventLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").addUnifiedEventLogging
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local unifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogConstants

local fFlagAXSlotAvatarThumbnailPromptFix = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotAvatarThumbnailPromptFix

local module18 = require("@luauforge/deferred/gPb")
local module19 = require("@luauforge/bundled/dOc")

local fFlagAXModeratedItemsFlow = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXModeratedItemsFlow
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local fFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout

local fFlagAXEditorEnableThumbnailLatencyStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXEditorEnableThumbnailLatencyStore

local defineFastFlag = game:DefineFastFlag("AXAddLookTypeToAvatarTile", false)
local defineFastFlag2 = game:DefineFastFlag("AXFixExpiredLookCheckoutNav", false)
local fFlagAXBlockMakeupEquipR6 = AvatarExperienceFlags.FFlagAXBlockMakeupEquipR6
local fFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local fFlagAXPendingLookModerationStatus = AvatarExperienceFlags.FFlagAXPendingLookModerationStatus
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local fFlagAXBlockUnavailableMakeupLookSelection = AvatarExperienceFlags.FFlagAXBlockUnavailableMakeupLookSelection
local module20 = require("@luauforge/deferred/gPc")

local inventoryItemAvailability = module7.Enums.InventoryItemAvailability

require("@luauforge/bundled/dMc")

local v5 = { "category", "subcategory", "taxonomyId" }

local function isOutfitPendingReview(p2): boolean
	return p2.moderationStatus == Enum.ModerationStatus.NotReviewed
		or p2.availabilityStatus == inventoryItemAvailability.PendingReview
end

local function isAssetPendingReview(p2, data): boolean
	if not data then
		return p2.availabilityStatus == inventoryItemAvailability.PendingReview
	end

	local creatingUniverseId = data.creatingUniverseId

	if creatingUniverseId ~= nil and string.len(creatingUniverseId) > 0 then
		return data.moderationStatus == Enum.ModerationStatus.NotReviewed
	end

	if data.outfitModerationStatus ~= nil then
		return data.outfitModerationStatus == Enum.ModerationStatus.NotReviewed
	end

	return p2.availabilityStatus == inventoryItemAvailability.PendingReview
end

local function getPendingItems(data, p2)
	local pendingItems = {}

	if not data.assets then
		return pendingItems
	end

	local v6 = data.moderationStatus == Enum.ModerationStatus.NotReviewed
		or data.availabilityStatus == inventoryItemAvailability.PendingReview

	for k, asset in data.assets do
		for k2, v7 in asset do
			local v8 = if p2 then p2[k2] else nil

			if not v6 then
				local v9

				if v8 then
					local creatingUniverseId = v8.creatingUniverseId

					if creatingUniverseId == nil or not (string.len(creatingUniverseId) > 0) then
						if v8.outfitModerationStatus == nil then
							v9 = v7.availabilityStatus == inventoryItemAvailability.PendingReview
						else
							v9 = v8.outfitModerationStatus == Enum.ModerationStatus.NotReviewed
						end
					else
						v9 = v8.moderationStatus == Enum.ModerationStatus.NotReviewed
					end
				else
					v9 = v7.availabilityStatus == inventoryItemAvailability.PendingReview
				end

				if not v9 then
					continue
				end
			end

			local v9 = { categoryLoc = module10.AssetTypeLocalized[k], itemName = 0 }
			local v10 = if v8 then v8.name else nil
			v9.itemName = v10 or ""
			table.insert(pendingItems, v9)
		end
	end

	return pendingItems
end

local function getOutfitAssetCount(p2)
	if not p2.assets then
		return 0
	end

	local count = 0

	for k, asset in p2.assets do
		for k2 in asset do
			count += 1
		end
	end

	return count
end

local function getOutfitCategoryLoc(p2): string
	if p2.outfitType == module10.OutfitTypes.Makeup then
		return "Feature.Avatar.Label.MakeupLooks"
	end

	return "Feature.Avatar.Label.Avatars"
end

local function isEntireOutfitPendingReview(data, p2): boolean
	if
		data.moderationStatus == Enum.ModerationStatus.NotReviewed
		or data.availabilityStatus == inventoryItemAvailability.PendingReview
	then
		return true
	end

	if p2 == nil or p2 == 0 then
		return false
	end

	local count

	if data.assets then
		count = 0

		for k, asset in data.assets do
			for k2 in asset do
				count += 1
			end
		end
	else
		count = 0
	end

	return p2 == count
end

local function getItemStatus(data, p2)
	if
		fFlagAXPendingLookModerationStatus
		and data
		and (p2 ~= nil and p2 > 0 or data.moderationStatus == Enum.ModerationStatus.NotReviewed or data.availabilityStatus == inventoryItemAvailability.PendingReview)
	then
		local v6 = { type = 0, iconType = "PendingModeration" }
		local v7

		if
			data.moderationStatus == Enum.ModerationStatus.NotReviewed
			or data.availabilityStatus == inventoryItemAvailability.PendingReview
		then
			v7 = true
		elseif p2 == nil or p2 == 0 then
			v7 = false
		else
			local count

			if data.assets then
				count = 0

				for k, asset in data.assets do
					for k2 in asset do
						count += 1
					end
				end
			else
				count = 0
			end

			v7 = p2 == count
		end

		v6.type = v7 and "placeholder" or "icon"
		return v6
	end

	if data and data.availabilityStatus == inventoryItemAvailability.Unavailable then
		return {
			type = "placeholder",
			iconType = fFlagAXModeratedItemIconUpdates and "Unavailable" or "Error"
		}
	end

	if
		data
		and data.availabilityStatus == inventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems
	then
		return { type = "icon", iconType = "Unavailable" }
	end

	if
		fFlagAXInventoryDurablesSupport
		and data
		and data.availabilityStatus == inventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
	then
		return { type = "icon", iconType = "Info" }
	end

	return nil
end

local function fn(p2)
	return p2.AvatarExperience.Common.AssetInfos
end

local function selectIsR6(p2): boolean
	return p2.AvatarExperience.AvatarEditor.Character.AvatarType == module10.AvatarType.R6
end

local module21 = require("@luauforge/bundled/dTM")

local function useAvatarTileProps(data, p2)
	local v6 = useAvatarRoute()
	local v7 = useNavigation()
	local v8 = useAdaptiveScrolling()
	local v9 = useDispatch()
	local v10 = if fFlagAXEnableExpiredUserLookCheckout then module8(module13) else nil
	local v11 = module8(module12)
	local v12 = module8(avatarExperienceAnalyticsService)
	local v13

	if fFlagAXModeratedItemsFlow or fFlagAXEnableExpiredUserLookCheckout then
		v13 = module8(module9)
	else
		v13 = nil
	end

	local v14 = ReactFocusNavigation.useFocusGuiObject()
	local v15 = Responsive.usePreferredInput()

	local v16 = useSelector(fn, getUseSelectorDeepEquals())

	local v17 = useSelector(React.useCallback(function(p3)
		if module18 then
			return p3.AvatarExperience.AvatarEditor.OutfitInfos[data.itemId]
		end

		return p3.AvatarExperience.AvatarEditor.OutfitInfos[data.itemId] or {}
	end, { data.itemId }), getUseSelectorDeepEquals())
	local v18

	if fFlagAXPendingLookModerationStatus then
		v18 = React.useMemo(function()
			if v17 then
				return getPendingItems(v17, v16)
			end

			return {}
		end, { v17, v16 })
	else
		v18 = nil
	end

	local v19 = fFlagAXPendingLookModerationStatus and v18 and #v18 or nil
	local v20 = fFlagAXPendingLookModerationStatus

	if v20 then
		if v17 == nil then
			v20 = false
		elseif
			v17.moderationStatus == Enum.ModerationStatus.NotReviewed
			or v17.availabilityStatus == inventoryItemAvailability.PendingReview
		then
			v20 = true
		elseif v19 == nil or v19 == 0 then
			v20 = false
		else
			local count

			if v17.assets then
				count = 0

				for k, asset in v17.assets do
					for k2 in asset do
						count += 1
					end
				end
			else
				count = 0
			end

			v20 = v19 == count
		end
	end

	local v21 = fFlagAXBlockUnavailableMakeupLookSelection

	if v21 then
		if v17 == nil or v17.outfitType ~= module10.OutfitTypes.Makeup then
			v21 = false
		elseif
			v17.availabilityStatus == inventoryItemAvailability.Unavailable
			or v17.moderationStatus == Enum.ModerationStatus.NotReviewed
			or v17.availabilityStatus == inventoryItemAvailability.PendingReview
		then
			v21 = true
		elseif v19 == nil or v19 == 0 then
			v21 = false
		else
			local count

			if v17.assets then
				count = 0

				for k, asset in v17.assets do
					for k2 in asset do
						count += 1
					end
				end
			else
				count = 0
			end

			v21 = v19 == count
		end
	end

	local v22 = React.useCallback(function(p3, p4)
		if v8 then
			if p3 then
				v8.setSelectedItemInstance(nil)
			else
				local current = p2.current

				if current and p4 then
					v8.setSelectedItemInstance(current)
				end
			end
		end

		if not p3 and p4 then
			v9(module16(v12, v6.opaque.name, fullView.None))
		end
	end, { v8, v9, v12, v6 })

	local v23 = React.useCallback(function()
		if v15 == Responsive.Input.Directional then
			v14(p2.current)
		end
	end, { v15, v14 })
	local v24

	if fFlagAXOutfitPageRevamp then
		v24 = React.useCallback(function()
			local v25 = { outfitId = data.itemId }

			v9(navigateWithLock(function()
				module21.closeFiltersAndItemDetails(v7)
				module21.closeTryOnManager(v7)
				v7.navigate(avatarScreen.OutfitDetails, v25)
			end))
		end, { data.itemId, v7, v9 })
	end

	local v25 = React.useCallback(function()
		v7.navigate(avatarScreen.EquipOutfitConfirmation, {
			outfitInfo = v17,
			onOverlayClosed = v23,
			onEquip = function(p3)
				v22(data.isSelected, p3 or false)
			end
		})
	end, { data.isSelected, v17, v23, v7, v22 })

	local v26 = React.useCallback(function(p3)
		local result = {}

		for k, asset in v17.assets do
			for k2, v27 in asset do
				local v28 = v16[k2]

				if v27.availabilityStatus ~= p3 then
					continue
				end

				local v29 = {
					categoryLoc = module10.AssetTypeLocalized[k],
					itemName = v28.name,
					itemId = 0,
					itemSubType = 0,
					order = 0
				}
				local v30 = if fFlagAXEnableExpiredUserLookCheckout then v28.id else nil
				v29.itemId = v30
				v29.itemSubType = if fFlagAXEnableExpiredUserLookCheckout then k else nil
				local v32 = if fFlagAXEnableExpiredUserLookCheckout then v27.order else nil
				v29.order = v32
				table.insert(result, v29)
			end
		end

		return result
	end, { v17, v16 })

	local v27 = if fFlagAXBlockMakeupEquipR6 then useSelector(selectIsR6) else nil
	local useCallback = React.useCallback
	local function fn2(p3)
		if module18 and not (v17 and v17.assets) then
			return
		end

		local function equip()
			local v28 = v9(module14({
				outfitInfo = v17,
				analytics = v11,
				navigation = v7,
				isSelected = data.isSelected
			}))

			v22(data.isSelected, v28 or false)
		end

		if fFlagAXEnableExpiredUserLookCheckout then
			local v28 = v26(inventoryItemAvailability.Expired)

			if defineFastFlag2 and not (#v28 > 0) then
				module21.closeExpiredUserLookActionBar(v7)
			else
				local navigate = v7.navigate
				local expiredUserLookActionBar = avatarScreen.ExpiredUserLookActionBar
				local v29 = {
					expiredItemCount = #v28 > 0 and #v28 or 0,
					expiredItems = 0
				}

				if not (#v28 > 0) then
					v28 = nil
				end

				v29.expiredItems = v28
				navigate(expiredUserLookActionBar, v29)
			end
		end

		if fFlagAXBlockMakeupEquipR6 and v27 and v17.outfitType == module10.OutfitTypes.Makeup then
			v9(navigateWithLock(function()
				v7.navigate(avatarScreen.R15UpgradePrompt, {
					bodyTextKey = "Feature.Avatar.Label.LayeredClothingR15Warning",
					onSwitchSelected = equip
				})
			end))
		elseif fFlagAXSlotAvatarThumbnailPromptFix or data.hasItemFromCurrentPageEquipped then
			local v28 = v9(module14({
				outfitInfo = v17,
				analytics = v11,
				navigation = v7,
				isSelected = data.isSelected
			}))

			v22(data.isSelected, v28 or false)
		else
			v9(navigateWithLock(v25))
		end
	end

	local isSelected = data.isSelected
	local hasItemFromCurrentPageEquipped = data.hasItemFromCurrentPageEquipped
	local v29 = if not fFlagAXSlotAvatarThumbnailPromptFix then v25 else nil
	local v31 = useCallback(fn2, {
		v17,
		isSelected,
		hasItemFromCurrentPageEquipped,
		v11,
		v7,
		v22,
		v29,
		if fFlagAXBlockMakeupEquipR6 then v27 else nil,
		v9,
		v26,
		v13,
		data.itemId
	})

	local function onActivatedWithUnavailableItems(onConfirm)
		v7.navigate(avatarScreen.ItemsUnavailablePrompt, {
			items = v26(inventoryItemAvailability.Unavailable),
			messageType = "UnavailableItems",
			onConfirm = onConfirm
		})
	end

	local function onActivatedWithRevokedItems(onConfirm)
		local filterOutfitAssetsWithStatus = module11.filterOutfitAssetsWithStatus(
			v17,
			inventoryItemAvailability.Revoked
		)
		v9(module15(v11, data.itemId, filterOutfitAssetsWithStatus, nil, v13))

		v7.navigate(avatarScreen.ItemsUnavailablePrompt, {
			items = v26(inventoryItemAvailability.Revoked),
			messageType = "RevokedItems",
			onConfirm = onConfirm
		})
	end

	local function onActivatedWithPartiallyExpiredItems(onConfirm)
		if fFlagAXEnableExpiredUserLookCheckout then
			local v32 = v26(inventoryItemAvailability.Expired)

			if #v32 > 0 then
				for k, v33 in v32 do
					v9(toggleTryOn(module10.ItemType.Asset, v33.itemSubType, v33.itemId, true, v33.order))

					v9(module17(v13, v10, v33.itemId, module10.ItemType.Asset))
				end

				v7.navigate(avatarScreen.ExpiredUserLookActionBar, {
					expiredItemCount = #v32,
					expiredItems = v32
				})
			end
		else
			local filterOutfitAssetsWithStatus = module11.filterOutfitAssetsWithStatus(
				v17,
				inventoryItemAvailability.Expired
			)
			v9(module15(v11, data.itemId, filterOutfitAssetsWithStatus, true, v13))

			v7.navigate(avatarScreen.ItemsUnavailablePrompt, {
				items = nil,
				messageType = "PartiallyExpiredItems",
				onConfirm = onConfirm
			})
		end
	end

	React.useEffect(function()
		if p2.current and v17 and (module18 or not Cryo.isEmpty(v17)) then
			local v32 = {
				itemId = data.itemId,
				itemType = "Bundle",
				surface = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
			}

			if data.impressionsTag then
				p2.current:SetAttribute(data.impressionsTag, data.itemId)
			end

			local v33 = organicEventImpressionsSchema[data.impressionsSchema]
			impressionsUtil.writeItemAttributes(v33, p2.current, v32)

			if fFlagAXUnifiedEventStrictPayloads then
				local gridInformation = data.gridInformation

				if gridInformation and defineFastFlag then
					addUnifiedEventLogging(p2, {
						action = unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
						itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE,
						organicLookType = unifiedEventLogEnums.MarketplaceLookType.LOOK_TYPE_AVATAR,
						itemId = data.itemId,
						gridPositionRow = gridInformation.row,
						gridPositionColumn = gridInformation.column
					}, { sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME })

					return
				end
			end

			local v36 = {
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
				itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE,
				organicLookType = 0,
				itemId = 0,
				gridPositionRow = 0,
				gridPositionColumn = 0
			}

			local v37 = if defineFastFlag then unifiedEventLogEnums.MarketplaceLookType.LOOK_TYPE_AVATAR else nil
			v36.organicLookType = v37

			v36.itemId = data.itemId
			local v38 = if data.gridInformation then data.gridInformation.row else nil
			v36.gridPositionRow = v38
			local v39 = if data.gridInformation then data.gridInformation.column else nil
			v36.gridPositionColumn = v39
			addUnifiedEventLogging(p2, v36, {
				sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
			})
		end
	end, { data.itemId, v17, data.gridInformation })

	if module20 then
		React.useEffect(function()
			local unifiedCategoryFields = data.unifiedCategoryFields
			local v32 = p2.current and v17 and (module18 or not Cryo.isEmpty(v17))
			local current = p2.current

			if v32 and current then
				for k, v33 in v5 do
					current:SetAttribute(unifiedEventLogConstants.ATTRIBUTE_PREFIX .. v33, nil)
				end
			end

			if v32 and unifiedCategoryFields then
				addUnifiedEventLogging(
					p2,
					{
						category = unifiedCategoryFields.category,
						subcategory = unifiedCategoryFields.subcategory,
						taxonomyId = unifiedCategoryFields.taxonomyId
					},
					{ sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME }
				)
			end
		end, { data.itemId, v17, data.unifiedCategoryFields })
	end

	local v32

	if fFlagAXModeratedItemsFlow then
		local availabilityStatus = v17 and v17.availabilityStatus
		local v33 = availabilityStatus == inventoryItemAvailability.Unavailable
			or availabilityStatus == inventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems
		local v34

		if fFlagAXInventoryDurablesSupport then
			v34 = availabilityStatus == inventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
		end

		if v33 then
			local v35 = v26(inventoryItemAvailability.Unavailable)
			local v36 = v26(inventoryItemAvailability.Revoked)
			local v37 = v35 and #v35 > 0
			local v38 = v36 and #v36 > 0

			v32 = function()
				if v37 and v38 then
					local function onConfirm()
						onActivatedWithRevokedItems(v31)
					end

					v7.navigate(avatarScreen.ItemsUnavailablePrompt, {
						items = v26(inventoryItemAvailability.Unavailable),
						messageType = "UnavailableItems",
						onConfirm = onConfirm
					})
				elseif v37 then
					v7.navigate(avatarScreen.ItemsUnavailablePrompt, {
						items = v26(inventoryItemAvailability.Unavailable),
						messageType = "UnavailableItems",
						onConfirm = v31
					})
				elseif v38 then
					onActivatedWithRevokedItems(v31)
				end
			end
		else
			v32 = fFlagAXInventoryDurablesSupport and v34 and function()
				v31()
				onActivatedWithPartiallyExpiredItems()
			end or v31
		end
	else
		v32 = v31
	end

	v32 = fFlagAXInventoryDurablesSupport
		and not fFlagAXModeratedItemsFlow
		and (v17 and v17.availabilityStatus) == inventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
		and function()
			v31()
			onActivatedWithPartiallyExpiredItems()
		end
		or v32

	local v33 = {
		item = v17,
		onActivated = (v20 or v21) and function()
			local v34 = if v19 == nil or not (v19 > 0) then {
				{
					categoryLoc = v17.outfitType == module10.OutfitTypes.Makeup and "Feature.Avatar.Label.MakeupLooks" or "Feature.Avatar.Label.Avatars",
					itemName = v17.name or ""
				}
			} else v18

			v7.navigate(avatarScreen.ItemsUnavailablePrompt, {
				items = v34,
				messageType = "UnavailableItems"
			})
		end or v32,
		isSelected = data.isSelected,
		itemId = data.itemId,
		index = data.index,
		itemWidth = data.itemWidth,
		hasItemFromCurrentPageEquipped = data.hasItemFromCurrentPageEquipped,
		impressionsTag = data.impressionsTag,
		squareAspectRatio = 0,
		outfitUpdateCounter = 0,
		itemStatus = 0,
		onThumbnailLoaded = 0,
		onDetailsButtonActivated = 0
	}
	local v34 = if module19() then data.squareAspectRatio else nil
	v33.squareAspectRatio = v34
	v33.outfitUpdateCounter = not (fFlagAXSlotAvatarThumbnailPromptFix and v17 and v17.updateCounter)
		and 0
		or v17.updateCounter

	v33.itemStatus = getItemStatus(v17, v19)
	local v35 = if fFlagAXEditorEnableThumbnailLatencyStore then data.onThumbnailLoaded else nil
	v33.onThumbnailLoaded = v35

	if fFlagAXOutfitPageRevamp then
		if v21 then
			v24 = nil
		end
	else
		v24 = nil
	end

	v33.onDetailsButtonActivated = v24
	return v33
end

return useAvatarTileProps
