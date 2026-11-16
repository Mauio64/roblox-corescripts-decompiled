local parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local Promise = require(parent.Promise)
local MarketplaceService = game:GetService("MarketplaceService")

local function getUserSubscriptionDetails(_, p)
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return MarketplaceService:GetUserSubscriptionDetailsInternalAsync(p)
		end)

		if success then
			callback(result)
		else
			callback2(result)
		end
	end)
end

return getUserSubscriptionDetails
