local HttpService = game:GetService("HttpService")

require(script.Parent.Parent.Types.PurchaseItemsTypes)

local function getIsInsufficientRobuxError(p)
	local success, result = pcall(function(): boolean
		local message = HttpService:JSONDecode(p.Body).message or ""
		return string.find(message, "InsufficientTotalBalance") ~= nil
	end)
	return if success then result else false
end

return getIsInsufficientRobuxError
