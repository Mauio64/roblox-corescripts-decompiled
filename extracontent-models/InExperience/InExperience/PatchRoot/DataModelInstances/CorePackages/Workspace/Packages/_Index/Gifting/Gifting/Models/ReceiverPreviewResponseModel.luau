local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local t = require(parent.t)

local GiftModelUtils = require(Gifting.Models.GiftModelUtils)
require(Gifting.Types)

local interface = t.interface({
	giftId = GiftModelUtils.nonEmptyString,
	acceptGiftRequest = t.any,
	rejectGiftRequest = t.any
})

local function formatReceiverPreviewItem(data)
	local tbl, v = t.table(data)

	if not tbl then
		return nil, `item: {v}`
	end

	local formatItem, v2 = GiftModelUtils.formatItem(data.item)

	if formatItem == nil then
		return nil, v2
	end

	return {
		item = formatItem,
		name = data.name or "",
		thumbnailUrl = data.thumbnailUrl or ""
	}
end

return {
	format = function(self)
		local v, v2 = interface(self)

		if not v then
			return nil, v2
		end

		local formatGiftSenderInfo, v3 = GiftModelUtils.formatGiftSenderInfo(self.sender)

		if formatGiftSenderInfo == nil then
			return nil, v3
		end

		local formatList, v4 = GiftModelUtils.formatList("items", self.items, formatReceiverPreviewItem)

		if formatList == nil then
			return nil, v4
		end

		local formatUserRelationshipDetail, v5 = GiftModelUtils.formatUserRelationshipDetail(self.userRelationshipDetail)

		if formatUserRelationshipDetail == nil then
			return nil, v5
		end

		return {
			giftId = self.giftId,
			sender = formatGiftSenderInfo,
			items = formatList,
			userRelationshipDetail = formatUserRelationshipDetail,
			acceptGiftRequest = self.acceptGiftRequest,
			rejectGiftRequest = self.rejectGiftRequest
		}
	end
}
