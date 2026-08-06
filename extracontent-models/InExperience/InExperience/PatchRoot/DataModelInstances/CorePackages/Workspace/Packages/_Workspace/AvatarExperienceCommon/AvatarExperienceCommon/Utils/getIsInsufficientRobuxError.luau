local HttpService = game:GetService("HttpService")

require(script.Parent.Parent.Types.PurchaseItemsTypes)

local function getIsInsufficientRobuxError(p1) -- line: 8
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 9
		-- upvalues: HttpService (copy), p1 (copy)
		local v6 = HttpService:JSONDecode(p1.Body).message or ""

		return string.find(v6, "InsufficientTotalBalance") ~= nil
	end)

	if not ok then
		return false
	end

	return result
end

return getIsInsufficientRobuxError
