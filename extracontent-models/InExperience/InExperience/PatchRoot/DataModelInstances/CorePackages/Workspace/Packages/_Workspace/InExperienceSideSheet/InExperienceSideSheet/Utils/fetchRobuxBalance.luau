local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")

local toEconomyCurrencyUrl = require(InExperienceSideSheet.Utils.toEconomyCurrencyUrl)
local extractRobuxBalance = require(InExperienceSideSheet.Utils.extractRobuxBalance)

local function fetchRobuxBalance(callback)
	HttpService:RequestInternal({
		Url = toEconomyCurrencyUrl(ContentProvider.BaseUrl),
		Method = "GET"
	}):Start(function(flag: boolean, p)
		if not flag then
			return
		end

		local success, result = pcall(HttpService.JSONDecode, HttpService, p.Body)

		if not success then
			return
		end

		local v = extractRobuxBalance(result)

		if v ~= nil then
			callback(v)
		end
	end)
end

return fetchRobuxBalance
