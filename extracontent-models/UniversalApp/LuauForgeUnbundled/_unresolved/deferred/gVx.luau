local MarketplaceService = game:GetService("MarketplaceService")

local module = require("@luauforge/bundled/egs")

return function(p2, value)
	local v5 = value or ""
	return module.new(function(callback, callback2)
		local success, result = pcall(function()
			MarketplaceService:PerformSubscriptionPurchaseV2(p2, v5)
		end)

		if success then
			callback(result)
		else
			callback2(result)
		end
	end)
end
