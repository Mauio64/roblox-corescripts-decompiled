local HttpService = game:GetService("HttpService")

local cartId = HttpService:GenerateGUID(false)

return {
	getCartId = function()
		return cartId
	end,
	refreshCartId = function()
		cartId = HttpService:GenerateGUID(false)
	end
}
