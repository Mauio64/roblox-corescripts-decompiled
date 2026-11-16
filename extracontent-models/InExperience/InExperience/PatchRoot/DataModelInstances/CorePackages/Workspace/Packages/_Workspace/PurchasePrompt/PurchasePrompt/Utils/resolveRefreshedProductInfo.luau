local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local mapCatalogDiscountInfoToPriceDiscountDetails = require(PurchasePrompt.Utils.mapCatalogDiscountInfoToPriceDiscountDetails)

local function resolveRefreshedProductInfo(data, p, p2: string?, p3: number?)
	if p2 and p2 ~= "" then
		local v = nil

		if p ~= nil and p.data ~= nil then
			for _, v2 in ipairs(p.data) do
				if v2.collectibleItemInstanceId == p2 then
					v = v2.price
					break
				end
			end
		end

		if v == nil and data ~= nil then
			v = data.lowestResalePrice
		end

		if v then
			return {
				refreshedExpectedPrice = v,
				PriceInRobux = v,
				UserBasePriceInRobux = nil,
				PriceDiscountDetails = nil
			}
		end
	elseif p3 and p3 ~= 0 then
		if data ~= nil and data.timedOptions then
			for _, timedOption in ipairs(data.timedOptions) do
				if timedOption.days == p3 then
					local userBasePriceInRobux = timedOption.price

					if timedOption.discountInformation and timedOption.discountInformation.originalPrice then
						userBasePriceInRobux = timedOption.discountInformation.originalPrice
					end

					return {
						refreshedExpectedPrice = timedOption.price,
						PriceInRobux = timedOption.price,
						UserBasePriceInRobux = userBasePriceInRobux,
						PriceDiscountDetails = mapCatalogDiscountInfoToPriceDiscountDetails(timedOption.discountInformation)
					}
				end
			end
		end
	elseif data ~= nil then
		return { refreshedExpectedPrice = data.price }
	end

	return nil
end

return resolveRefreshedProductInfo
