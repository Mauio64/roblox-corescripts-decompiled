local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)
require(script.Parent.Parent.BulkPurchaseRequestItem)
local getThumbnailUrl = require(BulkPurchaseApp.Utils.getThumbnailUrl)
local FFlagBulkPurchaseEnablePurchaseOptions = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseEnablePurchaseOptions)
local FFlagBulkPurchaseUsesPurchaseOptionDiscount = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseUsesPurchaseOptionDiscount)

local function getTimedOptionDays(purchaseOptions)
	for _, item in purchaseOptions do
		if item.purchaseOptionType == "timedOption" and item.durationInSeconds then
			local v = math.floor(item.durationInSeconds / 86400)
			return if v > 0 then v else nil
		end
	end

	return nil
end

local function createPurchasableItem(data)
	local timedOptionDays

	if FFlagBulkPurchaseEnablePurchaseOptions and data.purchaseOptions then
		timedOptionDays = getTimedOptionDays(data.purchaseOptions)
	end

	local priceRobux = data.priceRobux
	local originalPrice = nil

	if FFlagBulkPurchaseUsesPurchaseOptionDiscount then
		if data.purchaseOptions then
			local purchaseOption = data.purchaseOptions[1]

			if purchaseOption then
				if purchaseOption.priceRobux ~= nil then
					priceRobux = purchaseOption.priceRobux
				end

				if purchaseOption.discountInformation then
					originalPrice = purchaseOption.discountInformation.originalPrice
				end
			end
		end
	else
		originalPrice = data.discountInformation and data.discountInformation.originalPrice
	end

	return {
		id = data.id,
		cost = priceRobux,
		name = data.name,
		image = getThumbnailUrl(data.id, data.type),
		originalPrice = originalPrice,
		timedOptionDays = timedOptionDays
	}
end

return createPurchasableItem
