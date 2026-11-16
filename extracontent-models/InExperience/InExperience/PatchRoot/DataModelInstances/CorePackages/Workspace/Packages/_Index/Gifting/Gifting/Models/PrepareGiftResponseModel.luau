local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local t = require(parent.t)

local GiftModelUtils = require(Gifting.Models.GiftModelUtils)
require(Gifting.Types)

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
	local v, v2 = interface(data)

	if not v then
		return nil, `item: {v2}`
	end

	local formatItem, v3 = GiftModelUtils.formatItem(data.item)

	if formatItem == nil then
		return nil, v3
	end

	return {
		item = formatItem,
		name = data.name or "",
		thumbnailUrl = data.thumbnailUrl or "",
		priceInRobux = data.priceInRobux
	}
end

local function formatDiscountDetail(data)
	local v, v2 = interface2(data)

	if v then
		return {
			robuxDiscountAmount = data.robuxDiscountAmount,
			robuxDiscountPercentage = data.robuxDiscountPercentage,
			discountCampaign = data.discountCampaign or "",
			localizedDiscountAttribution = data.localizedDiscountAttribution or ""
		}
	end

	return nil, `discount: {v2}`
end

local function formatDiscountInformation(discountInformation)
	local v, v2 = interface3(discountInformation)

	if not v then
		return nil, `discountInformation: {v2}`
	end

	local formatList, v3 = GiftModelUtils.formatList(
		"discounts",
		discountInformation.discounts or {},
		formatDiscountDetail
	)

	if formatList == nil then
		return nil, v3
	end

	return {
		originalPrice = discountInformation.originalPrice,
		totalDiscountPercentage = discountInformation.totalDiscountPercentage,
		totalDiscountAmount = discountInformation.totalDiscountAmount,
		discounts = formatList
	}
end

local function formatRecipientInfo(data)
	local v, v2 = interface4(data)

	if v then
		return {
			userId = data.userId,
			displayName = data.displayName or "",
			thumbnailUrl = data.thumbnailUrl or ""
		}
	end

	return nil, `recipient: {v2}`
end

local function formatFreeAllowance(data)
	local v, v2 = interface5(data)

	if v then
		return {
			remaining = data.remaining,
			granted = data.granted,
			startTimeMs = data.startTimeMs,
			endTimeMs = data.endTimeMs
		}
	end

	return nil, `freeAllowance: {v2}`
end

return {
	format = function(self)
		local v, v2 = interface6(self)

		if not v then
			return nil, v2
		end

		local formatList, v3 = GiftModelUtils.formatList("items", self.items, formatItemDetail)

		if formatList == nil then
			return nil, v3
		end

		local recipient = self.recipient
		local v4, v5 = interface4(recipient)
		local recipient2, v6

		if v4 then
			recipient2 = {
				userId = recipient.userId,
				displayName = recipient.displayName or "",
				thumbnailUrl = recipient.thumbnailUrl or ""
			}
		else
			v6 = `recipient: {v5}`
		end

		if recipient2 == nil then
			return nil, v6
		end

		local formatUserRelationshipDetail, v7 = GiftModelUtils.formatUserRelationshipDetail(self.userRelationshipDetail)

		if formatUserRelationshipDetail == nil then
			return nil, v7
		end

		local discountInformation

		if self.discountInformation ~= nil then
			local v8
			discountInformation, v8 = formatDiscountInformation(self.discountInformation)

			if discountInformation == nil then
				return nil, v8
			end
		end

		local freeAllowance2

		if self.freeAllowance == nil then
			return {
				purchaseGiftRequest = self.purchaseGiftRequest,
				items = formatList,
				totalPriceInRobux = self.totalPriceInRobux,
				discountInformation = discountInformation,
				senderRobuxBalance = self.senderRobuxBalance,
				recipient = recipient2,
				userRelationshipDetail = formatUserRelationshipDetail,
				freeAllowance = freeAllowance2
			}
		end

		local freeAllowance = self.freeAllowance
		local v8, v9 = interface5(freeAllowance)
		local v10

		if v8 then
			freeAllowance2 = {
				remaining = freeAllowance.remaining,
				granted = freeAllowance.granted,
				startTimeMs = freeAllowance.startTimeMs,
				endTimeMs = freeAllowance.endTimeMs
			}
		else
			v10 = `freeAllowance: {v9}`
		end

		if freeAllowance2 == nil then
			return nil, v10
		end

		return {
			purchaseGiftRequest = self.purchaseGiftRequest,
			items = formatList,
			totalPriceInRobux = self.totalPriceInRobux,
			discountInformation = discountInformation,
			senderRobuxBalance = self.senderRobuxBalance,
			recipient = recipient2,
			userRelationshipDetail = formatUserRelationshipDetail,
			freeAllowance = freeAllowance2
		}
	end
}
