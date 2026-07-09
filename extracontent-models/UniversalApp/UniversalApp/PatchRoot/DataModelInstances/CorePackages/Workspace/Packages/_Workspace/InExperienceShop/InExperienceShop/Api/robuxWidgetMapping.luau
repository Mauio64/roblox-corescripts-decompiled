local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local Constants = require(InExperienceShop.Constants)

require(InExperienceShop.Types)

local function formatCurrencyAmountStr(s1: string, n1: number) -- line: 10
	return s1 .. string.format("%.2f", n1)
end
local function warnParseFailure(p1, s2: string) -- line: 14
	warn("[Shop] toRobuxPackageItem failed (" .. s2 .. ") id=" .. tostring(p1.id))
end
local function parseBonusItem(p2) -- line: 18
	local bonusItem = p2.bonusItem

	if bonusItem == nil then
		return nil
	end

	if bonusItem.type ~= "GamePass" then
		warn("[Shop] toRobuxPackageItem ignored bonusItem with invalid type=" .. tostring(bonusItem.type) .. " id=" .. tostring(p2.id))

		return nil
	end

	return bonusItem
end

return {
	toRobuxPackageItem = function(p3) -- line: 37
		-- upvalues: Constants (copy)
		if p3.type ~= "Robux" then
			return nil
		end

		local info = p3.info

		if info == nil then
			warn("[Shop] toRobuxPackageItem failed (" .. "missing info" .. ") id=" .. tostring(p3.id))

			return nil
		end

		local robux = info.robux
		local productId = info.productId
		local providerProductId = info.providerProductId
		local price = info.price

		if typeof(robux) ~= "number" or typeof(productId) ~= "number" then
			warn("[Shop] toRobuxPackageItem failed (" .. "invalid robux or productId" .. ") id=" .. tostring(p3.id))

			return nil
		end

		if typeof(providerProductId) ~= "string" or providerProductId == "" then
			warn("[Shop] toRobuxPackageItem failed (" .. "missing providerProductId" .. ") id=" .. tostring(p3.id))

			return nil
		end

		if price == nil or typeof(price.amount) ~= "number" then
			warn("[Shop] toRobuxPackageItem failed (" .. "missing price.amount" .. ") id=" .. tostring(p3.id))

			return nil
		end

		local currency = price.currency

		if currency == nil or typeof(currency.currencySymbol) ~= "string" or currency.currencySymbol == "" then
			warn("[Shop] toRobuxPackageItem failed (" .. "missing price.currency.currencySymbol" .. ") id=" .. tostring(p3.id))

			return nil
		end

		local t1 = {
			id = tostring(p3.id),
			robuxAmount = robux
		}
		local currencySymbol = currency.currencySymbol
		local amount = price.amount

		t1.currencyAmountStr = currencySymbol .. string.format("%.2f", amount)
		t1.robuxImage = Constants.ROBUX_PACKAGE_IMAGE
		t1.productId = productId
		t1.mobileProductId = providerProductId

		local bonusItem = p3.bonusItem

		if bonusItem == nil then
			bonusItem = nil
		elseif bonusItem.type ~= "GamePass" then
			warn("[Shop] toRobuxPackageItem ignored bonusItem with invalid type=" .. tostring(bonusItem.type) .. " id=" .. tostring(p3.id))
			bonusItem = nil
		end

		t1.bonusItem = bonusItem

		return t1
	end
}
