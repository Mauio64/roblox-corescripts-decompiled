local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")

require(Modules.LuaApp.Models.PremiumFeaturesApi.IAPProduct)

local _ = require(CorePackages.Workspace.Packages.PaymentsProtocol).PaymentsProtocol.default
local t1 = {}

function calculateMoreAmount(t2: {[any]: any}) -- line: 20
	if t2 == nil or #t2 == 0 then
		return {}
	end

	local v6 = nil

	for _, v8 in t2 do
		if v6 == nil or v8.robuxAmount < v6.robuxAmount then
			v6 = v8
		end
	end

	for _, v10 in t2 do
		local v11 = v10.robuxAmount - v6.robuxAmount * (v10.price / v6.price)

		if v11 > 0 then
			v10.robuxMoreAmount = math.floor((v11 + 50) / 100) * 100
		end
	end

	return t2
end
function t1.formatIapProducts(t3: {[any]: any}) -- line: 42
	local t4 = {}

	for _, v15 in t3 do
		table.insert(t4, {
			productId = v15.productId,
			price = v15.price,
			packageId = v15.mobileProductId,
			robuxAmount = v15.robuxAmount,
			currencyAmountStr = v15.currencySymbol .. tostring(v15.price)
		})
	end

	return calculateMoreAmount(t4)
end
function t1.formatNativeRobuxProducts(t5: {[any]: any}) -- line: 59
	local t6 = {}

	for _, v19 in t5 do
		table.insert(t6, {
			productId = v19.productId,
			price = v19.price,
			packageId = v19.nativeProductId,
			robuxAmount = v19.robuxAmount,
			currencyAmountStr = v19.displayPrice
		})
	end

	return calculateMoreAmount(t6)
end

return t1
