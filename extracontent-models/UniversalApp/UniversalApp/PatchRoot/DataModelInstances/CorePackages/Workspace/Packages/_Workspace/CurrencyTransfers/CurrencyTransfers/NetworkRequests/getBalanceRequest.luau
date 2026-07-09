local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local _ = CurrencyTransfers.Parent
local ContentProvider = game:GetService("ContentProvider")
local HttpRequest = require(CurrencyTransfers.NetworkRequests.HttpRequest)

local function getEconomyUserCurrencyUrl() -- line: 10
	-- upvalues: ContentProvider (copy)
	local v7 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
	local v8 = string.gsub(v7, "http:", "https:")

	return string.gsub(v8, "https://www.", "https://economy.") .. "v1/user/currency"
end
local function getBalanceRequest(p1) -- line: 18
	-- upvalues: HttpRequest (copy), getEconomyUserCurrencyUrl (copy)
	return HttpRequest.new(p1):get((getEconomyUserCurrencyUrl())):andThen(function(p2) -- line: 21
		return ((if p2.robux == nil then p2.Robux else p2.robux)) or 0
	end)
end

return getBalanceRequest
