local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")
local Modules = CoreGui.RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)

return function(s1: string, s2: string?) -- line: 6
	-- upvalues: Promise (copy), MarketplaceService (copy)
	local v7 = s2 or ""

	return Promise.new(function(resolve, reject) -- line: 8
		-- upvalues: MarketplaceService (copy), s1 (copy), v7 (copy)
		local ok, result = pcall(function() -- line: 9
			-- upvalues: MarketplaceService (copy), s1 (copy), v7 (copy)
			MarketplaceService:PerformSubscriptionPurchaseV2(s1, v7)
		end)

		if ok then
			resolve(result)

			return
		end

		reject(result)
	end)
end
