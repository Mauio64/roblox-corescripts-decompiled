local MarketplaceService = game:GetService("MarketplaceService")

local function clearProductInfoCaches()
	pcall(function()
		MarketplaceService:clearProductInfoCaches()
	end)
end

return clearProductInfoCaches
