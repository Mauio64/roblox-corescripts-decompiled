local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local t1 = {
	new = function() -- line: 15
		return {
			price = 0,
			productId = 0,
			purchased = false,
			receipt = "",
			success = false,
			transactionStatus = ""
		}
	end
}

function t1.fromJsonData(p1) -- line: 26
	-- upvalues: t1 (copy), ArgCheck (copy)
	local v5 = t1.new()

	ArgCheck.isType(p1, "table", "PurchaseDeveloperProductModel.fromJsonData's jsonData")
	ArgCheck.isType(p1.price, "number", "PurchaseDeveloperProductModel.fromJsonData's jsonData.price")
	ArgCheck.isType(p1.productId, "number", "PurchaseDeveloperProductModel.fromJsonData's jsonData.productId")
	ArgCheck.isType(p1.purchased, "boolean", "PurchaseDeveloperProductModel.fromJsonData's jsonData.purchased")
	ArgCheck.isTypeOrNil(p1.receipt, "string", "PurchaseDeveloperProductModel.fromJsonData's jsonData.receipt")
	ArgCheck.isTypeOrNil(p1.success, "boolean", "PurchaseDeveloperProductModel.fromJsonData's jsonData.success")
	ArgCheck.isTypeOrNil(p1.transactionStatus, "string", "PurchaseDeveloperProductModel.fromJsonData's jsonData.transactionStatus")

	if type(p1) == "table" then
		v5.price = p1.price
		v5.productId = p1.productId
		v5.purchased = p1.purchased == true
		v5.receipt = p1.receipt
		v5.success = p1.success == true
		v5.transactionStatus = p1.transactionStatus
	end

	return v5
end

return t1
