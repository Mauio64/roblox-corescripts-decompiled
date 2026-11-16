local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/t")

local GiftModelUtils = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftModelUtils")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local interface = t.interface({ priceInRobux = t.number })

local interface2 = t.interface({
	robuxDiscountAmount = t.number,
	robuxDiscountPercentage = t.number
})

local interface3 = t.interface({
	originalPrice = t.number,
	totalDiscountPercentage = t.number,
	totalDiscountAmount = t.number
})

local interface4 = t.interface({ userId = t.number })

local interface5 = t.interface({
	remaining = t.number,
	granted = t.number,
	startTimeMs = t.number,
	endTimeMs = t.number
})

local interface6 = t.interface({
	purchaseGiftRequest = t.any,
	totalPriceInRobux = t.number,
	senderRobuxBalance = t.number
})

local function formatItemDetail(data)
	local v5, v6 = interface(data)

	if not v5 then
		return nil, `item: {v6}`
	end

	local formatItem, v7 = GiftModelUtils.formatItem(data.item)

	if formatItem == nil then
		return nil, v7
	end

	return {
		item = formatItem,
		name = data.name or "",
		thumbnailUrl = data.thumbnailUrl or "",
		priceInRobux = data.priceInRobux
	}
end

local function formatDiscountDetail(data)
	local v5, v6 = interface2(data)

	if v5 then
		return {
			robuxDiscountAmount = data.robuxDiscountAmount,
			robuxDiscountPercentage = data.robuxDiscountPercentage,
			discountCampaign = data.discountCampaign or "",
			localizedDiscountAttribution = data.localizedDiscountAttribution or ""
		}
	end

	return nil, `discount: {v6}`
end

local function formatDiscountInformation(discountInformation)
	local v5, v6 = interface3(discountInformation)

	if not v5 then
		return nil, `discountInformation: {v6}`
	end

	local formatList, v7 = GiftModelUtils.formatList(
		"discounts",
		discountInformation.discounts or {},
		formatDiscountDetail
	)

	if formatList == nil then
		return nil, v7
	end

	return {
		originalPrice = discountInformation.originalPrice,
		totalDiscountPercentage = discountInformation.totalDiscountPercentage,
		totalDiscountAmount = discountInformation.totalDiscountAmount,
		discounts = formatList
	}
end

local function formatRecipientInfo(data)
	local v5, v6 = interface4(data)

	if v5 then
		return {
			userId = data.userId,
			displayName = data.displayName or "",
			thumbnailUrl = data.thumbnailUrl or ""
		}
	end

	return nil, `recipient: {v6}`
end

local function formatFreeAllowance(data)
	local v5, v6 = interface5(data)

	if v5 then
		return {
			remaining = data.remaining,
			granted = data.granted,
			startTimeMs = data.startTimeMs,
			endTimeMs = data.endTimeMs
		}
	end

	return nil, `freeAllowance: {v6}`
end

return {
	format = function(data)
		local v5, v6 = interface6(data)

		if not v5 then
			return nil, v6
		end

		local formatList, v7 = GiftModelUtils.formatList("items", data.items, formatItemDetail)

		if formatList == nil then
			return nil, v7
		end

		local recipient = data.recipient
		local v8, v9 = interface4(recipient)
		local v10, v11

		if v8 then
			v10 = {
				userId = recipient.userId,
				displayName = recipient.displayName or "",
				thumbnailUrl = recipient.thumbnailUrl or ""
			}
		else
			v11 = `recipient: {v9}`
		end

		if v10 == nil then
			return nil, v11
		end

		local formatUserRelationshipDetail, v12 = GiftModelUtils.formatUserRelationshipDetail(data.userRelationshipDetail)

		if formatUserRelationshipDetail == nil then
			return nil, v12
		end

		local v13

		if data.discountInformation ~= nil then
			local v14
			v13, v14 = formatDiscountInformation(data.discountInformation)

			if v13 == nil then
				return nil, v14
			end
		end

		local v14

		if data.freeAllowance == nil then
			return {
				purchaseGiftRequest = data.purchaseGiftRequest,
				items = formatList,
				totalPriceInRobux = data.totalPriceInRobux,
				discountInformation = v13,
				senderRobuxBalance = data.senderRobuxBalance,
				recipient = v10,
				userRelationshipDetail = formatUserRelationshipDetail,
				freeAllowance = v14
			}
		end

		local freeAllowance = data.freeAllowance
		local v15, v16 = interface5(freeAllowance)
		local v17

		if v15 then
			v14 = {
				remaining = freeAllowance.remaining,
				granted = freeAllowance.granted,
				startTimeMs = freeAllowance.startTimeMs,
				endTimeMs = freeAllowance.endTimeMs
			}
		else
			v17 = `freeAllowance: {v16}`
		end

		if v14 == nil then
			return nil, v17
		end

		return {
			purchaseGiftRequest = data.purchaseGiftRequest,
			items = formatList,
			totalPriceInRobux = data.totalPriceInRobux,
			discountInformation = v13,
			senderRobuxBalance = data.senderRobuxBalance,
			recipient = v10,
			userRelationshipDetail = formatUserRelationshipDetail,
			freeAllowance = v14
		}
	end
}
