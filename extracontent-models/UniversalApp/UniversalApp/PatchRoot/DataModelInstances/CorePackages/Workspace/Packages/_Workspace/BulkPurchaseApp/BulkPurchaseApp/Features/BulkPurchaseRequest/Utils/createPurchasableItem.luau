local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)
require(script.Parent.Parent.BulkPurchaseRequestItem)

local getThumbnailUrl = require(BulkPurchaseApp.Utils.getThumbnailUrl)
local FFlagBulkPurchaseEnablePurchaseOptions = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseEnablePurchaseOptions)
local FFlagBulkPurchaseUsesPurchaseOptionDiscount = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseUsesPurchaseOptionDiscount)

local function getTimedOptionDays(t1: {[any]: any}) -- line: 16
	for _, v9 in t1 do
		if v9.purchaseOptionType == "timedOption" and v9.durationInSeconds then
			local v10 = math.floor(v9.durationInSeconds / 86400)

			if v10 > 0 then
				return v10
			end

			return nil
		end
	end

	return nil
end
local function createPurchasableItem(p1) -- line: 29
	-- upvalues: FFlagBulkPurchaseEnablePurchaseOptions (copy), getTimedOptionDays (copy), FFlagBulkPurchaseUsesPurchaseOptionDiscount (copy), getThumbnailUrl (copy)
	local v12 = if not FFlagBulkPurchaseEnablePurchaseOptions or not p1.purchaseOptions then nil else getTimedOptionDays(p1.purchaseOptions)
	local priceRobux = p1.priceRobux
	local originalPrice = nil

	if FFlagBulkPurchaseUsesPurchaseOptionDiscount then
		if p1.purchaseOptions then
			local v15 = p1.purchaseOptions[1]

			if v15 then
				if v15.priceRobux ~= nil then
					priceRobux = v15.priceRobux
				end

				if v15.discountInformation then
					originalPrice = v15.discountInformation.originalPrice
				end
			end
		end
	else
		originalPrice = p1.discountInformation and p1.discountInformation.originalPrice
	end

	return {
		id = p1.id,
		cost = priceRobux,
		name = p1.name,
		image = getThumbnailUrl(p1.id, p1.type),
		originalPrice = originalPrice,
		timedOptionDays = v12
	}
end

return createPurchasableItem
