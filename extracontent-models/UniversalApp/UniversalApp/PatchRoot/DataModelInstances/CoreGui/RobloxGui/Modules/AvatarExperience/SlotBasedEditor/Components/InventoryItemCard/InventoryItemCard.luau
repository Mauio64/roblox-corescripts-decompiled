local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local CatalogItemCardItemInfoEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardItemInfoEnum
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
local InventoryItemType = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Enums.InventoryItemType
local getRbxthumbWithTypeSizeAndOptions = require(CorePackages.Workspace.Packages.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local addUnifiedEventLogging = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).addUnifiedEventLogging
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local UnifiedEventLogConstants = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogConstants
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local v18 = game:DefineFastFlag("AXNoShimmerImpressions", false)
local FFlagAXBackgroundsInOutfitThumbnails = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXBackgroundsInOutfitThumbnails

local function InventoryItemCard(t1: {[any]: any}) -- line: 54
	-- upvalues: useLocalization (copy), React (copy), v18 (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), InventoryItemType (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogConstants (copy), FFlagAXBackgroundsInOutfitThumbnails (copy), getRbxthumbWithTypeSizeAndOptions (copy), CatalogItemCard (copy), CatalogItemCardItemInfoEnum (copy), Foundation (copy), ItemCardThumbnail (copy), FFlagAXInventoryDurablesSupport (copy)
	local v22 = useLocalization({
		details = "Feature.Avatar.Label.DetailsButton"
	})
	local u23 = React.useRef(nil)

	React.useEffect(function() -- line: 62
		-- upvalues: v18 (copy), t1 (copy), addUnifiedEventLogging (copy), u23 (ref), UnifiedEventLogEnums (copy), InventoryItemType (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogConstants (copy)
		if v18 and (not t1.itemId or not t1.assetType) then
			return
		end

		addUnifiedEventLogging(u23, {
			action = if not t1.isSelected then UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED else UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED,
			itemId = t1.itemId,
			itemType = if t1.inventoryItemType ~= InventoryItemType.Asset then UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE else UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET,
			gridPositionRow = if not t1.gridInformation then nil else t1.gridInformation.row,
			gridPositionColumn = if not t1.gridInformation then nil else t1.gridInformation.column,
			assetType = t1.assetType
		}, {
			hasDeferredActions = not FFlagAXMISEnableMultiShoppingUnifiedEvents or nil,
			sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
		})
	end, {
		t1.isSelected,
		t1.gridInformation,
		if not v18 then nil else t1.itemId,
		if not v18 then nil else t1.assetType,
		if not v18 then nil else t1.inventoryItemType
	})

	local v24 = if t1.inventoryItemType ~= InventoryItemType.Asset then if t1.inventoryItemType ~= InventoryItemType.Outfit then nil else "Outfit" else "Asset"
	local v25 = if not FFlagAXBackgroundsInOutfitThumbnails then `rbxthumb://type={ v24 }&id={ t1.itemId }&w=150&h=150` else if not v24 then nil else getRbxthumbWithTypeSizeAndOptions(t1.itemId, v24, 150)

	if t1.moderationStatus and v25 then
		v25 ..= "&filters=" .. (t1.updateCounter or 0)
	end

	return React.createElement(CatalogItemCard, {
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		isSelected = t1.isSelected,
		title = if t1.hideName then nil else t1.itemName,
		itemInfo = if not t1.showDynamicHeadIcon then nil else CatalogItemCardItemInfoEnum.DynamicHead,
		onActivated = t1.onActivated,
		overlayButtonText = v22.details,
		onOverlayButtonActivated = t1.onDetailsButtonActivated,
		ref = u23,
		presentationSlot = React.createElement(Foundation.View, {
			tag = `size-full clip radius-medium { t1.impressionsTag }`,
			ref = t1.thumbnailRef
		}, {
			Thumbnail = v24 and React.createElement(ItemCardThumbnail, {
				url = v25
			})
		}),
		itemStatus = t1.itemStatus,
		expirationTime = if not FFlagAXInventoryDurablesSupport then nil else t1.expirationTime
	})
end

return InventoryItemCard
