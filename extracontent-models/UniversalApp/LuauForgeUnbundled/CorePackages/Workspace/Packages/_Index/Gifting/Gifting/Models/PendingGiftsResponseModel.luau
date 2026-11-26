local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/t")

local GiftModelUtils = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftModelUtils")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local interface = t.interface({ giftId = GiftModelUtils.nonEmptyString })

local function formatPendingGiftItem(p2)
	local tbl, v5 = t.table(p2)

	if not tbl then
		return nil, `item: {v5}`
	end

	local formatItem, v6 = GiftModelUtils.formatItem(p2.item)

	if formatItem == nil then
		return nil, v6
	end

	return {
		item = formatItem,
		thumbnailUrl = p2.thumbnailUrl or ""
	}
end

local function formatPendingGift(data)
	local v5, v6 = interface(data)

	if not v5 then
		return nil, `gift: {v6}`
	end

	local formatGiftSenderInfo, v7 = GiftModelUtils.formatGiftSenderInfo(data.sender)

	if formatGiftSenderInfo == nil then
		return nil, v7
	end

	local formatList, v8 = GiftModelUtils.formatList("items", data.items, formatPendingGiftItem)

	if formatList == nil then
		return nil, v8
	end

	return { giftId = data.giftId, sender = formatGiftSenderInfo, items = formatList }
end

return {
	format = function(p2)
		local formatList, v5 = GiftModelUtils.formatList("gifts", p2.gifts or {}, formatPendingGift)

		if formatList == nil then
			return nil, v5
		end

		return { gifts = formatList, nextCursor = p2.nextCursor }
	end
}
