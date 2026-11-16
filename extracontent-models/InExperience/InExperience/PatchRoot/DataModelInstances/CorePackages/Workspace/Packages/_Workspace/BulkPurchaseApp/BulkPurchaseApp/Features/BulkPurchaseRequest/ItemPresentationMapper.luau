local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
require(parent.Style)
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
require(parent.AvatarExperienceCommon)
local ItemStatusToItemStatusKey = require(BulkPurchaseApp.Enums.ItemStatusToItemStatusKey)

local FFlagBulkPurchaseEnablePurchaseOptions = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseEnablePurchaseOptions)

require(script.Parent.BulkPurchaseRequestItem)
require(script.Parent.BulkPurchaseRequestOwnedItem)
require(script.Parent.BulkPurchaseRequestUnpurchasableItem)

local function toCardPropsWithId(p, id: string) -- 3 equivalent calls inferred from this helper
	local clone = table.clone(p)
	clone.id = id
	return clone
end

local ItemPresentationMapper = {}

function ItemPresentationMapper.mapItemsToRowPresentation(items, object)
	local result = {}

	for _, item in items do
		local priceLineContent = {
			{ type = "price", price = item.cost }
		}

		if item.originalPrice then
			table.insert(priceLineContent, {
				type = "price",
				price = item.originalPrice,
				strikethrough = true
			})
		end

		if FFlagBulkPurchaseEnablePurchaseOptions and object and item.timedOptionDays and item.timedOptionDays > 0 then
			local timedOptionDays = item.timedOptionDays
			table.insert(priceLineContent, {
				type = "badge",
				text = object:Format(
					timedOptionDays == 1 and "Feature.Durables.ItemDetails.WearTimeOptions.Button.XDay" or "Feature.Durables.ItemDetails.WearTimeOptions.Button.XDays",
					{ num = tostring(timedOptionDays) }
				)
			})
		end

		table.insert(result, toCardPropsWithId({ -- inferred equivalent call
			presentationSlot = React.createElement(ItemCardThumbnail, { url = item.image }),
			title = item.name,
			priceLineContent = priceLineContent
		}, item.id))
	end

	return result
end

function ItemPresentationMapper.mapOwnedItemsToRowPresentation(items, colorStyle, p)
	local result = {}

	for _, item in items do
		local v = {
			type = "text",
			text = p.itemOwned:gsub("{.*}", (tostring(item.ownedCount))),
			colorStyle = colorStyle
		}

		table.insert(result, toCardPropsWithId({ -- inferred equivalent call
			presentationSlot = React.createElement(ItemCardThumbnail, { url = item.image }),
			title = item.name,
			priceLineContent = { v }
		}, item.id))
	end

	return result
end

function ItemPresentationMapper.mapUnpurchasableItemsToRowPresentation(items, p, p2, p3)
	local result = {}

	for _, item in items do
		local text = p[ItemStatusToItemStatusKey[item.status]]
		local colorStyle

		if item.status == Enum.MarketplaceItemPurchaseStatus.Success then
			colorStyle = p2
		else
			colorStyle = p3
		end

		table.insert(result, toCardPropsWithId({ -- inferred equivalent call
			presentationSlot = React.createElement(ItemCardThumbnail, { url = item.image }),
			title = item.name,
			priceLineContent = {
				{ type = "text", text = text, colorStyle = colorStyle }
			}
		}, item.id))
	end

	return result
end

return ItemPresentationMapper
