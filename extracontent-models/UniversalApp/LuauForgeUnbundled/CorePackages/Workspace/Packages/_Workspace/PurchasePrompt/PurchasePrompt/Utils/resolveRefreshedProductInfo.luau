local mapCatalogDiscountInfoToPriceDiscountDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/mapCatalogDiscountInfoToPriceDiscountDetails")

local function resolveRefreshedProductInfo(data, p2, p3, p4)
	if p3 and p3 ~= "" then
		local v5 = nil

		if p2 ~= nil and p2.data ~= nil then
			for i, v7 in ipairs(p2.data) do
				if v7.collectibleItemInstanceId == p3 then
					v5 = v7.price
					break
				end
			end
		end

		if v5 == nil and data ~= nil then
			v5 = data.lowestResalePrice
		end

		if v5 then
			return {
				refreshedExpectedPrice = v5,
				PriceInRobux = v5,
				UserBasePriceInRobux = nil,
				PriceDiscountDetails = nil
			}
		end
	elseif p4 and p4 ~= 0 then
		if data ~= nil and data.timedOptions then
			for i, timedOption in ipairs(data.timedOptions) do
				if timedOption.days == p4 then
					local v5 = timedOption.price

					if
						timedOption.discountInformation
						and timedOption.discountInformation.originalPrice
					then
						v5 = timedOption.discountInformation.originalPrice
					end

					return {
						refreshedExpectedPrice = timedOption.price,
						PriceInRobux = timedOption.price,
						UserBasePriceInRobux = v5,
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
