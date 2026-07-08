local HttpService = game:GetService("HttpService")
local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local CATALOG_URL = require(CatalogNetworking.CATALOG_URL)

local function fetchItemDetails(p1, t1: {[any]: any}) -- line: 7
	-- upvalues: HttpService (copy), CATALOG_URL (copy)
	local json = HttpService:JSONEncode({
		items = t1
	})

	return p1(`{ CATALOG_URL }/v1/catalog/items/details`, "POST", {
		postBody = json
	}):andThen(function(p2) -- line: 12
		return p2.responseBody
	end):catch(function(p3) -- line: 15
		warn("[CatalogNetworking] fetchItemDetails failed:", (tostring(p3)))

		return nil
	end)
end

return fetchItemDetails
