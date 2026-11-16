local module = require("@luauforge/bundled/dPU")
require("@luauforge/bundled/dQa")
local module2 = require("@luauforge/bundled/dQg")
local module3 = require("@luauforge/bundled/dQS")
local module4 = require("@luauforge/bundled/dRq")
local fFlagAXUnifiedEventStrictPayloads = require("@luauforge/bundled/dPZ").FFlagAXUnifiedEventStrictPayloads
local fFlagAXSduiCatalogItemTypeIds = require("@luauforge/bundled/dPZ").FFlagAXSduiCatalogItemTypeIds

local module5 = require("@luauforge/bundled/dRC")

local getUnifiedEventSubType = require("@luauforge/bundled/dQR").getUnifiedEventSubType
require("@luauforge/bundled/dRD")

local catalogItemCard = module3.Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = module4.ItemCardComponents.ItemCardThumbnail
local unifiedEventLogEnums = module2.UnifiedEventLogEnums
local getMarketplaceUnifiedItemType = module2.Utils.getMarketplaceUnifiedItemType

local v5 = { Tall = 0.7, Square = 1 }

local v6 = { Asset = "Asset", Bundle = "BundleThumbnail", Look = "Look" }

local v7 = { isSelected = false, sessionTagName = 0 }

local v8 = if fFlagAXUnifiedEventStrictPayloads then module2.UnifiedEventLogConstants.L2_SESSION_TAG_NAME else nil
v7.sessionTagName = v8

local v9 = { "surface" }

local function hasResolvedItemId(p2): boolean
	return p2.itemId ~= nil
end

local function toTagFields(data)
	local itemPosition = tonumber(data.itemPosition)
	local itemsPerRow = tonumber(data.itemsPerRow)
	local clone = table.clone(data)
	clone.surface = tonumber(data.surface)
	clone.itemId = tostring(data.itemId)
	clone.itemPosition = itemPosition
	clone.organicItemPrice = tonumber(data.organicItemPrice)
	local v10 = tonumber(data.gridPositionRow)

	if not v10 then
		if itemPosition and itemsPerRow and itemsPerRow > 0 then
			v10 = math.ceil(itemPosition / itemsPerRow)
		else
			v10 = itemPosition and 1 or nil
		end
	end

	clone.gridPositionRow = v10

	local v11 = tonumber(data.gridPositionColumn)

	if not v11 then
		if itemPosition and itemsPerRow and itemsPerRow > 0 then
			v11 = (itemPosition - 1) % itemsPerRow + 1
		else
			v11 = itemPosition
		end
	end

	clone.gridPositionColumn = v11

	if fFlagAXSduiCatalogItemTypeIds then
		clone.assetType = getUnifiedEventSubType(data.assetType, "Asset")
		clone.bundleType = getUnifiedEventSubType(data.bundleType, "Bundle")
	end

	return clone
end

local function getHeaderAspectRatio(p2, p3)
	local thumbnailAspectRatio = if p2 then p2.thumbnailAspectRatio else nil

	if thumbnailAspectRatio ~= nil then
		local v10 = v5[thumbnailAspectRatio] or tonumber(thumbnailAspectRatio)

		if v10 ~= nil and v10 > 0 then
			return v10
		end
	end

	if p3 == "Look" then
		return 0.7
	end

	return 1
end

local function getThumbnailUrl(p2, p3, p4)
	local v10 = v6[p3]

	if v10 == nil or p2 == nil or p2 == "" or p2 == "0" then
		return nil
	end

	return `rbxthumb://type={v10}&id={p2}&{p3 == "Look" and p4 < 1 and "w=300&h=450" or "w=150&h=150"}`
end

local function getPriceLineContent(price, priceText)
	if priceText ~= nil and priceText ~= "" then
		return { type = "text", text = priceText }
	end

	local v10 = tonumber(price)

	if v10 == nil then
		return nil
	end

	return { type = "price", price = v10 }
end

local function SduiCatalogItemCard(props)
	local ref = module.useRef(nil)

	local v10 = {
		action = unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
		itemType = getMarketplaceUnifiedItemType(props.itemType)
	}

	module5(
		ref,
		props.analyticsContext,
		hasResolvedItemId,
		v10,
		v7,
		v9,
		if fFlagAXUnifiedEventStrictPayloads then toTagFields else nil
	)

	if props.visible == false then
		return nil
	end

	local cardStyle = props.cardStyle
	local itemType = props.itemType
	local thumbnailAspectRatio = if cardStyle then cardStyle.thumbnailAspectRatio else nil
	local v16

	if thumbnailAspectRatio == nil then
		v16 = itemType == "Look" and 0.7 or 1
	else
		v16 = v5[thumbnailAspectRatio] or tonumber(thumbnailAspectRatio)

		if v16 == nil or not (v16 > 0) then
			v16 = itemType == "Look" and 0.7 or 1
		end
	end

	local itemId = props.itemId
	local itemType2 = props.itemType
	local v17 = v6[itemType2]
	local v18

	if not (v17 == nil or itemId == nil or itemId == "" or itemId == "0") then
		v18 = `rbxthumb://type={v17}&id={itemId}&{itemType2 == "Look" and v16 < 1 and "w=300&h=450" or "w=150&h=150"}`
	end

	local createElement = module.createElement
	local v20 = {
		ref = ref,
		onActivated = props.onActivated,
		isDisabled = props.isDisabled,
		headerAspectRatio = v16,
		presentationSlot = 0,
		priceLineContent = 0,
		creator = 0,
		title = 0,
		Size = 0,
		AutomaticSize = 0,
		LayoutOrder = 0
	}

	local v21 = if v18 then module.createElement(itemCardThumbnail, { url = v18 }) else nil
	v20.presentationSlot = v21

	v20.priceLineContent = getPriceLineContent(props.price, props.priceText)
	v20.creator = props.creatorName
		and { name = props.creatorName, verified = props.creatorHasVerifiedBadge }
		or nil

	v20.title = props.title

	v20.Size = props.size or UDim2.fromScale(1, 0)
	v20.AutomaticSize = Enum.AutomaticSize.Y
	v20.LayoutOrder = props.layoutOrder
	return createElement(catalogItemCard, v20)
end

return module.memo(SduiCatalogItemCard)
