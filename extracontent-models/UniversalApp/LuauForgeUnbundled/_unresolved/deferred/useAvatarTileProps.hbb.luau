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
local module6 = require("@luauforge/bundled/dKU")
local module7 = require("@luauforge/bundled/fCn")

local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local module8 = require("@luauforge/bundled/eie")
local module9 = require("@luauforge/bundled/egx")

local module10 = require("@luauforge/bundled/dPN")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local module11 = require("@luauforge/bundled/fCI")
local module12 = require("@luauforge/bundled/gJz")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module13 = require("@luauforge/bundled/fDf")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module14 = require("@luauforge/bundled/gJM")
local module15 = require("@luauforge/deferred/hbc")
local module16 = require("@luauforge/bundled/gSD")
local module17 = require("@luauforge/bundled/fCd")
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

local module18 = require("@luauforge/deferred/hbe")
local module19 = require("@luauforge/bundled/dRs")

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
local module20 = require("@luauforge/deferred/hbf")

local inventoryItemAvailability = module7.Enums.InventoryItemAvailability

require("@luauforge/bundled/dPs")

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

local module21 = require("@luauforge/bundled/dXh")

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

	local v18 = useSelector(React.useCallback(function(p3)
		if module18 then
			return p3.AvatarExperience.AvatarEditor.OutfitInfos[data.itemId]
		end

		return p3.AvatarExperience.AvatarEditor.OutfitInfos[data.itemId] or {}
	end, { data.itemId }), getUseSelectorDeepEquals())
	local v19

	if fFlagAXPendingLookModerationStatus then
		v19 = React.useMemo(function()
			if v18 then
				return getPendingItems(v18, v16)
			end

			return {}
		end, { v18, v16 })
	else
		v19 = nil
	end

	local v20 = fFlagAXPendingLookModerationStatus and v19 and #v19 or nil
	local v21 = fFlagAXPendingLookModerationStatus

	if v21 then
		if v18 == nil then
			v21 = false
		elseif
			v18.moderationStatus == Enum.ModerationStatus.NotReviewed
			or v18.availabilityStatus == inventoryItemAvailability.PendingReview
		then
			v21 = true
		elseif v20 == nil or v20 == 0 then
			v21 = false
		else
			local count

			if v18.assets then
				count = 0

				for k, asset in v18.assets do
					for k2 in asset do
						count += 1
					end
				end
			else
				count = 0
			end

			v21 = v20 == count
		end
	end

	local v22 = fFlagAXBlockUnavailableMakeupLookSelection

	if v22 then
		if v18 == nil or v18.outfitType ~= module10.OutfitTypes.Makeup then
			v22 = false
		elseif
			v18.availabilityStatus == inventoryItemAvailability.Unavailable
			or v18.moderationStatus == Enum.ModerationStatus.NotReviewed
			or v18.availabilityStatus == inventoryItemAvailability.PendingReview
		then
			v22 = true
		elseif v20 == nil or v20 == 0 then
			v22 = false
		else
			local count

			if v18.assets then
				count = 0

				for k, asset in v18.assets do
					for k2 in asset do
						count += 1
					end
				end
			else
				count = 0
			end

			v22 = v20 == count
		end
	end

	local v23 = React.useCallback(function(p3, p4)
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

	local v24 = React.useCallback(function()
		if v15 == Responsive.Input.Directional then
			v14(p2.current)
		end
	end, { v15, v14 })
	local v25

	if fFlagAXOutfitPageRevamp then
		v25 = React.useCallback(function()
			local v26 = { outfitId = data.itemId }

			v9(navigateWithLock(function()
				module21.closeFiltersAndItemDetails(v7)
				module21.closeTryOnManager(v7)
				v7.navigate(avatarScreen.OutfitDetails, v26)
			end))
		end, { data.itemId, v7, v9 })
	end

	local v26 = React.useCallback(function()
		v7.navigate(avatarScreen.EquipOutfitConfirmation, {
			outfitInfo = v18,
			onOverlayClosed = v24,
			onEquip = function(p3)
				v23(data.isSelected, p3 or false)
			end
		})
	end, { data.isSelected, v18, v24, v7, v23 })

	local v27 = React.useCallback(function(p3)
		local result = {}

		for k, asset in v18.assets do
			for k2, v28 in asset do
				local v29 = v16[k2]

				if v28.availabilityStatus ~= p3 then
					continue
				end

				local v30 = {
					categoryLoc = module10.AssetTypeLocalized[k],
					itemName = v29.name,
					itemId = 0,
					itemSubType = 0,
					order = 0
				}
				local v31 = if fFlagAXEnableExpiredUserLookCheckout then v29.id else nil
				v30.itemId = v31
				v30.itemSubType = if fFlagAXEnableExpiredUserLookCheckout then k else nil
				local v33 = if fFlagAXEnableExpiredUserLookCheckout then v28.order else nil
				v30.order = v33
				table.insert(result, v30)
			end
		end

		return result
	end, { v18, v16 })

	local v28 = if fFlagAXBlockMakeupEquipR6 then useSelector(selectIsR6) else nil
	local useCallback = React.useCallback
	local function fn2(p3)
		if module18 and not (v18 and v18.assets) then
			return
		end

		local function equip()
			local v29 = v9(module14({
				outfitInfo = v18,
				analytics = v11,
				navigation = v7,
				isSelected = data.isSelected
			}))

			v23(data.isSelected, v29 or false)
		end

		if fFlagAXEnableExpiredUserLookCheckout then
			local v29 = v27(inventoryItemAvailability.Expired)

			if defineFastFlag2 and not (#v29 > 0) then
				module21.closeExpiredUserLookActionBar(v7)
			else
				local navigate = v7.navigate
				local expiredUserLookActionBar = avatarScreen.ExpiredUserLookActionBar
				local v30 = {
					expiredItemCount = #v29 > 0 and #v29 or 0,
					expiredItems = 0
				}

				if not (#v29 > 0) then
					v29 = nil
				end

				v30.expiredItems = v29
				navigate(expiredUserLookActionBar, v30)
			end
		end

		if fFlagAXBlockMakeupEquipR6 and v28 and v18.outfitType == module10.OutfitTypes.Makeup then
			v9(navigateWithLock(function()
				v7.navigate(avatarScreen.R15UpgradePrompt, {
					bodyTextKey = "Feature.Avatar.Label.LayeredClothingR15Warning",
					onSwitchSelected = equip
				})
			end))
		elseif fFlagAXSlotAvatarThumbnailPromptFix or data.hasItemFromCurrentPageEquipped then
			local v29 = v9(module14({
				outfitInfo = v18,
				analytics = v11,
				navigation = v7,
				isSelected = data.isSelected
			}))

			v23(data.isSelected, v29 or false)
		else
			v9(navigateWithLock(v26))
		end
	end

	local isSelected = data.isSelected
	local hasItemFromCurrentPageEquipped = data.hasItemFromCurrentPageEquipped
	local v30 = if not fFlagAXSlotAvatarThumbnailPromptFix then v26 else nil
	local v32 = useCallback(fn2, {
		v18,
		isSelected,
		hasItemFromCurrentPageEquipped,
		v11,
		v7,
		v23,
		v30,
		if fFlagAXBlockMakeupEquipR6 then v28 else nil,
		v9,
		v27,
		v13,
		data.itemId
	})

	local function onActivatedWithUnavailableItems(onConfirm)
		v7.navigate(avatarScreen.ItemsUnavailablePrompt, {
			items = v27(inventoryItemAvailability.Unavailable),
			messageType = "UnavailableItems",
			onConfirm = onConfirm
		})
	end

	local function onActivatedWithRevokedItems(onConfirm)
		local filterOutfitAssetsWithStatus = module11.filterOutfitAssetsWithStatus(
			v18,
			inventoryItemAvailability.Revoked
		)
		v9(module15(v11, data.itemId, filterOutfitAssetsWithStatus, nil, v13))

		v7.navigate(avatarScreen.ItemsUnavailablePrompt, {
			items = v27(inventoryItemAvailability.Revoked),
			messageType = "RevokedItems",
			onConfirm = onConfirm
		})
	end

	local function onActivatedWithPartiallyExpiredItems(onConfirm)
		if fFlagAXEnableExpiredUserLookCheckout then
			local v33 = v27(inventoryItemAvailability.Expired)

			if #v33 > 0 then
				for k, v34 in v33 do
					v9(toggleTryOn(module10.ItemType.Asset, v34.itemSubType, v34.itemId, true, v34.order))

					v9(module17(v13, v10, v34.itemId, module10.ItemType.Asset))
				end

				v7.navigate(avatarScreen.ExpiredUserLookActionBar, {
					expiredItemCount = #v33,
					expiredItems = v33
				})
			end
		else
			local filterOutfitAssetsWithStatus = module11.filterOutfitAssetsWithStatus(
				v18,
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
		if p2.current and v18 and (module18 or not Cryo.isEmpty(v18)) then
			local v33 = {
				itemId = data.itemId,
				itemType = "Bundle",
				surface = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
			}

			if data.impressionsTag then
				p2.current:SetAttribute(data.impressionsTag, data.itemId)
			end

			local v34 = organicEventImpressionsSchema[data.impressionsSchema]
			impressionsUtil.writeItemAttributes(v34, p2.current, v33)

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

			local v37 = {
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
				itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE,
				organicLookType = 0,
				itemId = 0,
				gridPositionRow = 0,
				gridPositionColumn = 0
			}

			local v38 = if defineFastFlag then unifiedEventLogEnums.MarketplaceLookType.LOOK_TYPE_AVATAR else nil
			v37.organicLookType = v38

			v37.itemId = data.itemId
			local v39 = if data.gridInformation then data.gridInformation.row else nil
			v37.gridPositionRow = v39
			local v40 = if data.gridInformation then data.gridInformation.column else nil
			v37.gridPositionColumn = v40
			addUnifiedEventLogging(p2, v37, {
				sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
			})
		end
	end, { data.itemId, v18, data.gridInformation })

	if module20 then
		React.useEffect(function()
			local unifiedCategoryFields = data.unifiedCategoryFields
			local v33 = p2.current and v18 and (module18 or not Cryo.isEmpty(v18))
			local current = p2.current

			if v33 and current then
				for k, v34 in v5 do
					current:SetAttribute(unifiedEventLogConstants.ATTRIBUTE_PREFIX .. v34, nil)
				end
			end

			if v33 and unifiedCategoryFields then
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
		end, { data.itemId, v18, data.unifiedCategoryFields })
	end

	local v33

	if fFlagAXModeratedItemsFlow then
		local availabilityStatus = v18 and v18.availabilityStatus
		local v34 = availabilityStatus == inventoryItemAvailability.Unavailable
			or availabilityStatus == inventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems
		local v35

		if fFlagAXInventoryDurablesSupport then
			v35 = availabilityStatus == inventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
		end

		if v34 then
			local v36 = v27(inventoryItemAvailability.Unavailable)
			local v37 = v27(inventoryItemAvailability.Revoked)
			local v38 = v36 and #v36 > 0
			local v39 = v37 and #v37 > 0

			v33 = function()
				if v38 and v39 then
					local function onConfirm()
						onActivatedWithRevokedItems(v32)
					end

					v7.navigate(avatarScreen.ItemsUnavailablePrompt, {
						items = v27(inventoryItemAvailability.Unavailable),
						messageType = "UnavailableItems",
						onConfirm = onConfirm
					})
				elseif v38 then
					v7.navigate(avatarScreen.ItemsUnavailablePrompt, {
						items = v27(inventoryItemAvailability.Unavailable),
						messageType = "UnavailableItems",
						onConfirm = v32
					})
				elseif v39 then
					onActivatedWithRevokedItems(v32)
				end
			end
		else
			v33 = fFlagAXInventoryDurablesSupport and v35 and function()
				v32()
				onActivatedWithPartiallyExpiredItems()
			end or v32
		end
	else
		v33 = v32
	end

	v33 = fFlagAXInventoryDurablesSupport
		and not fFlagAXModeratedItemsFlow
		and (v18 and v18.availabilityStatus) == inventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
		and function()
			v32()
			onActivatedWithPartiallyExpiredItems()
		end
		or v33

	local v34 = {
		item = v18,
		onActivated = (v21 or v22) and function()
			local v35 = if v20 == nil or not (v20 > 0) then {
				{
					categoryLoc = v18.outfitType == module10.OutfitTypes.Makeup and "Feature.Avatar.Label.MakeupLooks" or "Feature.Avatar.Label.Avatars",
					itemName = v18.name or ""
				}
			} else v19

			v7.navigate(avatarScreen.ItemsUnavailablePrompt, {
				items = v35,
				messageType = "UnavailableItems"
			})
		end or v33,
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
	local v35 = if module19() then data.squareAspectRatio else nil
	v34.squareAspectRatio = v35
	v34.outfitUpdateCounter = not (fFlagAXSlotAvatarThumbnailPromptFix and v18 and v18.updateCounter)
		and 0
		or v18.updateCounter

	v34.itemStatus = getItemStatus(v18, v20)
	local v36 = if fFlagAXEditorEnableThumbnailLatencyStore then data.onThumbnailLoaded else nil
	v34.onThumbnailLoaded = v36

	if fFlagAXOutfitPageRevamp then
		if v22 then
			v25 = nil
		end
	else
		v25 = nil
	end

	v34.onDetailsButtonActivated = v25
	return v34
end

return useAvatarTileProps
