local MarketplaceService = game:GetService("MarketplaceService")

local function clearProductInfoCaches() -- line: 12
	-- upvalues: MarketplaceService (copy)
	pcall(function() -- line: 14
		-- upvalues: MarketplaceService (copy)
		MarketplaceService:clearProductInfoCaches()
	end)
end

return clearProductInfoCaches
