local HttpService = game:GetService("HttpService")

local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")

local CATALOG_URL = require(CatalogNetworking.CATALOG_URL)

local function fetchItemDetails(callback, items)
	local jsonEncode = HttpService:JSONEncode({ items = items })

	return callback(`{CATALOG_URL}/v1/catalog/items/details`, "POST", { postBody = jsonEncode }):andThen(function(p)
		return p.responseBody
	end):catch(function(p): nil
		warn("[CatalogNetworking] fetchItemDetails failed:", (tostring(p)))
		return nil
	end)
end

return fetchItemDetails
