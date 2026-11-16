local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local ContentProvider = game:GetService("ContentProvider")

local HttpRequest = require(CurrencyTransfers.NetworkRequests.HttpRequest)

local function getEconomyUserCurrencyUrl()
	local v = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
	local v2 = string.gsub(v, "http:", "https:")
	return string.gsub(v2, "https://www.", "https://economy.") .. "v1/user/currency"
end

local function getBalanceRequest(p, p2)
	local v

	if p2 == nil then
		v = HttpRequest.new(p)
	else
		v = HttpRequest.fromNetworkImpl(p2)
	end

	return v:get(getEconomyUserCurrencyUrl()):andThen(function(p3)
		local v2 = if p3.robux == nil then p3.Robux else p3.robux
		return v2 or 0
	end)
end

return getBalanceRequest
