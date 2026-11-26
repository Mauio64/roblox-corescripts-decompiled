local ContentProvider = game:GetService("ContentProvider")

local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/NetworkRequests/HttpRequest")

local function getEconomyUserCurrencyUrl()
	local v5 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
	local v6 = string.gsub(v5, "http:", "https:")
	return string.gsub(v6, "https://www.", "https://economy.") .. "v1/user/currency"
end

local function getBalanceRequest(p2, p3)
	local v5 = if p3 == nil then HttpRequest.new(p2) else HttpRequest.fromNetworkImpl(p3)
	return v5:get(getEconomyUserCurrencyUrl()):andThen(function(p4)
		return (if p4.robux == nil then p4.Robux else p4.robux) or 0
	end)
end

return getBalanceRequest
