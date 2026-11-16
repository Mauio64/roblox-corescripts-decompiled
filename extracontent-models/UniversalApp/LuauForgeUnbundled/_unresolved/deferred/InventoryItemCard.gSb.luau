local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module3 = require("@luauforge/deferred/gQI")
local module4 = require("@luauforge/deferred/gkN")
local catalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = module4.ItemCardComponents.ItemCardThumbnail
local inventoryItemType = require("@luauforge/bundled/fuM").Enums.InventoryItemType
local getRbxthumbWithTypeSizeAndOptions = require("@luauforge/bundled/cgr").Utils.getRbxthumbWithTypeSizeAndOptions
local addUnifiedEventLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").addUnifiedEventLogging
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local unifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogConstants
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXBackgroundGenerationAnalytics = AvatarExperienceFlags.FFlagAXBackgroundGenerationAnalytics
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXEditorEnableThumbnailLatencyStore = AvatarExperienceFlags.FFlagAXEditorEnableThumbnailLatencyStore
local fFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local module5 = require("@luauforge/deferred/gPc")

local fFlagAXBackgroundsInOutfitThumbnails = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXBackgroundsInOutfitThumbnails
local backgroundsPlusAnalytics = module3.BackgroundsPlusAnalytics
local entrySource = backgroundsPlusAnalytics.EntrySource

local v5 = {
	"assetType",
	"bundleType",
	"organicLookType",
	"category",
	"subcategory",
	"taxonomyId"
}

local function mergeTagFields(p2, p3, p4)
	return Cryo.Dictionary.join(p3, p2, p4)
end

local function addStrictUnifiedEventLogging(ref, props, unifiedCategoryFields): boolean
	local itemId = props.itemId
	local gridInformation = props.gridInformation
	local v6

	if props.inventoryItemType == inventoryItemType.Asset then
		v6 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
	else
		v6 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
	end

	local bundleType = if module5 then props.bundleType else nil
	local v7 = if bundleType ~= nil then tonumber(bundleType) else nil
	local organicLookType = if module5 then props.organicLookType else nil

	local category = if module5 and unifiedCategoryFields then unifiedCategoryFields.category else nil

	local subcategory = if module5 and unifiedCategoryFields then unifiedCategoryFields.subcategory else nil

	local taxonomyId = if module5 and unifiedCategoryFields then unifiedCategoryFields.taxonomyId else nil

	local v8 = {
		hasDeferredActions = not fFlagAXMISEnableMultiShoppingUnifiedEvents or nil,
		sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME,
		skipTapDetection = 0
	}
	local v9 = if fFlagAXBackgroundGenerationAnalytics then props.isPlusUpsellTarget == true else nil
	v8.skipTapDetection = v9

	local assetType = props.assetType

	local v10 = assetType and { assetType = assetType }
		or organicLookType and { organicLookType = organicLookType }
		or v7 and { bundleType = v7 }
		or nil
	local v11

	if fFlagAXBackgroundGenerationAnalytics and props.isPlusUpsellTarget then
		v11 = {
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			gridPositionRow = 0,
			gridPositionColumn = 0
		}
		local v12 = if gridInformation then gridInformation.row else nil
		v11.gridPositionRow = v12
		local v13 = if gridInformation then gridInformation.column else nil
		v11.gridPositionColumn = v13
	elseif gridInformation then
		v11 = { action = 0, gridPositionRow = 0, gridPositionColumn = 0 }
		local v12 = if props.isSelected then unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED else unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED
		v11.action = v12

		v11.gridPositionRow = gridInformation.row
		v11.gridPositionColumn = gridInformation.column
	end

	if not itemId or not v10 or not v11 or bundleType ~= nil and v7 == nil then
		return false
	end

	addUnifiedEventLogging(ref, Cryo.Dictionary.join({
		itemId = itemId,
		itemType = v6,
		assetType = assetType,
		bundleType = v7,
		organicLookType = organicLookType,
		category = category,
		subcategory = subcategory,
		taxonomyId = taxonomyId
	}, v11, v10), v8)

	return true
end

local function InventoryItemCard(props)
	local v6 = useLocalization({ details = "Feature.Avatar.Label.DetailsButton" })

	local ref = React.useRef(nil)
	local useEffect = React.useEffect
	local function fn()
		local current

		if fFlagAXBackgroundGenerationAnalytics then
			current = ref.current

			if current then
				backgroundsPlusAnalytics.setUpsellTargetAttributes(current, nil, nil)
			end
		end

		local unifiedCategoryFields, v7

		if module5 then
			unifiedCategoryFields = props.unifiedCategoryFields

			if props.itemId == nil or props.inventoryItemType ~= inventoryItemType.Outfit then
				v7 = false
			else
				v7 = props.bundleType ~= nil or props.organicLookType ~= nil
			end
		end

		if module5 and v7 or props.itemId and props.assetType then
			if module5 and ref.current then
				for k, v8 in v5 do
					ref.current:SetAttribute(unifiedEventLogConstants.ATTRIBUTE_PREFIX .. v8, nil)
				end
			end

			if
				fFlagAXUnifiedEventStrictPayloads
				and addStrictUnifiedEventLogging(ref, props, unifiedCategoryFields)
			then
				if fFlagAXBackgroundGenerationAnalytics and current then
					local setUpsellTargetAttributes = backgroundsPlusAnalytics.setUpsellTargetAttributes

					local inventoryExclusiveTile = if props.isPlusUpsellTarget then entrySource.InventoryExclusiveTile else nil
					local v8 = if props.isPlusUpsellTarget then props.itemId else nil
					setUpsellTargetAttributes(current, inventoryExclusiveTile, v8)
				end
			else
				local v11

				if fFlagAXBackgroundGenerationAnalytics and props.isPlusUpsellTarget then
					v11 = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK
				elseif props.isSelected then
					v11 = unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED
				else
					v11 = unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED
				end

				local v10 = {
					action = v11,
					itemId = props.itemId,
					itemType = 0,
					gridPositionRow = 0,
					gridPositionColumn = 0,
					assetType = 0,
					bundleType = 0,
					organicLookType = 0,
					category = 0,
					subcategory = 0,
					taxonomyId = 0
				}
				local v12 = if props.inventoryItemType == inventoryItemType.Asset then unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET else unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
				v10.itemType = v12

				local v13 = if props.gridInformation then props.gridInformation.row else nil
				v10.gridPositionRow = v13
				local v14 = if props.gridInformation then props.gridInformation.column else nil
				v10.gridPositionColumn = v14
				v10.assetType = props.assetType
				local v15 = if module5 then props.bundleType else nil
				v10.bundleType = v15
				local v16 = if module5 then props.organicLookType else nil
				v10.organicLookType = v16

				local v17 = if module5 and unifiedCategoryFields then unifiedCategoryFields.category else nil
				v10.category = v17

				local v18 = if module5 and unifiedCategoryFields then unifiedCategoryFields.subcategory else nil
				v10.subcategory = v18

				local v19 = if module5 and unifiedCategoryFields then unifiedCategoryFields.taxonomyId else nil
				v10.taxonomyId = v19

				local v20 = {
					hasDeferredActions = not fFlagAXMISEnableMultiShoppingUnifiedEvents or nil,
					sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME,
					skipTapDetection = 0
				}

				local v21 = if fFlagAXBackgroundGenerationAnalytics then props.isPlusUpsellTarget == true else nil
				v20.skipTapDetection = v21
				addUnifiedEventLogging(ref, v10, v20)

				if fFlagAXBackgroundGenerationAnalytics and current then
					local setUpsellTargetAttributes = backgroundsPlusAnalytics.setUpsellTargetAttributes

					local inventoryExclusiveTile = if props.isPlusUpsellTarget then entrySource.InventoryExclusiveTile else nil
					local v22 = if props.isPlusUpsellTarget then props.itemId else nil
					setUpsellTargetAttributes(current, inventoryExclusiveTile, v22)
				end
			end
		elseif fFlagAXBackgroundGenerationAnalytics and current then
			current:SetAttribute(unifiedEventLogConstants.SKIP_TAP_DETECTION, nil)
		end
	end

	local isSelected = props.isSelected
	local gridInformation = props.gridInformation
	local itemId = props.itemId
	local assetType = props.assetType
	local inventoryItemType2 = props.inventoryItemType
	local isPlusUpsellTarget = if fFlagAXBackgroundGenerationAnalytics then props.isPlusUpsellTarget else nil
	local bundleType = if module5 then props.bundleType else nil
	local organicLookType = if module5 then props.organicLookType else nil
	local category

	if module5 and props.unifiedCategoryFields then
		category = props.unifiedCategoryFields.category
	end

	local subcategory

	if module5 and props.unifiedCategoryFields then
		subcategory = props.unifiedCategoryFields.subcategory
	end

	local v8 = if module5 and props.unifiedCategoryFields then props.unifiedCategoryFields.taxonomyId else nil
	useEffect(fn, {
		isSelected,
		gridInformation,
		itemId,
		assetType,
		inventoryItemType2,
		isPlusUpsellTarget,
		bundleType,
		organicLookType,
		category,
		subcategory,
		v8
	})

	local v9 = props.inventoryItemType == inventoryItemType.Asset and "Asset"
		or props.inventoryItemType == inventoryItemType.Outfit and "Outfit"
		or nil
	local v10

	if fFlagAXBackgroundsInOutfitThumbnails then
		if v9 then
			v10 = getRbxthumbWithTypeSizeAndOptions(props.itemId, v9, 150)
		end
	else
		v10 = `rbxthumb://type={v9}&id={props.itemId}&w=150&h=150`
	end

	if props.moderationStatus and v10 then
		v10 ..= "&filters=" .. (props.updateCounter or 0)
	end

	local createElement = React.createElement
	local v12 = {
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		isSelected = props.isSelected,
		title = 0,
		onActivated = 0,
		overlayButtonText = 0,
		onOverlayButtonActivated = 0,
		ref = 0,
		presentationSlot = 0,
		itemStatus = 0,
		itemLicensingInfo = 0,
		expirationTime = 0
	}
	local v13 = if not props.hideName then props.itemName else nil
	v12.title = v13
	v12.onActivated = props.onActivated
	v12.overlayButtonText = v6.details
	v12.onOverlayButtonActivated = props.onDetailsButtonActivated
	v12.ref = ref
	local createElement2 = React.createElement
	local view = Foundation.View
	local v14 = {
		tag = `size-full clip radius-medium {props.impressionsTag}`,
		ref = props.thumbnailRef
	}

	if v9 then
		local createElement3 = React.createElement

		local v18 = if fFlagAXEditorEnableThumbnailLatencyStore then props.onThumbnailLoaded else nil
		v9 = createElement3(itemCardThumbnail, { url = v10, onLoaded = v18 })
	end

	v12.presentationSlot = createElement2(view, v14, { Thumbnail = v9 })

	v12.itemStatus = props.itemStatus
	local v16 = if fFlagAXMarketplaceLicensingItemCards then props.itemLicensingInfo else nil
	v12.itemLicensingInfo = v16
	local v17 = if fFlagAXInventoryDurablesSupport then props.expirationTime else nil
	v12.expirationTime = v17
	return createElement(catalogItemCard, v12)
end

return InventoryItemCard
