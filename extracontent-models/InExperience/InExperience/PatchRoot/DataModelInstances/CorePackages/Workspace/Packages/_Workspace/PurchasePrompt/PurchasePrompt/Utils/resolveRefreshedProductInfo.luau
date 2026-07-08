local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local mapCatalogDiscountInfoToPriceDiscountDetails = require(PurchasePrompt.Utils.mapCatalogDiscountInfoToPriceDiscountDetails)

local function resolveRefreshedProductInfo(p1, p2, s1: string?, n1: number?) -- line: 11
	-- upvalues: mapCatalogDiscountInfoToPriceDiscountDetails (copy)
	if s1 and s1 ~= "" then
		local price = nil

		if p2 ~= nil and p2.data ~= nil then
			for _, v in ipairs(p2.data) do
				if s1 == v.collectibleItemInstanceId then
					price = v.price

					break
				end
			end
		end

		if price == nil and p1 ~= nil then
			price = p1.lowestResalePrice
		end

		if price then
			return {
				UserBasePriceInRobux = nil,
				PriceDiscountDetails = nil,
				refreshedExpectedPrice = price,
				PriceInRobux = price
			}
		end
	elseif n1 and n1 ~= 0 then
		if p1 ~= nil and p1.timedOptions then
			for _, v in ipairs(p1.timedOptions) do
				if n1 == v.days then
					local price = v.price

					if v.discountInformation and v.discountInformation.originalPrice then
						price = v.discountInformation.originalPrice
					end

					return {
						refreshedExpectedPrice = v.price,
						PriceInRobux = v.price,
						UserBasePriceInRobux = price,
						PriceDiscountDetails = mapCatalogDiscountInfoToPriceDiscountDetails(v.discountInformation)
					}
				end
			end
		end
	elseif p1 ~= nil then
		return {
			refreshedExpectedPrice = p1.price
		}
	end

	return nil
end

return resolveRefreshedProductInfo
