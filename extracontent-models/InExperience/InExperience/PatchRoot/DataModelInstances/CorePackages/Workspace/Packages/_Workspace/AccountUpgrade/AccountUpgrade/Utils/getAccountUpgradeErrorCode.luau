local HttpService = game:GetService("HttpService")

local function getAccountUpgradeErrorCode(p)
	local success, result = pcall(function()
		return HttpService:JSONDecode(p.Body)
	end)

	if success and type(result) == "table" then
		return result.errors and result.errors[1] and result.errors[1].code
	end

	return nil
end

return getAccountUpgradeErrorCode
