local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local t1 = {
	new = function() -- line: 12
		return {}
	end
}

function t1.fromJsonData(p1) -- line: 16
	-- upvalues: t1 (copy), ArgCheck (copy)
	local v5 = t1.new()

	ArgCheck.isType(p1, "table", "PurchaseProduct.fromJsonData's jsonData")
	ArgCheck.isType(p1.purchased, "boolean", "PurchaseProduct.fromJsonData's jsonData.purchased")
	ArgCheck.isType(p1.productId, "number", "PurchaseProduct.fromJsonData's jsonData.productId")
	ArgCheck.isTypeOrNil(p1.title, "string", "PurchaseProduct.fromJsonData's jsonData.title")
	ArgCheck.isTypeOrNil(p1.showDivId, "string", "PurchaseProduct.fromJsonData's jsonData.showDivId")
	ArgCheck.isTypeOrNil(p1.shortfallPrice, "number", "PurchaseProduct.fromJsonData's jsonData.shortfallPrice")
	ArgCheck.isTypeOrNil(p1.statusCode, "number", "PurchaseProduct.fromJsonData's jsonData.statusCode")

	if type(p1) == "table" then
		v5.purchased = p1.purchased == true
		v5.productId = tonumber(p1.productId)
		v5.title = p1.title
		v5.showDivId = p1.showDivId
		v5.shortfallPrice = p1.shortfallPrice
		v5.statusCode = p1.statusCode
	end

	return v5
end

return t1
