local module = require("@luauforge/bundled/dwL")

local v5 = {}

function v5.new()
	return {}
end

function v5.fromJsonData(data)
	local v6 = v5.new()

	module.isType(data, "table", "PurchaseProduct.fromJsonData's jsonData")
	module.isType(data.purchased, "boolean", "PurchaseProduct.fromJsonData's jsonData.purchased")
	module.isType(data.productId, "number", "PurchaseProduct.fromJsonData's jsonData.productId")

	module.isTypeOrNil(data.title, "string", "PurchaseProduct.fromJsonData's jsonData.title")
	module.isTypeOrNil(data.showDivId, "string", "PurchaseProduct.fromJsonData's jsonData.showDivId")
	module.isTypeOrNil(
		data.shortfallPrice,
		"number",
		"PurchaseProduct.fromJsonData's jsonData.shortfallPrice"
	)
	module.isTypeOrNil(data.statusCode, "number", "PurchaseProduct.fromJsonData's jsonData.statusCode")

	if type(data) ~= "table" then
		return v6
	end

	v6.purchased = data.purchased == true
	v6.productId = tonumber(data.productId)
	v6.title = data.title
	v6.showDivId = data.showDivId
	v6.shortfallPrice = data.shortfallPrice
	v6.statusCode = data.statusCode

	return v6
end

return v5
