local module = require("@luauforge/bundled/fIE")

local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local internalWrapper = module.NetworkLayers.requestInternalWrapper(HttpService)

return {
	fetchProductInfo = function(p2)
		return MarketplaceService:GetProductInfoAsync(p2)
	end,
	fetchUniverseId = function(p2)
		local v5, v6 = internalWrapper(`{module.Url.APIS_URL}universes/v1/places/{p2}/universe`, "GET"):await()

		if not v5 then
			return nil
		end

		if v6 and v6.responseBody then
			return v6.responseBody.universeId
		end

		return nil
	end
}
