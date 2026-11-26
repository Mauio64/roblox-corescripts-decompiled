local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/t")

local GiftModelUtils = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftModelUtils")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local interface = t.interface({
	giftId = GiftModelUtils.nonEmptyString,
	acceptGiftRequest = t.any,
	rejectGiftRequest = t.any
})

local function formatReceiverPreviewItem(data)
	local tbl, v5 = t.table(data)

	if not tbl then
		return nil, `item: {v5}`
	end

	local formatItem, v6 = GiftModelUtils.formatItem(data.item)

	if formatItem == nil then
		return nil, v6
	end

	return {
		item = formatItem,
		name = data.name or "",
		thumbnailUrl = data.thumbnailUrl or ""
	}
end

return {
	format = function(data)
		local v5, v6 = interface(data)

		if not v5 then
			return nil, v6
		end

		local formatGiftSenderInfo, v7 = GiftModelUtils.formatGiftSenderInfo(data.sender)

		if formatGiftSenderInfo == nil then
			return nil, v7
		end

		local formatList, v8 = GiftModelUtils.formatList("items", data.items, formatReceiverPreviewItem)

		if formatList == nil then
			return nil, v8
		end

		local formatUserRelationshipDetail, v9 = GiftModelUtils.formatUserRelationshipDetail(data.userRelationshipDetail)

		if formatUserRelationshipDetail == nil then
			return nil, v9
		end

		return {
			giftId = data.giftId,
			sender = formatGiftSenderInfo,
			items = formatList,
			userRelationshipDetail = formatUserRelationshipDetail,
			acceptGiftRequest = data.acceptGiftRequest,
			rejectGiftRequest = data.rejectGiftRequest
		}
	end
}
