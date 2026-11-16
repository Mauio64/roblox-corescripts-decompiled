local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local t = require(parent.t)

local GiftModelUtils = require(Gifting.Models.GiftModelUtils)
require(Gifting.Types)

local interface = t.interface({ giftId = GiftModelUtils.nonEmptyString })

local function formatPendingGiftItem(p)
	local tbl, v = t.table(p)

	if not tbl then
		return nil, `item: {v}`
	end

	local formatItem, v2 = GiftModelUtils.formatItem(p.item)

	if formatItem == nil then
		return nil, v2
	end

	return {
		item = formatItem,
		thumbnailUrl = p.thumbnailUrl or ""
	}
end

local function formatPendingGift(data)
	local v, v2 = interface(data)

	if not v then
		return nil, `gift: {v2}`
	end

	local formatGiftSenderInfo, v3 = GiftModelUtils.formatGiftSenderInfo(data.sender)

	if formatGiftSenderInfo == nil then
		return nil, v3
	end

	local formatList, v4 = GiftModelUtils.formatList("items", data.items, formatPendingGiftItem)

	if formatList == nil then
		return nil, v4
	end

	return { giftId = data.giftId, sender = formatGiftSenderInfo, items = formatList }
end

return {
	format = function(self)
		local formatList, v = GiftModelUtils.formatList("gifts", self.gifts or {}, formatPendingGift)

		if formatList == nil then
			return nil, v
		end

		return { gifts = formatList, nextCursor = self.nextCursor }
	end
}
