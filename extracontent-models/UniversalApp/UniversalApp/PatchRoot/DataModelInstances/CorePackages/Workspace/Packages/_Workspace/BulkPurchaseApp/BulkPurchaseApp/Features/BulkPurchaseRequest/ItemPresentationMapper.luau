local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)

require(BulkPurchaseAppParent.Style)

local ItemCardThumbnail = require(BulkPurchaseAppParent.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail

require(BulkPurchaseAppParent.AvatarExperienceCommon)

local ItemStatusToItemStatusKey = require(BulkPurchaseApp.Enums.ItemStatusToItemStatusKey)
local FFlagBulkPurchaseEnablePurchaseOptions = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseEnablePurchaseOptions)

require(script.Parent.BulkPurchaseRequestItem)
require(script.Parent.BulkPurchaseRequestOwnedItem)
require(script.Parent.BulkPurchaseRequestUnpurchasableItem)

local function toCardPropsWithId(p1, s1: string) -- line: 36
	local v10 = table.clone(p1)

	v10.id = s1

	return v10
end

return {
	mapItemsToRowPresentation = function(t1: {[any]: any}, t2: {[any]: any}?) -- line: 44
		-- upvalues: FFlagBulkPurchaseEnablePurchaseOptions (copy), React (copy), ItemCardThumbnail (copy)
		local t3 = {}

		for _, v15 in t1 do
			local t4 = {{
				type = "price",
				price = v15.cost
			}}

			if v15.originalPrice then
				table.insert(t4, {
					type = "price",
					strikethrough = true,
					price = v15.originalPrice
				})
			end

			if FFlagBulkPurchaseEnablePurchaseOptions and t2 and v15.timedOptionDays and v15.timedOptionDays > 0 then
				local timedOptionDays = v15.timedOptionDays
				local v18 = t2:Format(timedOptionDays ~= 1 and "Feature.Durables.ItemDetails.WearTimeOptions.Button.XDays" or "Feature.Durables.ItemDetails.WearTimeOptions.Button.XDay", {
					num = tostring(timedOptionDays)
				})

				table.insert(t4, {
					type = "badge",
					text = v18
				})
			end

			local t5 = {
				presentationSlot = React.createElement(ItemCardThumbnail, {
					url = v15.image
				}),
				title = v15.name,
				priceLineContent = t4
			}
			local id = v15.id
			local v21 = table.clone(t5)

			v21.id = id
			table.insert(t3, v21)
		end

		return t3
	end,
	mapOwnedItemsToRowPresentation = function(t6: {[any]: any}, p2, t7: {[any]: any}) -- line: 76
		-- upvalues: React (copy), ItemCardThumbnail (copy)
		local t8 = {}

		for _, v27 in t6 do
			local t9 = {
				type = "text",
				text = t7.itemOwned:gsub("{.*}", (tostring(v27.ownedCount))),
				colorStyle = p2
			}
			local t10 = {
				presentationSlot = React.createElement(ItemCardThumbnail, {
					url = v27.image
				}),
				title = v27.name,
				priceLineContent = { t9 }
			}
			local id = v27.id
			local v31 = table.clone(t10)

			v31.id = id
			table.insert(t8, v31)
		end

		return t8
	end,
	mapUnpurchasableItemsToRowPresentation = function(t11: {[any]: any}, t12: {[any]: any}, p3, p4) -- line: 98
		-- upvalues: ItemStatusToItemStatusKey (copy), React (copy), ItemCardThumbnail (copy)
		local t13 = {}

		for _, v38 in t11 do
			local v39 = t12[ItemStatusToItemStatusKey[v38.status]]
			local v40 = if v38.status ~= Enum.MarketplaceItemPurchaseStatus.Success then p4 else p3
			local t14 = {
				type = "text",
				text = v39,
				colorStyle = v40
			}
			local t15 = {
				presentationSlot = React.createElement(ItemCardThumbnail, {
					url = v38.image
				}),
				title = v38.name,
				priceLineContent = { t14 }
			}
			local id = v38.id
			local v44 = table.clone(t15)

			v44.id = id
			table.insert(t13, v44)
		end

		return t13
	end
}
