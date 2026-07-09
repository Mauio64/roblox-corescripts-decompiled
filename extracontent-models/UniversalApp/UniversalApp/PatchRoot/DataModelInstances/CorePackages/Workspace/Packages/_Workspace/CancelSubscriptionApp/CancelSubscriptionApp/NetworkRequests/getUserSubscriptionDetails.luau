local Parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local Promise = require(Parent.Promise)
local MarketplaceService = game:GetService("MarketplaceService")

local function getUserSubscriptionDetails(_, p2) -- line: 6
	-- upvalues: Promise (copy), MarketplaceService (copy)
	return Promise.new(function(resolve, reject) -- line: 7
		-- upvalues: MarketplaceService (copy), p2 (copy)
		local ok, result = pcall(function() -- line: 8
			-- upvalues: MarketplaceService (copy), p2 (copy)
			return MarketplaceService:GetUserSubscriptionDetailsInternalAsync(p2)
		end)

		if ok then
			resolve(result)

			return
		end

		reject(result)
	end)
end

return getUserSubscriptionDetails
