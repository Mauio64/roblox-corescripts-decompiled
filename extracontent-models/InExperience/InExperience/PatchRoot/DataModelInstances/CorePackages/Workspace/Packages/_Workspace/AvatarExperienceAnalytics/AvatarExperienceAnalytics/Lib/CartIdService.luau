local HttpService = game:GetService("HttpService")

local cartId = HttpService:GenerateGUID(false)
local CartIdService = {}

function CartIdService.getCartId()
	return cartId
end

function CartIdService.refreshCartId()
	cartId = HttpService:GenerateGUID(false)
end

return CartIdService
