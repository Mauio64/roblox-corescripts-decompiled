local HttpService = game:GetService("HttpService")
local guid = HttpService:GenerateGUID(false)

return {
	getCartId = function() -- line: 5
		-- upvalues: guid (ref)
		return guid
	end,
	refreshCartId = function() -- line: 9
		-- upvalues: guid (ref), HttpService (copy)
		guid = HttpService:GenerateGUID(false)
	end
}
