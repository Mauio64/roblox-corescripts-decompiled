local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

local Constants = require(InExperienceShop.Constants)
require(InExperienceShop.Types)

local function formatCurrencyAmountStr(currencySymbol: string, amount: number) -- 1 equivalent call inferred from this helper
	return currencySymbol .. string.format("%.2f", amount)
end

local function warnParseFailure(data, p: string) -- 5 equivalent calls inferred from this helper
	warn("[Shop] toRobuxPackageItem failed (" .. p .. ") id=" .. tostring(data.id))
end

local function parseBonusItem(data) -- 1 equivalent call inferred from this helper
	local bonusItem = data.bonusItem

	if bonusItem == nil then
		return nil
	end

	if bonusItem.type == "GamePass" then
		return bonusItem
	end

	warn("[Shop] toRobuxPackageItem ignored bonusItem with invalid type=" .. tostring(bonusItem.type) .. " id=" .. tostring(data.id))

	return nil
end

return {
	toRobuxPackageItem = function(data)
		if data.type ~= "Robux" then
			return nil
		end

		local info = data.info

		if info == nil then
			warnParseFailure(data, "missing info") -- inferred equivalent call
			return nil
		end

		local robux = info.robux
		local productId = info.productId
		local providerProductId = info.providerProductId
		local price = info.price

		if typeof(robux) ~= "number" or typeof(productId) ~= "number" then
			warnParseFailure(data, "invalid robux or productId") -- inferred equivalent call
			return nil
		end

		if typeof(providerProductId) ~= "string" or providerProductId == "" then
			warnParseFailure(data, "missing providerProductId") -- inferred equivalent call
			return nil
		end

		if price == nil or typeof(price.amount) ~= "number" then
			warnParseFailure(data, "missing price.amount") -- inferred equivalent call
			return nil
		end

		local currency = price.currency

		if currency == nil or typeof(currency.currencySymbol) ~= "string" or currency.currencySymbol == "" then
			warnParseFailure(data, "missing price.currency.currencySymbol") -- inferred equivalent call
			return nil
		end

		return {
			id = tostring(data.id),
			robuxAmount = robux,
			currencyAmountStr = formatCurrencyAmountStr(currency.currencySymbol, price.amount), -- inferred equivalent call
			robuxImage = Constants.ROBUX_PACKAGE_IMAGE,
			productId = productId,
			mobileProductId = providerProductId,
			bonusItem = parseBonusItem(data) -- inferred equivalent call
		}
	end
}
